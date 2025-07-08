package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
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

type LogSystemHandler struct {
	LogSystemService auth.LogSystemService
}

func ProvideLogSystemHandler(LogSystemService auth.LogSystemService) LogSystemHandler {
	return LogSystemHandler{
		LogSystemService: LogSystemService,
	}
}

func (h *LogSystemHandler) Router(r chi.Router, middleware *middleware.JWT) {
	r.Route("/log-system", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middleware.VerifyToken)
			r.Post("/", h.CreateLogSystem)
			r.Get("/", h.ResolveAll)
		})
	})
}

// CreateLogSystem adalah untuk menambah data Log System.
// @Summary menambahkan data Log System.
// @Description Endpoint ini adalah untuk menambahkan data Log System.
// @Tags log-system
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param logSystem body auth.RequestLogSystemFormat true "Log System yang akan ditambahkan"
// @Success 200 {object} response.Base{data=[]auth.LogSystem}
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/log-system [post]
func (h *LogSystemHandler) CreateLogSystem(w http.ResponseWriter, r *http.Request) {
	var reqFormat auth.RequestLogSystemFormat
	fmt.Println("reqFormat", reqFormat)
	err := json.NewDecoder(r.Body).Decode(&reqFormat)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}
	userID, err := uuid.FromString(middleware.GetClaimsValue(r.Context(), "userId").(string))
	newMenu, err := h.LogSystemService.CreateLogSystem(reqFormat, userID, r.Header.Get("x-forwarded-for"), r.UserAgent())
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	response.WithJSON(w, http.StatusCreated, newMenu)
}

// ResolveAll list data Log System.
// @Summary Get list data Log System.
// @Description endpoint ini digunakan untuk mendapatkan seluruh data Log System sesuai dengan filter yang dikirimkan.
// @Tags log-system
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param q query string false "Keyword search"
// @Param pageSize query int true "Set pageSize data"
// @Param pageNumber query int true "Set page number"
// @Param sortBy query string false "Set sortBy parameter is one of [ kode | nama ]"
// @Param sortType query string false "Set sortType with asc or desc"
// @Param idRole query string false "Set id role"
// @Success 200 {object} auth.LogSystemDto
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/log-system [get]
func (h *LogSystemHandler) ResolveAll(w http.ResponseWriter, r *http.Request) {
	keyword := r.URL.Query().Get("q")
	pageSizeStr := r.URL.Query().Get("pageSize")
	pageNumberStr := r.URL.Query().Get("pageNumber")
	sortBy := r.URL.Query().Get("sortBy")
	if sortBy == "" {
		sortBy = "jam"
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

	idRole := r.URL.Query().Get("idRole")

	req := model.StandardRequest{
		Keyword:    keyword,
		PageSize:   pageSize,
		PageNumber: pageNumber,
		SortBy:     sortBy,
		SortType:   sortType,
		IdRole:     idRole,
	}

	err = shared.GetValidator().Struct(req)
	if err != nil {
		response.WithError(w, failure.BadRequest(err))
		return
	}

	status, err := h.LogSystemService.ResolveAll(req)
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, status)
}
