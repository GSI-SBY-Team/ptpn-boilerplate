package model

import (
	"database/sql/driver"
	"encoding/json"
	"errors"

	"github.com/gofrs/uuid"
)

const RECORD_NOT_FOUND = "record not found"

// StandardRequest is a standard query string request
type StandardRequest struct {
	Keyword           string `json:"q" validate:"omitempty"`
	StartDate         string `json:"startDate" validate:"omitempty"`
	EndDate           string `json:"endDate" validate:"omitempty"`
	PageNumber        int    `json:"pageNumber" validate:"omitempty,gte=0"`
	PageSize          int    `json:"pageSize" validate:"omitempty,gte=0"`
	SortBy            string `json:"sortBy" validate:"required"`
	SortType          string `json:"sortType" validate:"required,oneof=asc ASC desc DESC"`
	Status            string `json:"status" validate:"omitempty"`
	IgnorePaging      bool   `json:"ignorePaging" validate:"omitempty"`
	Bulan             string `json:"bulan" validate:"omitempty"`
	Tahun             string `json:"tahun" validate:"omitempty"`
	IdRole            string `json:"idRole" validate:"omitempty"`
	IdRegional        string `json:"idRegional" validate:"omitempty"`
	IdKebun           string `json:"idKebun" validate:"omitempty"`
	IdKomoditas       string `json:"idKomoditas" validate:"omitempty"`
	IdAfdeling        string `json:"idAfdeling" validate:"omitempty"`
	IdMandor          string `json:"idMandor" validate:"omitempty"`
	PersonType        string `json:"personType" validate:"omitempty"`
	PersonId          string `json:"personId" validate:"omitempty"`
	MandorId          string `json:"mandorId" validate:"omitempty"`
	KategoriId        string `json:"kategoriId" validate:"omitempty"`
	SatuanId          string `json:"satuanId" validate:"omitempty"`
	PabrikId          string `json:"pabrikId" validate:"omitempty"`
	Aktif             string `json:"aktif" validate:"omitempty"`
	Bokar             string `json:"bokar" validate:"omitempty"`
	JenisPengolahanId string `json:"jenisPengolahanId" validate:"omitempty"`
	ItemId            string `json:"itemId" validate:"omitempty"`
	JobDesc           string `json:"jobDesc" validate:"omitempty"`
	IdLocation        string `json:"idLocation" validate:"omitempty"`
	IdTahunTanam      string `json:"idTahunTanam" validate:"omitempty"`
	JobCode           string `json:"jobCode" validate:"omitempty"`
	IdSensor          string `json:"idSensor" validate:"omitempty"`
	HargaBokar        string `json:"hargaBokar" validate:"omitempty"`
	IdJenisKendaraan  string `json:"idJenisKendaraan" validate:"omitempty"`
	Asal              string `json:"asal" validate:"omitempty"`
	Tujuan            string `json:"tujuan" validate:"omitempty"`
	IdTarifAngkutan   string `json:"idTarifAngkutan" validate:"omitempty"`
	IdRencanaPanen    string `json:"idRencanaPanen" validate:"omitempty"`
	HamaId            string `json:"hamaId" validate:"omitempty"`
	PupukId           string `json:"pupukId" validate:"omitempty"`
	LocationCodeId    string `json:"locationCodeId" validate:"omitempty"`
	TahunPenilaian    string `json:"tahunPenilaian" validate:"omitempty"`
	BulanPenilaian    string `json:"bulanPenilaian" validate:"omitempty"`
	PeriodePenilaian  string `json:"periodePenilaian" validate:"omitempty"`
	IdPanel           string `json:"idPanel" validate:"omitempty"`

}
type StandardModel struct {
	ID     string `json:"id" db:"id"`
	Nama   string `json:"nama" db:"nama"`
	Alamat string `json:"alamat" db:"alamat"`
}
type ReportRequestParams struct {
	IDOpd     uuid.UUID `json:"id" db:"id"`
	IdItem    string    `json:"idItem" validate:"omitempty"`
	IdBidang  string    `json:"idBidang" validate:"omitempty"`
	StartDate string    `json:"startDate" validate:"omitempty"`
	EndDate   string    `json:"endDate" validate:"omitempty"`
	Status    string    `json:"status"`
}

type StandardRequestUser struct {
	Keyword     string `json:"q" validate:"omitempty"`
	StartDate   string `json:"startDate" validate:"omitempty"`
	EndDate     string `json:"endDate" validate:"omitempty"`
	PageNumber  int    `json:"pageNumber" validate:"omitempty,gte=0"`
	PageSize    int    `json:"pageSize" validate:"omitempty,gte=0"`
	SortBy      string `json:"sortBy" validate:"required"`
	SortType    string `json:"sortType" validate:"required,oneof=asc ASC desc DESC"`
	IdRole      string `json:"idRole" validate:"omitempty"`
	IdUnor      string `json:"idUnor" validate:"omitempty"`
	IdBidang    string `json:"idBidang" validate:"omitempty"`
	IdKomoditas string `json:"idKomoditas" validate:"omitempty"`
	PabrikId    string `json:"pabrikId" validate:"omitempty"`
	Active      bool   `json:"active" validate:"omitempty"`
	IdRegional  string `json:"idRegional" validate:"omitempty"`
	IdKebun     string `json:"idKebun" validate:"omitempty"`
	IdAfdeling  string `json:"idAfdeling" validate:"omitempty"`
	Status      string `json:"status"`
}

type StandardRequestMenu struct {
	Keyword    string `json:"q" validate:"omitempty"`
	PageNumber int    `json:"pageNumber" validate:"omitempty,gte=0"`
	PageSize   int    `json:"pageSize" validate:"omitempty,gte=0"`
	SortBy     string `json:"sortBy" validate:"required"`
	SortType   string `json:"sortType" validate:"required,oneof=asc ASC desc DESC"`
	App        string `json:"app" validate:"omitempty"`
}

type StandardRequestPegawai struct {
	Keyword    string `json:"q" validate:"omitempty"`
	IDPegawai  string `json:"idPegawai" validate:"omitempty"`
	StartDate  string `json:"startDate" validate:"omitempty"`
	EndDate    string `json:"endDate" validate:"omitempty"`
	PageNumber int    `json:"pageNumber" validate:"omitempty,gte=0"`
	PageSize   int    `json:"pageSize" validate:"omitempty,gte=0"`
	SortBy     string `json:"sortBy" validate:"required"`
	SortType   string `json:"sortType" validate:"required,oneof=asc ASC desc DESC"`
	IdDivisi   string `json:"idDivisi" validate:"omitempty"`
}

type RequestApi struct {
	Host          string `json:"host" validate:"omitempty"`
	Url           string `json:"url" validate:"omitempty"`
	Method        string `json:"method" validate:"omitempty"`
	Username      string `json:"username" validate:"omitempty"`
	Password      string `json:"password" validate:"omitempty"`
	Payload       []byte `json:"payload" validate:"omitempty"`
	PayloadString string `json:"payloadString" validate:"omitempty"`
}

// JSONRaw ...
type JSONRaw json.RawMessage

// Value ...
func (j JSONRaw) Value() (driver.Value, error) {
	byteArr := []byte(j)

	return driver.Value(byteArr), nil
}

// Scan ...
func (j *JSONRaw) Scan(src interface{}) error {
	asBytes, ok := src.([]byte)
	if !ok {
		return error(errors.New("Scan source was not []bytes"))
	}
	err := json.Unmarshal(asBytes, &j)
	if err != nil {
		return error(errors.New("Scan could not unmarshal to []string"))
	}

	return nil
}

// MarshalJSON ...
func (j *JSONRaw) MarshalJSON() ([]byte, error) {
	return *j, nil
}

// UnmarshalJSON ...
func (j *JSONRaw) UnmarshalJSON(data []byte) error {
	if j == nil {
		return errors.New("json.RawMessage: UnmarshalJSON on nil pointer")
	}
	*j = append((*j)[0:0], data...)
	return nil
}
