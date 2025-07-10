package report

import (
	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"
)

type ReportService interface {
	ResolveAll(request model.StandardRequest) (orders pagination.Response, err error)
}

type ReportServiceImpl struct {
	ReportRepository ReportRepository
	Config           *configs.Config
}

func ProvideRegionalServiceImpl(repository ReportRepository) *ReportServiceImpl {
	s := new(ReportServiceImpl)
	s.ReportRepository = repository
	return s
}

func (s *ReportServiceImpl) ResolveAll(request model.StandardRequest) (orders pagination.Response, err error) {
	return s.ReportRepository.ResolveAll(request)
}
