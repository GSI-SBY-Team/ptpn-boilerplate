package auth

import (
	"crypto/md5"
	"encoding/hex"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gofrs/uuid"
	"golang.org/x/crypto/bcrypt"

	"ptpn-go-boilerplate/shared"
	"ptpn-go-boilerplate/shared/failure"
)

type User struct {
	ID                   uuid.UUID         `json:"id" db:"id"`
	Name                 string            `json:"name" db:"name"`
	Username             string            `json:"username" db:"username"`
	Email                *string           `json:"email" db:"email"`
	Password             string            `json:"password" db:"password"`
	RoleId               string            `json:"roleId" db:"role_id"`
	PersonId             *int              `json:"personId" db:"person_id"`
	CommodityId          *int              `json:"commodityId" db:"commodity_id"`
	Status               *string           `json:"status" db:"status"`
	Foto                 *string           `json:"foto" db:"foto"`
	Active               bool              `db:"active" json:"active"`
	ManualProduksiTph    *bool             `db:"manual_produksi_tph" json:"manualProduksiTph"`
	ManualProduksiPabrik *bool             `db:"manual_produksi_pabrik" json:"manualProduksiPabrik"`
	TolehKanan           *bool             `db:"toleh_kanan" json:"tolehKanan"`
	TolehKiri            *bool             `db:"toleh_kiri" json:"tolehKiri"`
	PabrikId             *int              `json:"pabrikId" db:"pabrik_id"`
	Trigger              *bool             `db:"trigger" json:"trigger"`
	TraceHold            *float64          `db:"tracehold" json:"tracehold"`
	CreatedBy            *uuid.UUID        `db:"created_by" json:"createdBy"`
	UpdatedBy            *uuid.UUID        `db:"updated_by" json:"updatedBy"`
	CreatedAt            time.Time         `db:"created_at" json:"createdAt"`
	UpdatedAt            *time.Time        `db:"updated_at" json:"updatedAt"`
	DeletedAt            *time.Time        `db:"deleted_at" json:"deletedAt"`
	IsDeleted            bool              `db:"is_deleted" json:"isDeleted"`
	Commodities          []UserHasComodity `db:"-" json:"commodities"`
}

// UserUpdateFormat
type UserUpdateFormat struct {
	ID                   uuid.UUID                `json:"id" db:"id"`
	Name                 string                   `json:"name" db:"name"`
	Username             string                   `json:"username" db:"username"`
	Email                *string                  `json:"email" db:"email"`
	Password             string                   `json:"password" db:"password"`
	RoleId               string                   `json:"roleId" db:"roleId"`
	PersonId             *int                     `json:"personId" db:"person_id"`
	CommodityId          *int                     `json:"commodityId" db:"commodity_id"`
	Status               *string                  `json:"status" db:"status"`
	Foto                 *string                  `json:"foto" db:"foto"`
	Active               bool                     `json:"active" db:"active"`
	ManualProduksiTph    *bool                    `db:"manual_produksi_tph" json:"manualProduksiTph"`
	ManualProduksiPabrik *bool                    `db:"manual_produksi_pabrik" json:"manualProduksiPabrik"`
	TolehKanan           *bool                    `db:"toleh_kanan" json:"tolehKanan"`
	TolehKiri            *bool                    `db:"toleh_kiri" json:"tolehKiri"`
	PabrikId             *int                     `json:"pabrikId" db:"pabrik_id"`
	Trigger              *bool                    `db:"trigger" json:"trigger"`
	TraceHold            *float64                 `db:"tracehold" json:"tracehold"`
	UserID               uuid.UUID                `json:"-"`
	Commodities          []UserHasComodityRequest `db:"-" json:"commodities"`
}

// UserUpdateFcmTokenFormat
type UserUpdateFcmTokenFormat struct {
	ID            uuid.UUID `json:"id" db:"id"`
	FirebaseToken *string   `json:"firebaseToken" db:"firebase_token"`
}

// UserDTO digunakan untuk model join ke Role
type UserDTO struct {
	ID                   uuid.UUID         `json:"id" db:"id"`
	Name                 string            `json:"name" db:"name"`
	Username             string            `json:"username" db:"username"`
	Email                *string           `json:"email" db:"email"`
	Password             string            `json:"password" db:"password"`
	RoleId               string            `json:"roleId" db:"role_id"`
	PersonId             *int              `json:"personId" db:"person_id"`
	PersonName           *string           `json:"personName" db:"person_name"`
	Nik                  *string           `json:"nik" db:"nik"`
	Role                 *string           `json:"role" db:"role"`
	CommodityId          *int              `json:"commodityId" db:"commodity_id"`
	Commodity            *string           `json:"commodity" db:"commodity"`
	Status               *string           `json:"status" db:"status"`
	Foto                 *string           `json:"foto" db:"foto"`
	Active               bool              `db:"active" json:"active"`
	ManualProduksiTph    *bool             `db:"manual_produksi_tph" json:"manualProduksiTph"`
	ManualProduksiPabrik *bool             `db:"manual_produksi_pabrik" json:"manualProduksiPabrik"`
	TolehKanan           *bool             `db:"toleh_kanan" json:"tolehKanan"`
	TolehKiri            *bool             `db:"toleh_kiri" json:"tolehKiri"`
	PabrikId             *int              `json:"pabrikId" db:"pabrik_id"`
	IotFactoryId         *string           `json:"iotFactoryId" db:"iot_factory_id"`
	Trigger              *bool             `db:"trigger" json:"trigger"`
	TraceHold            *float64          `db:"tracehold" json:"tracehold"`
	Kebun                *string           `json:"namaKebun" db:"nama_kebun"`
	Afdeling             *string           `json:"namaAfdeling" db:"nama_afdeling"`
	PositionsDesc        *string           `json:"positionsDesc" db:"positionsdesc"`
	IsDeleted            bool              `db:"is_deleted" json:"isDeleted"`
	Commodities          []UserHasComodity `db:"-" json:"commodities"`
}

// UserDTO digunakan untuk model join ke Role
type UserRoleDTO struct {
	ID            uuid.UUID `json:"id" db:"id"`
	Username      string    `json:"username" db:"username"`
	Email         string    `json:"email" db:"email"`
	Status        *string   `json:"status" db:"status"`
	FirebaseToken *string   `json:"firebaseToken" db:"firebase_token"`
	IsDeleted     bool      `json:"isDeleted" db:"is_deleted"`
	RoleID        *string   `json:"roleId" db:"role_id"`
	Role          *string   `json:"role" db:"name"`
}

// Multi Role

type UserHasComodity struct {
	ID         uuid.UUID  `json:"id" db:"id"`
	ComodityId int        `db:"comodity_id" json:"comodityId"`
	IdUser     string     `json:"idUser" db:"id_user"`
	Nama       *string    `json:"nama" db:"nama"`
	Kode       *string    `json:"kode" db:"kode"`
	CreatedAt  time.Time  `json:"createdAt" db:"created_at"`
	UpdatedAt  *time.Time `json:"updatedAt" db:"updated_at"`
	IsDeleted  bool       `db:"is_deleted" json:"isDeleted"`
}
type UserHasComodityRequest struct {
	Id         *string `db:"id" json:"id"`
	ComodityId int     `db:"comodity_id" json:"comodityId"`
}

type StatusLogin string

const (
	SuccessLogin StatusLogin = "success"
	FailedLogin  StatusLogin = "failed"
)

type LoginActivity struct {
	ID       uuid.UUID   `json:"id" db:"id"`
	Username string      `json:"username" db:"username"`
	Status   StatusLogin `json:"status" db:"status"`
	Jam      time.Time   `json:"jam" db:"jam"`
}

func NewCreateActivityLogin(username string, status StatusLogin) LoginActivity {
	loginActivityID, _ := uuid.NewV4()
	return LoginActivity{
		ID:       loginActivityID,
		Username: username,
		Status:   status,
		Jam:      time.Now(),
	}
}

// InputUser is struct as register json body
type InputUser struct {
	Name                 string                   `json:"name" db:"name"`
	Username             string                   `json:"username" db:"username"`
	Email                *string                  `json:"email" db:"email"`
	Password             string                   `json:"password" db:"password"`
	RoleId               string                   `json:"roleId" db:"roleId"`
	PersonId             *int                     `json:"personId" db:"person_id"`
	CommodityId          *int                     `json:"commodityId" db:"commodity_id"`
	Status               *string                  `json:"status" db:"status"`
	Active               bool                     `db:"active" json:"active"`
	ManualProduksiTph    *bool                    `db:"manual_produksi_tph" json:"manualProduksiTph"`
	ManualProduksiPabrik *bool                    `db:"manual_produksi_pabrik" json:"manualProduksiPabrik"`
	TolehKanan           *bool                    `db:"toleh_kanan" json:"tolehKanan"`
	TolehKiri            *bool                    `db:"toleh_kiri" json:"tolehKiri"`
	PabrikId             *int                     `json:"pabrikId" db:"pabrik_id"`
	Trigger              *bool                    `db:"trigger" json:"trigger"`
	TraceHold            *float64                 `db:"tracehold" json:"tracehold"`
	Commodities          []UserHasComodityRequest `json:"commodities" db:"-"`
}

// Validate digunakan untuk memvalidasi inputan user
func (i InputUser) Validate() error {
	v := shared.GetValidator()
	v.RegisterValidation("alphaspace", shared.AlphaSpace)
	v.RegisterValidation("alphanumspace", shared.AlphaNumSpace)

	return v.Struct(i)
}

// CreateUser is function to parse from user input to user struct
func (i InputUser) CreateUser() User {
	userID, _ := uuid.NewV4()

	hash, _ := bcrypt.GenerateFromPassword([]byte(i.Password), bcrypt.DefaultCost)
	var user = User{
		ID:                   userID,
		RoleId:               i.RoleId,
		Username:             i.Username,
		Name:                 i.Name,
		Status:               i.Status,
		Password:             string(hash),
		Email:                i.Email,
		PersonId:             i.PersonId,
		CommodityId:          i.CommodityId,
		ManualProduksiTph:    i.ManualProduksiTph,
		ManualProduksiPabrik: i.ManualProduksiPabrik,
		TolehKanan:           i.TolehKanan,
		TolehKiri:            i.TolehKiri,
		PabrikId:             i.PabrikId,
		Trigger:              i.Trigger,
		TraceHold:            i.TraceHold,
		CreatedAt:            time.Now(),
	}
	details := make([]UserHasComodity, 0)
	for _, req := range i.Commodities {
		var detID uuid.UUID
		if req.Id == nil {
			detID, _ = uuid.NewV4()
		} else {
			detID, _ = uuid.FromString(*req.Id)
		}

		newRole := UserHasComodity{
			ID:         detID,
			ComodityId: req.ComodityId,
			IdUser:     userID.String(),
			CreatedAt:  time.Now(),
		}
		details = append(details, newRole)
	}

	user.Commodities = details
	return user
}

// CreateUser is function to parse from user input to user struct
func (i InputUser) Registrasi() User {
	userID, _ := uuid.NewV4()

	hash, _ := bcrypt.GenerateFromPassword([]byte(i.Password), bcrypt.DefaultCost)
	return User{
		ID:          userID,
		RoleId:      i.RoleId,
		Username:    i.Username,
		Password:    string(hash),
		PersonId:    i.PersonId,
		CommodityId: i.CommodityId,
	}
}

type InputChangePassword struct {
	OldPassword string `json:"oldPassword" validate:"required,min=6"`
	NewPassword string `json:"newPassword" validate:"required,min=6"`
}

// Update is function to transform into to User entity
func (i InputChangePassword) Update(user User) (User, error) {
	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(i.OldPassword))
	if err != nil {
		return User{}, failure.Conflict("update password", "password", "old password does not match with the current password")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(i.NewPassword))
	if err == nil {
		return User{}, failure.Conflict("update password", "password", "new password match with the current password")
	}

	newPassword, _ := bcrypt.GenerateFromPassword([]byte(i.NewPassword), bcrypt.DefaultCost)
	now := time.Now()
	return User{
		ID:                   user.ID,
		RoleId:               user.RoleId,
		Username:             user.Username,
		Password:             string(newPassword),
		Email:                user.Email,
		PersonId:             user.PersonId,
		CommodityId:          user.CommodityId,
		Active:               user.Active,
		ManualProduksiTph:    user.ManualProduksiTph,
		ManualProduksiPabrik: user.ManualProduksiPabrik,
		TolehKanan:           user.TolehKanan,
		TolehKiri:            user.TolehKiri,
		PabrikId:             user.PabrikId,
		Trigger:              user.Trigger,
		TraceHold:            user.TraceHold,
		UpdatedAt:            &now,
	}, nil
}

// ResetPasswdUpdate is function to transform into to User entity
func (i InputChangePassword) ResetPasswdUpdate(user User) (User, error) {
	newPassword, _ := bcrypt.GenerateFromPassword([]byte(i.NewPassword), bcrypt.DefaultCost)
	return User{
		ID:          user.ID,
		RoleId:      user.RoleId,
		CommodityId: user.CommodityId,
		PersonId:    user.PersonId,
		Username:    user.Username,
		Password:    string(newPassword),
	}, nil
}

// Update is function to transform into to User entity
func (i UserUpdateFormat) Update(user UserUpdateFormat) (User, error) {
	// newPassword, _ := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	now := time.Now()
	return User{
		ID:                   user.ID,
		RoleId:               user.RoleId,
		Username:             user.Username,
		Name:                 user.Name,
		Status:               user.Status,
		Email:                user.Email,
		PersonId:             user.PersonId,
		CommodityId:          user.CommodityId,
		Active:               user.Active,
		ManualProduksiTph:    user.ManualProduksiTph,
		ManualProduksiPabrik: user.ManualProduksiPabrik,
		TolehKanan:           user.TolehKanan,
		TolehKiri:            user.TolehKiri,
		PabrikId:             user.PabrikId,
		Trigger:              user.Trigger,
		TraceHold:            user.TraceHold,
		UpdatedAt:            &now,
	}, nil
}

func (u *User) UpdateUserFormat(id uuid.UUID, user UserUpdateFormat) {
	now := time.Now()
	u.ID = user.ID
	u.RoleId = user.RoleId
	u.PersonId = user.PersonId
	u.CommodityId = user.CommodityId
	u.Username = user.Username
	u.Name = user.Name
	u.Email = user.Email
	u.Status = user.Status
	u.UpdatedAt = &now
	u.UpdatedBy = &user.UserID
	u.ManualProduksiTph = user.ManualProduksiTph
	u.ManualProduksiPabrik = user.ManualProduksiPabrik
	u.TolehKanan = user.TolehKanan
	u.TolehKiri = user.TolehKiri
	u.PabrikId = user.PabrikId
	u.Trigger = user.Trigger
	u.TraceHold = user.TraceHold

	details := make([]UserHasComodity, 0)
	for _, req := range user.Commodities {
		var detID uuid.UUID
		if req.Id == nil {
			detID, _ = uuid.NewV4()
		} else {
			detID, _ = uuid.FromString(*req.Id)
		}

		newRole := UserHasComodity{
			ID:         detID,
			ComodityId: req.ComodityId,
			IdUser:     id.String(),
			CreatedAt:  time.Now(),
		}

		details = append(details, newRole)
	}

	u.Commodities = details

	// generate new password
	if user.Password != "" {
		hash, _ := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
		u.Password = string(hash)
	}
}

// Update is function to transform into to User entity untuk update token fcm
func (i UserUpdateFcmTokenFormat) UpdateFcmToken(user UserUpdateFcmTokenFormat) (User, error) {
	return User{
		ID: user.ID,
	}, nil
}

// InputLogin is struct as login json body
type InputLogin struct {
	Username string `json:"username" validate:"required"`
	Password string `json:"password" validate:"required"`
	// RoleID   string `json:"roleId"`
}

// Response is represent respond login
func (r *InputLogin) Response(user UserDTO, role Role, person *PersonData, komoditas []Komoditas, jenisPengolahan []JenisPengolahan, accessToken string) ResponseLogin {
	return ResponseLogin{
		Token: ResponseLoginToken{
			AccessToken: accessToken,
		},
		User: ResponseLoginUser{
			ID:                   user.ID,
			RoleId:               user.RoleId,
			Username:             user.Username,
			Name:                 user.Name,
			Status:               user.Status,
			Email:                user.Email,
			PersonId:             user.PersonId,
			Person:               user.PersonName,
			Nik:                  user.Nik,
			CommodityId:          user.CommodityId,
			Commodity:            user.Commodity,
			ManualProduksiTph:    user.ManualProduksiTph,
			ManualProduksiPabrik: user.ManualProduksiPabrik,
			TolehKanan:           user.TolehKanan,
			TolehKiri:            user.TolehKiri,
			PabrikId:             user.PabrikId,
			IotFactoryId:         user.IotFactoryId,
			Trigger:              user.Trigger,
			TraceHold:            user.TraceHold,
			Foto:                 user.Foto,
			Role:                 role,
			Komoditas:            komoditas,
			JenisPengolahan:      jenisPengolahan,
		},
	}
}

// ResponseLogin is result processing from login process
type ResponseLogin struct {
	Token ResponseLoginToken `json:"token"`
	User  ResponseLoginUser  `json:"user"`
}

// ResponseLoginUser deliver result of user entity
type ResponseLoginUser struct {
	ID                   uuid.UUID         `json:"id"`
	Name                 string            `json:"name" db:"name"`
	Username             string            `json:"username" db:"username"`
	Email                *string           `json:"email" db:"email"`
	Status               *string           `json:"status" db:"status"`
	RoleId               string            `json:"roleId" db:"role_id"`
	PersonId             *int              `json:"personId" db:"person_id"`
	Person               *string           `json:"person" db:"person"`
	Nik                  *string           `json:"nik" db:"nik"`
	CommodityId          *int              `json:"commodityId" db:"commodity_id"`
	Commodity            *string           `json:"commodity" db:"commodity"`
	FirebaseToken        *string           `json:"firebaseToken"`
	Foto                 *string           `json:"foto" db:"foto"`
	ManualProduksiTph    *bool             `json:"manualProduksiTph" db:"manual_produksi_tph"`
	ManualProduksiPabrik *bool             `json:"manualProduksiPabrik" db:"manual_produksi_pabrik"`
	TolehKanan           *bool             `json:"tolehKanan" db:"toleh_kanan"`
	TolehKiri            *bool             `json:"tolehKiri" db:"toleh_kiri"`
	PabrikId             *int              `json:"pabrikId" db:"pabrik_id"`
	IotFactoryId         *string           `json:"iotFactoryId" db:"iot_factory_id"`
	Trigger              *bool             `db:"trigger" json:"trigger"`
	TraceHold            *float64          `db:"tracehold" json:"tracehold"`
	Role                 Role              `json:"role"`
	Komoditas            []Komoditas       `json:"komoditas"`
	JenisPengolahan      []JenisPengolahan `json:"jenisPengolahan"`
}

// ResponseLoginToken deliver result of user token
type ResponseLoginToken struct {
	AccessToken string
}

// NewUserLoginClaims digunakan untuk mengeset nilai dari JWT
func NewUserLoginClaims(user UserDTO, person *PersonData, expiredIn int) jwt.MapClaims {
	claims := jwt.MapClaims{}
	claims["userId"] = user.ID
	claims["personId"] = user.PersonId
	claims["roleId"] = user.RoleId
	claims["commodityId"] = user.CommodityId
	if person != nil {
		claims["regionalId"] = person.RegionalID
		claims["kebunId"] = person.KebunID
		claims["afdelingId"] = person.AfdelingID
	}
	claims["iat"] = time.Now().Unix()
	claims["exp"] = time.Now().Add(time.Duration(expiredIn) * time.Hour).Unix()

	return claims
}

func GetMD5Hash(text string) string {
	hasher := md5.New()
	hasher.Write([]byte(text))
	return hex.EncodeToString(hasher.Sum(nil))
}

// SoftDelete untuk mengeset flag isDeleted
func (u *User) SoftDelete(userID uuid.UUID) {
	now := time.Now()
	u.Active = false
	u.IsDeleted = true
	u.DeletedAt = &now
}

func (u *User) Aktif(userID uuid.UUID) {
	var now = time.Now()
	u.IsDeleted = false
	u.UpdatedBy = &userID
	u.UpdatedAt = &now
}

func (u *User) SoftActive(userID uuid.UUID) {
	now := time.Now()
	u.Active = true
	u.IsDeleted = false
	u.DeletedAt = &now
}

type ModelUpdateFoto struct {
	Id        uuid.UUID  `db:"id" json:"id"`
	Foto      string     `json:"foto" db:"foto"`
	UpdatedAt *time.Time `db:"updated_at" json:"updatedAt"`
	UpdatedBy *uuid.UUID `db:"updated_by" json:"updatedBy"`
}

type UpdateFotoRequest struct {
	Id       uuid.UUID `db:"id" json:"id"`
	Foto     string    `json:"file" db:"foto"`
	FotoLama string    `db:"foto_lama" json:"fotoLama"`
}

var ColumnMappUser = map[string]interface{}{
	"id":            "u.id",
	"name":          "u.name",
	"username":      "u.username",
	"email":         "u.email",
	"password":      "u.password",
	"roleId":        "u.role_id",
	"role":          "r.name",
	"personId":      "u.person_id",
	"personName":    "k.nama",
	"namaKebun":     "mk.nama",
	"namaAfdeling":  "ma.nama",
	"positionsDesc": "k.positionsdesc",
	"commodityId":   "u.commodity_id",
	"commodity":     "mc.commodity",
	"createdAt":     "u.created_at",
	"updatedAt":     "u.updated_at",
	"createdBy":     "u.created_by",
	"updatedBy":     "u.updated_by",
}

type PersonData struct {
	ID                 int     `db:"id" json:"id"`
	NIK                *string `db:"nik" json:"nik"`
	Nama               string  `db:"nama" json:"nama"`
	RegionalID         *int    `db:"regional_id" json:"regionalId"`
	Register           *string `db:"register" json:"register"`
	PersonelSubareanew *string `db:"personelsubareanew" json:"personelSubareanew"`
	NamaKebun          *string `db:"nama_kebun" json:"namaKebun"`
	PositionsDesc      *string `db:"positionsdesc" json:"positionsDesc"`
	Afdeling           *string `db:"afdeling" json:"afdeling"`
	KebunID            *int    `db:"kebun_id" json:"kebunId"`
	AfdelingID         *int    `db:"afdeling_id" json:"afdelingId"`
	KodeKebun          *string `db:"kode_kebun" json:"kodeKebun"`
	KodeAfdeling       *string `db:"kode_afdeling" json:"kodeAfdeling"`
}

type Komoditas struct {
	Id   *int    `db:"id" json:"id"`
	Kode *string `db:"kode" json:"kode"`
	Nama *string `db:"nama" json:"nama"`
}

type JenisPengolahan struct {
	Id   *int    `db:"id" json:"id"`
	Nama *string `db:"nama" json:"nama"`
}
