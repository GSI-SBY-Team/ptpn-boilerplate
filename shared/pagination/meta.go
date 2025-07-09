package pagination

import (
	"math"
)

// Response is a standard list data
type Response struct {
	Items []interface{} `json:"items"`
	Meta  Metadata      `json:"meta"`
}

type ResponseRekapPrestasi struct {
	Items []interface{}         `json:"items"`
	Meta  MetadataRekapPrestasi `json:"meta"`
}

type ResponseRekapPrestasiTeh struct {
	Items []interface{}            `json:"items"`
	Meta  MetadataRekapPrestasiTeh `json:"meta"`
}

// Metadata is a additional info for list data
type Metadata struct {
	TotalItems   int     `json:"totalItems"`
	TotalPage    int     `json:"totalPage"`
	PreviousPage int     `json:"previousPage"`
	CurrentPage  int     `json:"currentPage"`
	NextPage     int     `json:"nextPage"`
	LimitPerPage int     `json:"limitPerPage"`
	TotalRupiah  float64 `json:"totalRupiah"`
}

type MetadataRekapPrestasi struct {
	TotalItems   int    `json:"totalItems"`
	TotalPage    int    `json:"totalPage"`
	PreviousPage int    `json:"previousPage"`
	CurrentPage  int    `json:"currentPage"`
	NextPage     int    `json:"nextPage"`
	LimitPerPage int    `json:"limitPerPage"`
	TotalLateks  string `json:"totalLateks"`
	TotalLump    string `json:"totalLump"`
	TotalScrapB  string `json:"totalScrapB"`
	TotalBasah   string `json:"totalBasah"`
	TotalSheet   string `json:"totalSheet"`
	TotalCompo   string `json:"totalCompo"`
	TotalScrapK  string `json:"totalScrapK"`
	TotalKering  string `json:"totalKering"`
}

type MetadataRekapPrestasiTeh struct {
	TotalItems              int     `json:"totalItems"`
	TotalPage               int     `json:"totalPage"`
	PreviousPage            int     `json:"previousPage"`
	CurrentPage             int     `json:"currentPage"`
	NextPage                int     `json:"nextPage"`
	LimitPerPage            int     `json:"limitPerPage"`
	TotalPanenManual        float64 `json:"totalPanenManual"`
	TotalPanenGunting       float64 `json:"totalPanenGunting"`
	TotalPanenMesinGroup    float64 `json:"totalPanenMesinGroup"`
	TotalPanenMesinIndividu float64 `json:"totalPanenMesinIndividu"`
	TotalPanen              float64 `json:"totalPanen"`
}

// CreateMeta is a metadata creator
func CreateMeta(totalItems int, dataPerPage int, pageNumber int) (meta Metadata) {
	totalPageRaw := float64(totalItems) / float64(dataPerPage)
	maxPage := int(math.Ceil(totalPageRaw))
	minPage := 1

	if maxPage < minPage {
		maxPage = minPage
	}

	nextPage := pageNumber + 1
	if nextPage > maxPage {
		nextPage = maxPage
	}

	prevPage := pageNumber - 1
	if prevPage < minPage {
		prevPage = minPage
	}

	return Metadata{
		TotalItems:   totalItems,
		TotalPage:    maxPage,
		PreviousPage: prevPage,
		CurrentPage:  pageNumber,
		NextPage:     nextPage,
		LimitPerPage: dataPerPage,
	}
}

// CreateMetaRekapPrestasi is a MetadataRekapPrestasi creator
func CreateMetaRekapPrestasi(totalItems int, dataPerPage int, pageNumber int) (meta MetadataRekapPrestasi) {
	metaData := CreateMeta(totalItems, dataPerPage, pageNumber)
	return MetadataRekapPrestasi{
		TotalItems:   metaData.TotalItems,
		TotalPage:    metaData.TotalPage,
		PreviousPage: metaData.PreviousPage,
		CurrentPage:  metaData.CurrentPage,
		NextPage:     metaData.NextPage,
		LimitPerPage: metaData.LimitPerPage,
	}
}

// CreateMetaRekapPrestasi is a MetadataRekapPrestasi creator
func CreateMetaRekapPrestasiReh(totalItems int, dataPerPage int, pageNumber int) (meta MetadataRekapPrestasiTeh) {
	metaData := CreateMeta(totalItems, dataPerPage, pageNumber)
	return MetadataRekapPrestasiTeh{
		TotalItems:   metaData.TotalItems,
		TotalPage:    metaData.TotalPage,
		PreviousPage: metaData.PreviousPage,
		CurrentPage:  metaData.CurrentPage,
		NextPage:     metaData.NextPage,
		LimitPerPage: metaData.LimitPerPage,
	}
}
