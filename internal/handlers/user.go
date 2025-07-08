package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"ptpn-go-boilerplate/configs"
	"strconv"

	"ptpn-go-boilerplate/internal/domain/auth"
	"ptpn-go-boilerplate/shared"
	"ptpn-go-boilerplate/shared/failure"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/transport/http/middleware"
	"ptpn-go-boilerplate/transport/http/response"

	"github.com/go-chi/chi"
	"github.com/gofrs/uuid"
)

// UserHandler the HTTP handler for User domain.
type UserHandler struct {
	UserService auth.UserService
	Config      *configs.Config
}

// ProvideUserHandler is the provider for this handler.
func ProvideUserHandler(userService auth.UserService) UserHandler {
	return UserHandler{
		UserService: userService,
	}
}

// Router sets up the router for this domain.
func (u *UserHandler) Router(r chi.Router, middleware *middleware.JWT) {
	r.Route("/user", func(r chi.Router) {
		r.Post("/login", u.Login)
		r.Post("/validasi-login", u.ValidasiLogin)
		r.Route("/", func(r chi.Router) {
			r.Use(middleware.VerifyToken)
			r.Post("/", u.CreateUser)
			r.Put("/{id}", u.UpdateUser)
			r.Put("/fcm-token/{id}", u.UpdateUserFcmToken)
			r.Delete("/{id}", u.DeleteUser)
			r.Put("/aktif/{id}", u.AktifUser)
			r.Put("/aktif-user/{id}", u.Aktif)
			r.Get("/", u.ResolveAll)
			r.Get("/{id}", u.ResolveUserById)
			r.Put("/password/{id}", u.ChangePassword)
			r.Put("/password/pw/{id}", u.ChangePassword)
			r.Put("/password/reset/{id}", u.ResetPassword)
			r.Post("/update-foto", u.UpdateFoto)
		})
	})
}

// ValidasiLogin sign in a user
// @Summary sign in a user
// @Description This endpoint sign in a user
// @Tags users
// @Param users body auth.InputLogin true "The User to be sign in."
// @Produce json
// @Success 201 {object} response.Base{auth.ResponseLogin}
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/validasi-login [post]
func (u *UserHandler) ValidasiLogin(w http.ResponseWriter, r *http.Request) {
	var input auth.InputLogin
	fmt.Println("INPUT:", input)
	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = shared.GetValidator().Struct(input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	resp, exist, err := u.UserService.ValidasiLogin(input)
	if !exist {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithJSON(w, http.StatusOK, resp)
}

// Login sign in a user
// @Summary sign in a user
// @Description This endpoint sign in a user
// @Tags users
// @Param users body auth.InputLogin true "The User to be sign in."
// @Produce json
// @Success 201 {object} response.Base{auth.ResponseLogin}
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/login [post]
func (u *UserHandler) Login(w http.ResponseWriter, r *http.Request) {
	var input auth.InputLogin
	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = shared.GetValidator().Struct(input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	fmt.Println("ip address : ", r.Header.Get("x-forwarded-for"))

	resp, _, _, err := u.UserService.Login(input, r.Header.Get("x-forwarded-for"), r.UserAgent())
	if err != nil {
		resJson := map[string]interface{}{
			"success": false,
			"message": err.Error(),
		}
		response.WithJSON(w, http.StatusOK, resJson)
		return
	}

	response.WithJSON(w, http.StatusOK, resp)
}

// CreateUser creates a new user
// @Summary Create a new User.
// @Description This endpoint creates a new User.
// @Tags users
// @Param Authorization header string true "Bearer <token>"
// @Param users body auth.InputUser true "The User to be created."
// @Produce json
// @Success 201 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user [post]
func (u *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {

	var input auth.InputUser
	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = input.Validate()
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}
	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	exist, err := u.UserService.CreateUser(input, userID, r.Header.Get("x-forwarded-for"), r.UserAgent())
	if exist {
		response.WithError(w, failure.Conflict("register", "user", err.Error()))
		return
	}

	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithMessage(w, http.StatusOK, "success")
}

// ChangePassword update user password
// @Summary update user password
// @Description This endpoint to update user password
// @Tags users
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "The User identifier."
// @Param users body auth.InputChangePassword true "The User update a new password."
// @Produce json
// @Success 201 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/password/{id} [put]
func (u *UserHandler) ChangePassword(w http.ResponseWriter, r *http.Request) {
	var input auth.InputChangePassword

	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = shared.GetValidator().Struct(input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	id, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = u.UserService.ChangePassword(id, input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	payload := map[string]interface{}{
		"success": true,
		"message": "Password berhasil diperbarui",
	}
	response.WithJSON(w, http.StatusOK, payload)
}

// ResetPassword reset user password
// @Summary reset user password
// @Description This endpoint to reset user password
// @Tags users
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "The User identifier."
// @Param users body auth.InputChangePassword true "The User reset a new password."
// @Produce json
// @Success 201 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/password/reset/{id} [put]
func (u *UserHandler) ResetPassword(w http.ResponseWriter, r *http.Request) {
	var input auth.InputChangePassword

	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = shared.GetValidator().Struct(input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	id, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = u.UserService.ResetPassword(id, input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	payload := map[string]interface{}{
		"success": true,
		"message": "Password berhasil diperbarui",
	}
	response.WithJSON(w, http.StatusOK, payload)
}

// ResolveAll list all user.
// @Summary Get list all user.
// @Description endpoint ini digunakan untuk mendapatkan seluruh data user sesuai dengan filter yang dikirimkan.
// @Tags users
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param q query string false "Keyword search"
// @Param pageSize query int true "Set pageSize data"
// @Param pageNumber query int true "Set page number"
// @Param sortBy query string false "Set sortBy parameter is one of [id | kode | nama ]"
// @Param sortType query string false "Set sortType with asc or desc"
// @Param roleId query string false "id role"
// @Param regionalId query string false "regional Id"
// @Param kebunId query string false "kebun Id"
// @Param afdelingId query string false "afdeling Id"
// @Param status query bool false "status"
// @Success 200 {object} auth.UserDTO
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user [get]
func (h *UserHandler) ResolveAll(w http.ResponseWriter, r *http.Request) {
	keyword := r.URL.Query().Get("q")
	pageSizeStr := r.URL.Query().Get("pageSize")
	pageNumberStr := r.URL.Query().Get("pageNumber")
	sortBy := r.URL.Query().Get("sortBy")
	if sortBy == "" {
		sortBy = "createdAt"
	}

	sortType := r.URL.Query().Get("sortType")
	if sortType == "" {
		sortType = "DESC"
	}
	pageSize, err := strconv.Atoi(pageSizeStr)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	pageNumber, err := strconv.Atoi(pageNumberStr)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}
	roleId := r.URL.Query().Get("roleId")
	regionalId := r.URL.Query().Get("regionalId")
	kebunId := r.URL.Query().Get("kebunId")
	afdelingId := r.URL.Query().Get("afdelingId")
	statusQuery := r.URL.Query().Get("status")

	req := model.StandardRequestUser{
		Keyword:    keyword,
		PageSize:   pageSize,
		PageNumber: pageNumber,
		SortBy:     sortBy,
		SortType:   sortType,
		IdRole:     roleId,
		IdRegional: regionalId,
		IdKebun:    kebunId,
		IdAfdeling: afdelingId,
		Status:     statusQuery,
	}

	err = shared.GetValidator().Struct(req)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	status, err := h.UserService.ResolveAll(req)
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, status)
}

// UpdateUser update user data
// @Summary update user data
// @Description This endpoint to update user entity
// @Tags users
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "The User identifier."
// @Param users body auth.UserUpdateFormat true "The User update data"
// @Produce json
// @Success 201 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/{id} [put]
func (u *UserHandler) UpdateUser(w http.ResponseWriter, r *http.Request) {
	var input auth.UserUpdateFormat

	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = shared.GetValidator().Struct(input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	id, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}
	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	err = u.UserService.UpdateUser(id, input, userID, r.Header.Get("x-forwarded-for"), r.UserAgent())
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithMessage(w, http.StatusOK, "success")
}

// UpdateUserFcmToken update data fcm token user
// @Summary update data fcm token user
// @Description This endpoint to update user entity
// @Tags users
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "The User identifier."
// @Param users body auth.UserUpdateFcmTokenFormat true "The User update Fcm Token data"
// @Produce json
// @Success 201 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/fcm-token/{id} [put]
func (u *UserHandler) UpdateUserFcmToken(w http.ResponseWriter, r *http.Request) {

	var input auth.UserUpdateFcmTokenFormat

	err := json.NewDecoder(r.Body).Decode(&input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = shared.GetValidator().Struct(input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	id, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = u.UserService.UpdateUserFcmToken(id, input)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithMessage(w, http.StatusOK, "success")
}

// UpdateUser delete user data
// @Summary delete user data
// @Description This endpoint to delete user entity
// @Tags users
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "The User identifier."
// @Produce json
// @Success 201 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/{id} [delete]
func (u *UserHandler) DeleteUser(w http.ResponseWriter, r *http.Request) {
	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	id, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = u.UserService.SoftDelete(id, userID)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithJSON(w, http.StatusOK, "success")
}

// UpdateUser aktif user data
// @Summary aktif user data
// @Description This endpoint to aktif user entity
// @Tags users
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "The User identifier."
// @Produce json
// @Success 201 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 409 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/aktif/{id} [put]
func (u *UserHandler) AktifUser(w http.ResponseWriter, r *http.Request) {
	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	id, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	err = u.UserService.SoftAktif(id, userID)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithJSON(w, http.StatusOK, "success")
}

// Aktif adalah untuk mengaktifkan data User.
// @Summary mengaktifkan data User.
// @Description Endpoint ini adalah untuk mengaktifkan data User.
// @Tags users
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "ID"
// @Success 200 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/aktif-user/{id} [put]
func (u *UserHandler) Aktif(w http.ResponseWriter, r *http.Request) {
	ID, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, err)
		return
	}

	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	if err != nil {
		fmt.Print("error user id")
		response.WithError(w, failure.BadRequest(err))
		return
	}
	err = u.UserService.Aktif(ID, userID)
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, "success")
}

// ResolveUserByID adalah untuk mendapatkan satu data User berdasarkan ID.
// @Summary Mendapatkan satu data User berdasarkan ID.
// @Description Endpoint ini adalah untuk mendapatkan User ID.
// @Tags users
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "ID"
// @Success 200 {object} response.Base{data=auth.User}
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/{id} [get]
func (h *UserHandler) ResolveUserById(w http.ResponseWriter, r *http.Request) {
	ID, err := uuid.FromString(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, err)
		return
	}
	user, err := h.UserService.ResolveUserById(ID)
	if err != nil {
		response.WithError(w, err)
		return
	}
	response.WithJSON(w, http.StatusOK, user)
}

// UpdateFotoProfile adalah untuk mengupdate foto pegawai.
// @Summary mengupdate data foto pegawai.
// @Description Endpoint ini adalah untuk mengupdate data foto pegawai.
// @Tags users
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param id formData string false "id pegawai"
// @Param file formData file true "Foto Baru"
// @Success 200 {object} response.Base{data=auth.User}
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/user/update-foto [post]
func (u *UserHandler) UpdateFoto(w http.ResponseWriter, r *http.Request) {
	id := r.FormValue("id")
	userID, err := uuid.FromString(id)
	if err != nil {
		response.WithError(w, err)
		return
	}

	user, err := u.UserService.ResolveUserById(userID)
	if err != nil {
		response.WithError(w, err)
		return
	}

	uploadedFile, _, _ := r.FormFile("file")
	var path string
	if uploadedFile != nil {
		filepath, err := u.UserService.UploadFile(w, r, "")
		//fmt.Println(u.Config.App.File.FotoProfile)
		if err != nil {
			response.WithError(w, failure.BadRequest(err))
			return
		}
		path = filepath
	} else {
		path = ""
	}

	reqFormat := auth.UpdateFotoRequest{
		Id:   userID,
		Foto: path,
	}

	if user.Foto != nil {
		reqFormat.FotoLama = *user.Foto
	}

	_, err = u.UserService.UpdateFoto(reqFormat)
	if err != nil {
		fmt.Print("error response")
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithJSON(w, http.StatusCreated, "Update Foto Berhasil")
}
