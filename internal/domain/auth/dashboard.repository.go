package auth

import (
	"errors"
	"log"
	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/logger"
	"sort"
)

var (
	dashboardQuery = struct {
		SelectHeaderJmlEvent      string
		SelectHeaderDetailEvent   string
		SelectHeaderJmlSlider     string
		SelectGrafikEvent         string
		SelectGrafikCategory      string
		SelectHeaderJmlImageVideo string
	}{
		SelectHeaderJmlEvent: `
			SELECT COALESCE(COUNT(e.id),0) jml_event, 
			COALESCE(COUNT(CASE WHEN e.status=2 THEN 1 ELSE null END),0) as jml_approve
			FROM public.event e
			JOIN public.m_branch b on b.id=e.branch_id
			WHERE ($1='' OR e.branch_id::varchar=$1)
			AND e.is_deleted is false
			AND b.is_deleted is false
		`,

		SelectHeaderDetailEvent: `
			SELECT COALESCE(COUNT(e.id),0) jml_event, 
			COALESCE(COUNT(CASE WHEN e.status=2 THEN 1 ELSE null END),0) as jml_approve,
			e.branch_id::varchar branch_id, b.name as branch
			FROM public.event e
			JOIN public.m_branch b on b.id=e.branch_id
			WHERE ($1='' OR e.branch_id::varchar=$1)
			AND e.is_deleted is false
			AND b.is_deleted is false
			GROUP BY e.branch_id, b.name
			ORDER bY b.name
		`,

		SelectHeaderJmlSlider: `
			SELECT COALESCE(COUNT(a.id),0) jml_slider, 
			COALESCE(COUNT(CASE WHEN a.show and e.status=2 THEN 1 ELSE null END),0) as jml_approve
			FROM public.albums a
			JOIN public.event e on e.id=a.event_id
			WHERE ($1='' OR e.branch_id::varchar=$1)
			AND a.is_deleted is false
			AND e.is_deleted is false
		`,

		SelectHeaderJmlImageVideo: `
			SELECT 
			COALESCE(COUNT(CASE WHEN a.file_type ilike '%image%' THEN 1 ELSE null END),0) as jml_image,
			COALESCE(COUNT(CASE WHEN a.file_type ilike '%image%' AND e.status=2 THEN 1 ELSE null END),0) as jml_apv_image,
			COALESCE(COUNT(CASE WHEN a.file_type ilike '%video%' THEN 1 ELSE null END),0) as jml_video,
			COALESCE(COUNT(CASE WHEN a.file_type ilike '%video%' AND e.status=2 THEN 1 ELSE null END),0) as jml_apv_video
			FROM public.albums a
			JOIN public.event e on e.id=a.event_id
			WHERE ($1='' OR e.branch_id::varchar=$1)
			AND a.is_deleted is false
			AND e.is_deleted is false
		`,

		SelectGrafikEvent: `
			SELECT * from fn_dashboard_event($1, $2, $3) as (
			periode text, bulan int, branch varchar, jumlah_event bigint, jumlah_approve bigint)
		`,

		SelectGrafikCategory: `
			SELECT * from fn_dashboard_category_event($1, $2, $3) as (
			category varchar, branch varchar, jumlah_event bigint, jumlah_approve bigint, group_event text)
		`,
	}
)

type DashboardRepository interface {
	GetAllHeaderJmlEvent(branchId string) (dataDashboard HeaderJmlEvent, err error)
	GetAllHeaderJmlSlider(branchId string) (dataDashboard HeaderJmlSlider, err error)
	GetAllHeaderJmlImageVideo(branchId string) (dataDashboard HeaderJmlImageVideo, err error)
	GetAllHeaderDetailEvent(branchId string) (dataDashboard []HeaderDetailEvent, err error)
	GetDashboardGrafikEvent(branchId, bulan, tahun string) (data []ResponseDasboardGrafikEvent, err error)
	GetDashboardGrafikCategory(branchId, bulan, tahun string) (data []ResponseDasboardGrafikCategory, err error)
}

type DashboardRepositoryPostgreSQL struct {
	DB *infras.PostgresqlConn
}

func ProvideDashboardRepositoryPostgreSQL(db *infras.PostgresqlConn) *DashboardRepositoryPostgreSQL {
	s := new(DashboardRepositoryPostgreSQL)
	s.DB = db
	return s
}

func (r *DashboardRepositoryPostgreSQL) GetAllHeaderJmlEvent(branchId string) (dataDashboard HeaderJmlEvent, err error) {
	err = r.DB.Read.Get(&dataDashboard, dashboardQuery.SelectHeaderJmlEvent, branchId)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	return
}

func (r *DashboardRepositoryPostgreSQL) GetAllHeaderJmlSlider(branchId string) (dataDashboard HeaderJmlSlider, err error) {
	err = r.DB.Read.Get(&dataDashboard, dashboardQuery.SelectHeaderJmlSlider, branchId)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	return
}

func (r *DashboardRepositoryPostgreSQL) GetAllHeaderJmlImageVideo(branchId string) (dataDashboard HeaderJmlImageVideo, err error) {
	err = r.DB.Read.Get(&dataDashboard, dashboardQuery.SelectHeaderJmlImageVideo, branchId)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	return
}

func (r *DashboardRepositoryPostgreSQL) GetAllHeaderDetailEvent(branchId string) (dataDashboard []HeaderDetailEvent, err error) {
	err = r.DB.Read.Select(&dataDashboard, dashboardQuery.SelectHeaderDetailEvent, branchId)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	return
}

func (r *DashboardRepositoryPostgreSQL) GetDashboardGrafikEvent(branchId, bulan, tahun string) (data []ResponseDasboardGrafikEvent, err error) {
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Recovered from panic: %v", r)
			err = errors.New("terjadi kesalahan internal")
		}
	}()

	// Debugging input parameter
	log.Printf("Params - Bulan: %s, Tahun: %s", bulan, tahun)

	rows, err := r.DB.Read.Queryx(dashboardQuery.SelectGrafikEvent, branchId, bulan, tahun)
	if err != nil {
		log.Fatal("Error executing query: ", err)
		return nil, err
	}
	defer rows.Close()

	// Map untuk menyimpan data periode
	periodeMap := make(map[string]struct {
		Bulan  int
		Branch []DashboardGrafikEvent
	})

	// Parsing hasil query
	for rows.Next() {
		var periode string
		var bulanInt int
		var branch string
		var jumlahEvent, jumlahApprove float64

		// Scan hasil query
		if err := rows.Scan(&periode, &bulanInt, &branch, &jumlahEvent, &jumlahApprove); err != nil {
			return nil, err
		}

		// Ambil nilai dari map atau buat default baru
		data := periodeMap[periode]
		data.Bulan = bulanInt
		data.Branch = append(data.Branch, DashboardGrafikEvent{
			Branch:        branch,
			JumlahEvent:   jumlahEvent,
			JumlahApprove: jumlahApprove,
		})
		// Simpan kembali ke map
		periodeMap[periode] = data
	}

	// Membentuk hasil response
	var result []ResponseDasboardGrafikEvent
	for periode, data := range periodeMap {
		result = append(result, ResponseDasboardGrafikEvent{
			Periode: periode,
			Bulan:   data.Bulan,
			Branch:  data.Branch,
		})
	}

	// Urutkan hasil berdasarkan bulan
	sort.Slice(result, func(i, j int) bool {
		return result[i].Bulan < result[j].Bulan
	})

	return result, nil
}

func (r *DashboardRepositoryPostgreSQL) GetDashboardGrafikCategory(branchId, bulan, tahun string) (data []ResponseDasboardGrafikCategory, err error) {
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Recovered from panic: %v", r)
			err = errors.New("terjadi kesalahan internal")
		}
	}()

	// Debugging input parameter
	log.Printf("Params - Bulan: %s, Tahun: %s", bulan, tahun)

	rows, err := r.DB.Read.Queryx(dashboardQuery.SelectGrafikCategory, branchId, bulan, tahun)
	if err != nil {
		log.Fatal("Error executing query: ", err)
		return nil, err
	}
	defer rows.Close()

	categoryMap := make(map[string]struct {
		Group  string
		Branch []CategoryData
	})

	// Parsing hasil query
	for rows.Next() {
		var category, group, branch string
		var jumlahEvent, jumlahApprove float64

		if err := rows.Scan(&category, &branch, &jumlahEvent, &jumlahApprove, &group); err != nil {
			return nil, err
		}
		// Handle the data aggregation
		data := categoryMap[category]
		data.Group = group
		data.Branch = append(data.Branch, CategoryData{
			Branch:        branch,
			JumlahEvent:   jumlahEvent,
			JumlahApprove: jumlahApprove,
		})
		categoryMap[category] = data
	}
	//
	var result []ResponseDasboardGrafikCategory
	for category, data := range categoryMap {
		result = append(result, ResponseDasboardGrafikCategory{
			Category: category,
			Group:    data.Group,
			Branch:   data.Branch,
		})
	}

	// Urutkan hasil berdasarkan grup dan kategori
	sort.Slice(result, func(i, j int) bool {
		if result[i].Group == result[j].Group {
			return result[i].Category < result[j].Category
		}
		return result[i].Group < result[j].Group
	})

	return result, nil
}
