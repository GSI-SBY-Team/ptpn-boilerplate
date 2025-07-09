package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/internal/domain/master"
	"ptpn-go-boilerplate/shared"
	"ptpn-go-boilerplate/shared/failure"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/transport/http/middleware"
	"ptpn-go-boilerplate/transport/http/response"
	"strconv"

	"github.com/go-chi/chi"
	"github.com/gofrs/uuid"
)

type RegionalHandler struct {
	RegionalService master.RegionalService
	Config          *configs.Config
}

func ProvideRegionalHandler(service master.RegionalService, config *configs.Config) RegionalHandler {
	return RegionalHandler{
		RegionalService: service,
		Config:          config,
	}
}

func (h *RegionalHandler) Router(r chi.Router, middleware *middleware.JWT) {
	r.Route("/master/regional", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middleware.VerifyToken)
			r.Get("/", h.ResolveAll)
			r.Get("/all", h.GetAllData)
			r.Post("/", h.Create)
			r.Put("/", h.Update)
			r.Get("/{id}", h.ResolveByID)
			r.Delete("/{id}", h.Delete)
		})
	})
}

// ResolveAll list data Regional.
// @Summary Get list data Regional.
// @Description endpoint ini digunakan untuk mendapatkan seluruh data Regional sesuai dengan filter yang dikirimkan.
// @Tags regional
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param q query string false "Keyword search"
// @Param pageSize query int true "Set pageSize data"
// @Param pageNumber query int true "Set page number"
// @Param sortBy query string false "Set sortBy parameter is one of [ keterangan | nama | alamat ]"
// @Param sortType query string false "Set sortType with asc or desc"
// @Success 200 {object} master.Regional
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/master/regional [get]
func (h *RegionalHandler) ResolveAll(w http.ResponseWriter, r *http.Request) {
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

	req := model.StandardRequest{
		Keyword:    keyword,
		PageSize:   pageSize,
		PageNumber: pageNumber,
		SortBy:     sortBy,
		SortType:   sortType,
	}

	err = shared.GetValidator().Struct(req)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	status, err := h.RegionalService.ResolveAll(req)
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, status)
}

// GetDataAll list all Regional.
// @Summary Get list all Regional.
// @Description endpoint ini digunakan untuk mendapatkan seluruh data Regional sesuai dengan filter yang dikirimkan.
// @Tags regional
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Success 200 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/master/regional/all [get]
func (h *RegionalHandler) GetAllData(w http.ResponseWriter, r *http.Request) {

	status, err := h.RegionalService.GetAll()
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, status)
}

// createRegional adalah untuk menambah data Regional.
// @Summary menambahkan data Regional.
// @Description Endpoint ini adalah untuk menambahkan data Regional.
// @Tags regional
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param Regional body master.RegionalFormat true "Regional yang akan ditambahkan"
// @Success 200 {object} response.Base{data=master.Regional}
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/master/regional [post]
func (h *RegionalHandler) Create(w http.ResponseWriter, r *http.Request) {
	var reqFormat master.RegionalFormat
	err := json.NewDecoder(r.Body).Decode(&reqFormat)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	if err != nil {
		fmt.Print("error user id")
		response.WithError(w, failure.BadRequest(err))
		return
	}

	reqFormat.UserID = userID
	newData, err := h.RegionalService.Create(reqFormat)
	if err != nil {
		fmt.Print("error response")
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusCreated, newData)
}

// UpdateRegional adalah untuk merubah data Regional.
// @Summary merubah data Regional
// @Description Endpoint ini adalah untuk merubah data Regional.
// @Tags regional
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param Regional body master.RegionalFormat true "Regional yang akan dirubah"
// @Success 200 {object} response.Base{data=master.Regional}
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/master/regional/{id} [put]
func (h *RegionalHandler) Update(w http.ResponseWriter, r *http.Request) {
	var reqFormat master.RegionalFormat
	err := json.NewDecoder(r.Body).Decode(&reqFormat)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}
	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	if err != nil {
		fmt.Print("error user id")
		response.WithError(w, failure.BadRequest(err))
		return
	}

	reqFormat.UserID = userID
	newRegional, err := h.RegionalService.Update(reqFormat)
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, newRegional)
}

// ResolveByID adalah untuk mendapatkan satu data Regional berdasarkan ID.
// @Summary Mendapatkan satu data Regional berdasarkan ID.
// @Description Endpoint ini adalah untuk mendapatkan Regional By ID.
// @Tags regional
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "ID"
// @Success 200 {object} response.Base{data=master.Regional}
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/master/regional/{id} [get]
func (h *RegionalHandler) ResolveByID(w http.ResponseWriter, r *http.Request) {
	ID, err := strconv.Atoi(chi.URLParam(r, "id"))
	if err != nil {
		response.WithError(w, err)
		return
	}

	data, err := h.RegionalService.ResolveByID(ID)
	if err != nil {
		response.WithError(w, err)
		return
	}
	response.WithJSON(w, http.StatusOK, data)
}

// delete adalah untuk menghapus data Regional.
// @Summary menghapus data Regional.
// @Description Endpoint ini adalah untuk menghapus data Regional.
// @Tags regional
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param id path string true "ID"
// @Success 200 {object} response.Base
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/master/regional/{id} [delete]
func (h *RegionalHandler) Delete(w http.ResponseWriter, r *http.Request) {
	ID, err := strconv.Atoi(chi.URLParam(r, "id"))
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

	err = h.RegionalService.Delete(ID, userID)
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, "success")
}
