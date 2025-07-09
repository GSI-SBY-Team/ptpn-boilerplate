package auth

import "ptpn-go-boilerplate/configs"

type DashboardService interface {
	GetAllHeaderJmlEvent(branchId string) (dataDashboard HeaderJmlEvent, err error)
	GetAllHeaderJmlSlider(branchId string) (dataDashboard HeaderJmlSlider, err error)
	GetAllHeaderJmlImageVideo(branchId string) (dataDashboard HeaderJmlImageVideo, err error)
	GetAllHeaderDetailEvent(branchId string) (dataDashboard []HeaderDetailEvent, err error)
	GetDashboardGrafikEvent(branchId, bulan, tahun string) (data []ResponseDasboardGrafikEvent, err error)
	GetDashboardGrafikCategory(branchId, bulan, tahun string) (data []ResponseDasboardGrafikCategory, err error)
}

type DashboardServiceImpl struct {
	DashboardRepository DashboardRepository
	Config              *configs.Config
}

func ProvideDashboardServiceImpl(repository DashboardRepository, config *configs.Config) *DashboardServiceImpl {
	s := new(DashboardServiceImpl)
	s.DashboardRepository = repository
	s.Config = config
	return s
}

func (s *DashboardServiceImpl) GetAllHeaderJmlEvent(branchId string) (newDashboard HeaderJmlEvent, err error) {
	return s.DashboardRepository.GetAllHeaderJmlEvent(branchId)
}

func (s *DashboardServiceImpl) GetAllHeaderJmlSlider(branchId string) (dataDashboard HeaderJmlSlider, err error) {
	return s.DashboardRepository.GetAllHeaderJmlSlider(branchId)
}

func (s *DashboardServiceImpl) GetAllHeaderJmlImageVideo(branchId string) (dataDashboard HeaderJmlImageVideo, err error) {
	return s.DashboardRepository.GetAllHeaderJmlImageVideo(branchId)
}

func (s *DashboardServiceImpl) GetAllHeaderDetailEvent(branchId string) (dataDashboard []HeaderDetailEvent, err error) {
	return s.DashboardRepository.GetAllHeaderDetailEvent(branchId)
}

func (s *DashboardServiceImpl) GetDashboardGrafikEvent(branchId, bulan, tahun string) (data []ResponseDasboardGrafikEvent, err error) {
	return s.DashboardRepository.GetDashboardGrafikEvent(branchId, bulan, tahun)
}

func (s *DashboardServiceImpl) GetDashboardGrafikCategory(branchId, bulan, tahun string) (data []ResponseDasboardGrafikCategory, err error) {
	return s.DashboardRepository.GetDashboardGrafikCategory(branchId, bulan, tahun)
}
