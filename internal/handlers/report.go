package handlers

import (
	"net/http"
	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/internal/domain/report"
	"ptpn-go-boilerplate/shared"
	"ptpn-go-boilerplate/shared/failure"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/transport/http/middleware"
	"ptpn-go-boilerplate/transport/http/response"
	"strconv"

	"github.com/go-chi/chi"
)

type ReportHandler struct {
	ReportService report.ReportService
	Config        *configs.Config
}

func ProvideReportHandler(service report.ReportService, config *configs.Config) ReportHandler {
	return ReportHandler{
		ReportService: service,
		Config:        config,
	}
}

func (h *ReportHandler) Router(r chi.Router, middleware *middleware.JWT) {
	r.Route("/master/regional", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			r.Use(middleware.VerifyToken)
			r.Get("/", h.ResolveAll)
		})
	})
}

// ResolveAll list data Report.
// @Summary Get list data Regional.
// @Description endpoint ini digunakan untuk mendapatkan seluruh data Regional sesuai dengan filter yang dikirimkan.
// @Tags PB39
// @Produce json
// @Param Authorization header string true "Bearer <token>"
// @Param pageSize query int true "Set pageSize data"
// @Param pageNumber query int true "Set page number"
// @Param sortBy query string false "Set sortBy parameter is one of [ keterangan | nama | alamat ]"
// @Param sortType query string false "Set sortType with asc or desc"
// @Success 200 {object} master.Regional
// @Failure 400 {object} response.Base
// @Failure 500 {object} response.Base
// @Router /v1/master/regional [get]
func (h *ReportHandler) ResolveAll(w http.ResponseWriter, r *http.Request) {
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

	status, err := h.ReportService.ResolveAll(req)
	if err != nil {
		response.WithError(w, err)
		return
	}

	response.WithJSON(w, http.StatusOK, status)
}
