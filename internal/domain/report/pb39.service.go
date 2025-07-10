package report

import (
	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"

	"github.com/gofrs/uuid"
)

type RegionalService interface {
	Create(req RegionalFormat) (newRegional Regional, err error)
	GetAll() (data []Regional, err error)
	ResolveAll(request model.StandardRequest) (orders pagination.Response, err error)
	Update(req RegionalFormat) (newRegional Regional, err error)
	ResolveByID(id int) (data Regional, err error)
	Delete(id int, userId uuid.UUID) error
}

type RegionalServiceImpl struct {
	RegionalRepository RegionalRepository
	Config             *configs.Config
}

func ProvideRegionalServiceImpl(repository RegionalRepository) *RegionalServiceImpl {
	s := new(RegionalServiceImpl)
	s.RegionalRepository = repository
	return s
}

func (s *RegionalServiceImpl) GetAll() (data []Regional, err error) {
	return s.RegionalRepository.GetAll()
}

func (s *RegionalServiceImpl) ResolveAll(request model.StandardRequest) (orders pagination.Response, err error) {
	return s.RegionalRepository.ResolveAll(request)
}

func (s *RegionalServiceImpl) ResolveByID(id int) (newRegional Regional, err error) {
	return s.RegionalRepository.ResolveByID(id)
}
