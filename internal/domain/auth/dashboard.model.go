package auth

type HeaderJmlEvent struct {
	JmlEvent   string `db:"jml_event" json:"jmlEvent"`
	JmlApprove string `db:"jml_approve" json:"jmlApprove"`
}
type HeaderDetailEvent struct {
	JmlEvent   string  `db:"jml_event" json:"jmlEvent"`
	JmlApprove string  `db:"jml_approve" json:"jmlApprove"`
	BranchId   *string `db:"branch_id" json:"branchId"`
	Branch     *string `db:"branch" json:"branch"`
}
type HeaderJmlSlider struct {
	JmlSlider  string `db:"jml_slider" json:"jmlSlider"`
	JmlApprove string `db:"jml_approve" json:"jmlApprove"`
}
type HeaderJmlImageVideo struct {
	JmlImage    string `db:"jml_image" json:"jmlImage"`
	JmlApvImage string `db:"jml_apv_image" json:"jmlApvImage"`
	JmlVideo    string `db:"jml_video" json:"jmlVideo"`
	JmlApvVideo string `db:"jml_apv_video" json:"jmlApvVideo"`
}
type DashboardFilter struct {
	BranchId string `json:"branchId"`
}

// DASHBOARD GRAFIK EVENT
type DashboardGrafikEvent struct {
	Branch        string  `db:"branch" json:"branch"`
	Bulan         int     `db:"bulan" json:"bulan"`
	JumlahEvent   float64 `db:"jumlah_event" json:"jumlahEvent"`
	JumlahApprove float64 `db:"jumlah_approve" json:"jumlahApprove"`
}

type DashboardPeriodeEvent struct {
	Periode string                 `db:"periode" json:"periode"`
	Bulan   int                    `db:"bulan" json:"bulan"`
	Branch  []DashboardGrafikEvent `db:"-" json:"branch"`
}
type ResponseDasboardGrafikEvent struct {
	Periode string                 `db:"periode" json:"periode"`
	Bulan   int                    `db:"bulan" json:"bulan"`
	Branch  []DashboardGrafikEvent `db:"-" json:"branch"`
}

// DASHBOARD CATEGORY

type CategoryData struct {
	Branch        string  `db:"branch" json:"branch"`
	JumlahEvent   float64 `db:"jumlah_event" json:"jumlahEvent"`
	JumlahApprove float64 `db:"jumlah_approve" json:"jumlahApprove"`
}

type DashboardCategory struct {
	Category string         `db:"category" json:"category"`
	Group    string         `db:"group_event" json:"group"`
	Branch   []CategoryData `db:"-" json:"branch"`
}

type ResponseDasboardGrafikCategory struct {
	Category string         `db:"category" json:"category"`
	Group    string         `db:"group_event" json:"group"`
	Branch   []CategoryData `db:"-" json:"branch"`
}
