package master

import (
	"errors"
	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"
	"strconv"

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

func (s *RegionalServiceImpl) Create(req RegionalFormat) (newRegional Regional, err error) {
	exist, err := s.RegionalRepository.ExistByNama(req.Nama, "")
	if exist {
		x := errors.New("Nama Regional sudah dipakai")
		return Regional{}, x
	}
	if err != nil {
		return Regional{}, err
	}

	numID, err := s.RegionalRepository.GenIncrementID()
	if exist {
		return Regional{}, err
	}

	newRegional, _ = newRegional.RegionalFormat(req)
	newRegional.ID = numID
	err = s.RegionalRepository.Create(newRegional)
	if err != nil {
		return Regional{}, err
	}
	return newRegional, nil
}

func (s *RegionalServiceImpl) GetAll() (data []Regional, err error) {
	return s.RegionalRepository.GetAll()
}

func (s *RegionalServiceImpl) ResolveAll(request model.StandardRequest) (orders pagination.Response, err error) {
	return s.RegionalRepository.ResolveAll(request)
}

func (s *RegionalServiceImpl) Update(req RegionalFormat) (newRegional Regional, err error) {
	IDStr := strconv.Itoa(req.ID)
	exist, err := s.RegionalRepository.ExistByNama(req.Nama, IDStr)
	if exist {
		x := errors.New("Nama Regional sudah dipakai")
		return Regional{}, x
	}
	if err != nil {
		return Regional{}, err
	}

	newRegional, _ = newRegional.RegionalFormat(req)
	err = s.RegionalRepository.Update(newRegional)
	if err != nil {
		return Regional{}, err
	}
	return newRegional, nil
}

func (s *RegionalServiceImpl) ResolveByID(id int) (newRegional Regional, err error) {
	return s.RegionalRepository.ResolveByID(id)
}

func (s *RegionalServiceImpl) Delete(id int, userId uuid.UUID) error {
	newRegional, err := s.RegionalRepository.ResolveByID(id)

	if err != nil || (Regional{}) == newRegional {
		return errors.New("Data Regional tidak ditemukan")
	}

	newRegional.SoftDelete(userId)
	err = s.RegionalRepository.Update(newRegional)
	if err != nil {
		return errors.New("Ada kesalahan dalam menghapus data Regional")
	}

	return nil
}
