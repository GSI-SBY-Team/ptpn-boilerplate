package auth

import (
	"database/sql"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gofrs/uuid"
	"github.com/rs/zerolog/log"
	"golang.org/x/crypto/bcrypt"

	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/shared/failure"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"
	"ptpn-go-boilerplate/transport/http/response"
)

// UserService is the service interface for User entities.
type UserService interface {
	CreateUser(input InputUser, userId uuid.UUID, ipAddress string, userAgent string) (bool, error)
	ChangePassword(id uuid.UUID, input InputChangePassword) error
	ResetPassword(id uuid.UUID, input InputChangePassword) error
	UpdateUser(id uuid.UUID, user UserUpdateFormat, userId uuid.UUID, ipAddress string, userAgent string) error
	UpdateUserFcmToken(id uuid.UUID, user UserUpdateFcmTokenFormat) error
	ValidasiLogin(input InputLogin) (user []User, exist bool, err error)
	Login(input InputLogin, ipAddress string, userAgent string) (ResponseLogin, bool, bool, error)
	ResolveAll(request model.StandardRequestUser) (orders pagination.Response, err error)
	ResolveUserById(id uuid.UUID) (user UserDTO, err error)
	Aktif(id uuid.UUID, userId uuid.UUID) error
	SoftDelete(id uuid.UUID, userID uuid.UUID) error
	SoftAktif(id uuid.UUID, userID uuid.UUID) error
	UpdateFoto(req UpdateFotoRequest) (data User, err error)
	UploadFile(w http.ResponseWriter, r *http.Request, path_file string) (path string, err error)
}

// ServiceImpl is the service implementation for User entities.
type UserServiceImpl struct {
	Config              *configs.Config
	UserRepository      UserRepository
	RoleRepository      RoleRepository
	LogSystemRepository LogSystemRepository
}

// ResolveAll is a list of Proyek.
func (s *UserServiceImpl) ResolveAll(request model.StandardRequestUser) (orders pagination.Response, err error) {
	return s.UserRepository.ResolveAll(request)
}

// ProvideUserServiceImpl is the provider for this service.
func ProvideUserServiceImpl(userRepository UserRepository, roleRepository RoleRepository, config *configs.Config, LogSytemRepository LogSystemRepository) *UserServiceImpl {
	return &UserServiceImpl{
		Config:              config,
		UserRepository:      userRepository,
		RoleRepository:      roleRepository,
		LogSystemRepository: LogSytemRepository,
	}
}

// Validasi Login is the service to process user signin
func (u *UserServiceImpl) ValidasiLogin(input InputLogin) (user []User, exist bool, err error) {
	errs := make(chan error)
	username := make(chan string)
	go u.createLoginActivity(username, errs)
	username <- input.Username

	exist, err = u.UserRepository.ExistByUsername(input.Username)
	if !exist {
		err = errors.New("Username not found")
		errs <- err
		return
	}

	if err != nil {
		errs <- err
		return
	}

	user, err = u.UserRepository.ResolveUserByUsername(input.Username)
	if err != nil {
		errs <- err
		return
	}

	return
}

// Login is the service to process user signin
func (u *UserServiceImpl) Login(input InputLogin, ipAddress string, userAgent string) (response ResponseLogin, exist bool, existCekPegawai bool, err error) {
	errs := make(chan error)
	username := make(chan string)
	go u.createLoginActivity(username, errs)
	username <- input.Username

	exist, err = u.UserRepository.ExistByUsername(input.Username)
	if !exist {
		newID, _ := uuid.NewV4()
		var logSystem = LogSystem{
			ID:         newID,
			Actions:    "Login",
			Jam:        time.Now(),
			Keterangan: "Login Gagal Username Tidak Ditemukan",
			Platform:   "WEB",
			IpAddress:  ipAddress,
			UserAgent:  userAgent,
			Kode:       input.Username,
		}
		_ = u.LogSystemRepository.CreateLogSystem(logSystem)
		err = errors.New("Username tidak ditemukan")
		errs <- err
		return
	}

	if err != nil {
		errs <- err
		return
	}

	datauser, err := u.UserRepository.ResolveUserByUsernameRole(input.Username)
	if err != nil {
		errs <- err
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(datauser.Password), []byte(input.Password))
	if err != nil {
		newID, _ := uuid.NewV4()
		var logSystem = LogSystem{
			ID:         newID,
			Actions:    "Login",
			Jam:        time.Now(),
			Keterangan: "Login Gagal Password Tidak Cocok",
			Platform:   "WEB",
			IpAddress:  ipAddress,
			UserAgent:  userAgent,
			Kode:       datauser.ID.String(),
		}
		_ = u.LogSystemRepository.CreateLogSystem(logSystem)
		err = errors.New("Password salah")
		errs <- err
		return
	}

	role, err := u.RoleRepository.ResolveRoleByID(datauser.RoleId)
	if err != nil {
		errs <- err
		return
	}

	var komoditas []Komoditas
	if datauser.ID != uuid.Nil {
		komoditas, err = u.UserRepository.ResolveKomoditas(datauser.ID.String())
		if err != nil {
			errs <- fmt.Errorf("failed to resolve komotidas: %w", err)
			return
		}
	}

	var jenisPengolahan []JenisPengolahan
	if datauser.PabrikId != nil {
		jenisPengolahan, err = u.UserRepository.ResolveJenisPengolahan(*datauser.PabrikId)
		if err != nil {
			errs <- fmt.Errorf("failed to resolve jenispenoglahan: %w", err)
			return
		}
	}

	var person PersonData
	if datauser.PersonId != nil {
		person, err = u.UserRepository.ResolvePerson(*datauser.PersonId)
		if err != nil {
			errs <- fmt.Errorf("failed to resolve person: %w", err)
			return
		}
	}

	claims := jwt.NewWithClaims(jwt.SigningMethodHS256, NewUserLoginClaims(datauser, person, u.Config.Token.JWT.ExpiredInHour))
	token, err := claims.SignedString([]byte(u.Config.Token.JWT.AccessToken))
	if err != nil {
		errs <- err
		return
	}

	errs <- nil
	newID, _ := uuid.NewV4()
	var logSystem = LogSystem{
		ID:         newID,
		Actions:    "Login",
		Jam:        time.Now(),
		Keterangan: "Login Berhasil",
		Platform:   "WEB",
		IdUser:     datauser.ID,
		IpAddress:  ipAddress,
		UserAgent:  userAgent,
		Kode:       datauser.Username,
	}
	_ = u.LogSystemRepository.CreateLogSystem(logSystem)
	response = input.Response(datauser, role, person, komoditas, jenisPengolahan, string(token))
	return
}

// CreateUser is the service to creating user properties
func (u *UserServiceImpl) CreateUser(input InputUser, userId uuid.UUID, ipAddress string, userAgent string) (bool, error) {
	exist, err := u.UserRepository.ExistByUsername(input.Username)
	if exist {
		return exist, errors.New("Username Already Exist")
	}

	if err != nil {
		return exist, err
	}

	user := input.CreateUser()
	user.Active = true
	user.CreatedBy = &userId
	err = u.UserRepository.TransactionCreateUser(user)
	if err != nil {
		return exist, err
	}
	newID, _ := uuid.NewV4()
	var logSystem = LogSystem{
		ID:         newID,
		Actions:    "User",
		Jam:        time.Now(),
		Keterangan: "Create User Berhasil",
		Platform:   "WEB",
		IdUser:     userId,
		IpAddress:  ipAddress,
		UserAgent:  userAgent,
		Kode:       user.ID.String(),
	}
	err = u.LogSystemRepository.CreateLogSystem(logSystem)
	if err != nil {
		return exist, err
	}
	return exist, nil
}

// ChangePassword is the service function to update with a new password
func (u *UserServiceImpl) ChangePassword(id uuid.UUID, input InputChangePassword) error {
	user, err := u.UserRepository.ResolveUserByID(id)
	if err != nil {
		return err
	}
	user, err = input.Update(user)
	if err != nil {
		return err
	}

	return u.UserRepository.UpdateUserPassword(id, user)
}

// ResetPassword is the service function to update with a new password
func (u *UserServiceImpl) ResetPassword(id uuid.UUID, input InputChangePassword) error {
	user, err := u.UserRepository.ResolveUserByID(id)
	if err != nil {
		return err
	}
	user, err = input.ResetPasswdUpdate(user)
	if err != nil {
		return err
	}

	return u.UserRepository.UpdateUserPassword(id, user)
}

// UpdateUser is the service function to update user data
func (u *UserServiceImpl) UpdateUser(id uuid.UUID, input UserUpdateFormat, userId uuid.UUID, ipAddress string, userAgent string) error {
	user, err := u.UserRepository.ResolveUserByID(id)
	if err != nil {
		return errors.New("User dengan ID :" + id.String() + " tidak ditemukan")
	}

	input.UserID = userId
	user.UpdateUserFormat(id, input)

	newID, _ := uuid.NewV4()
	var logSystem = LogSystem{
		ID:         newID,
		Actions:    "User",
		Jam:        time.Now(),
		Keterangan: "Update User Berhasil",
		Platform:   "WEB",
		IdUser:     userId,
		IpAddress:  ipAddress,
		UserAgent:  userAgent,
		Kode:       id.String(),
	}
	_ = u.LogSystemRepository.CreateLogSystem(logSystem)
	return u.UserRepository.TransactionUpdateUser(user)
}

func (s *UserServiceImpl) Aktif(id uuid.UUID, userId uuid.UUID) error {
	newUser, err := s.UserRepository.ResolveUserByID(id)

	if err != nil || newUser.ID == uuid.Nil {
		return errors.New("Data User dengan ID tidak ditemukan")
	}

	newUser.Aktif(userId)
	err = s.UserRepository.UpdateUser(id, newUser)
	if err != nil {
		return errors.New("Ada kesalahan dalam mengaktifkan data User dengan ID ")
	}
	return nil
}

// UpdateUserFcmToken is the service function to update user data
func (u *UserServiceImpl) UpdateUserFcmToken(id uuid.UUID, input UserUpdateFcmTokenFormat) error {

	user, err := input.UpdateFcmToken(input)
	if err != nil {
		return err
	}
	return u.UserRepository.UpdateUserFcmToken(id, user)
}

func (u *UserServiceImpl) createLoginActivity(email chan string, errs chan error) {
	e, err := <-email, <-errs
	status := SuccessLogin
	if err != nil {
		status = FailedLogin
	}
	fmt.Println(status)
	fmt.Println(e)

	// loginActivity := NewCreateActivityLogin(e, status)
	// err = u.UserRepository.CreateLoginActivity(loginActivity)
	if err != nil {
		log.Error().Err(err).Msg("Failed creating login activity")
	}

	close(errs)
	close(email)
}

// SoftDelete
func (u *UserServiceImpl) SoftDelete(id uuid.UUID, userID uuid.UUID) (err error) {
	user, err := u.UserRepository.ResolveUserByID(id)
	if err != nil {
		return err
	}
	user.SoftDelete(userID)
	return u.UserRepository.UpdateUser(id, user)

}

// SoftDelete
func (u *UserServiceImpl) SoftAktif(id uuid.UUID, userID uuid.UUID) (err error) {
	user, err := u.UserRepository.ResolveUserByID(id)
	if err != nil {
		return err
	}
	user.SoftActive(userID)
	return u.UserRepository.UpdateUser(id, user)

}

// // .PushNotifById untuk kirim notif berdasarkan id user
// func (s *UserServiceImpl) PushNotifById(id uuid.UUID) (err error) {
// 	data, err := s.UserRepository.ResolveUserByID(id)
// 	if err != nil {
// 		return err
// 	}

// 	token := []string{data.FirebaseToken.String}

// 	payload := map[string]interface{}{
// 		"notification": map[string]string{
// 			"title": "Permohonan Otorisasi",
// 			"body":  "Mohon untuk di otorisasi transaksi ini",
// 		},
// 		"priority": "high",
// 		"data": map[string]string{
// 			"title":           "Permohonan Otorisasi",
// 			"message":         "Mohon untuk di otorisasi transaksi ini",
// 			"sound":           "default",
// 			"click_action":    "FLUTTER_NOTIFICATION_CLICK",
// 			"type":            "1",
// 			"image":           "null",
// 			"kode_notifikasi": "1",
// 		},
// 	}
// 	err = notification.PushNotification(payload, token)
// 	if err != nil {
// 		return err
// 	}
// 	return
// }

func (u *UserServiceImpl) ResolveUserById(id uuid.UUID) (user UserDTO, err error) {
	user, err = u.UserRepository.ResolveUserByIDDTO(id)
	if err == sql.ErrNoRows {
		err = failure.BadRequest(err)
		return
	}
	if err != nil {
		return
	}
	return
}

func (s *UserServiceImpl) UploadFile(w http.ResponseWriter, r *http.Request, path_file string) (path string, err error) {
	if err = r.ParseMultipartForm(1024); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	uploadedFile, handler, err := r.FormFile("file")
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}
	defer uploadedFile.Close()

	newID, _ := uuid.NewV4()
	filename := fmt.Sprintf("%s%s", "foto_user_"+newID.String(), filepath.Ext(handler.Filename))
	baseDir := s.Config.App.File.Dir
	publicDir := s.Config.App.File.FotoProfile
	dir := filepath.Join(baseDir, publicDir)

	fileLocation := filepath.Join(dir, filename)

	folder := filepath.Dir(fileLocation)

	if _, err := os.Stat(folder); os.IsNotExist(err) {
		err := os.MkdirAll(folder, os.ModePerm)
		if err != nil {
			log.Printf("Gagal membuat folder %s: %v", folder, err)
			return "", err
		}
	}

	targetFile, err := os.OpenFile(fileLocation, os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println("ERROR FILE:", err)
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return "", err
	}
	defer targetFile.Close()

	if _, err = io.Copy(targetFile, uploadedFile); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		fmt.Println("ERROR COPY FILE:", err)
		return "", err
	}
	path = publicDir + "/" + filename
	return path, nil
}

func (s *UserServiceImpl) UpdateFoto(req UpdateFotoRequest) (data User, err error) {
	if req.FotoLama != "" {
		dir := s.Config.App.File.Dir
		FotoProfile := req.FotoLama
		fileLocation := filepath.Join(dir, FotoProfile)
		err = os.Remove(fileLocation)
		if err != nil {
			log.Error().Msgf("service.Delete Foto Profile error", err)
		}
	}

	var now = time.Now()
	newData := ModelUpdateFoto{
		Id:        req.Id,
		Foto:      req.Foto,
		UpdatedAt: &now,
		UpdatedBy: &req.Id,
	}

	err = s.UserRepository.UpdateFoto(newData)

	if err != nil {
		log.Error().Msgf("service.Profile error", err)
	}
	return data, nil
}
