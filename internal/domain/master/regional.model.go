package master

import (
	"time"

	"github.com/gofrs/uuid"
)

// field untuk transaksi
type Regional struct {
	ID        int        `db:"id" json:"id"`
	Nama      string     `db:"nama" json:"nama"`
	Alamat    *string    `db:"alamat" json:"alamat"`
	Active    bool       `db:"active" json:"active"`
	CreatedAt *time.Time `db:"created_at" json:"createdAt"`
	CreatedBy *uuid.UUID `db:"created_by" json:"createdBy"`
	UpdatedAt *time.Time `db:"updated_at" json:"updatedAt"`
	UpdatedBy *uuid.UUID `db:"updated_by" json:"updatedBy"`
	IsDeleted bool       `db:"is_deleted" json:"isDeleted"`
}

// field param di swagger
type RegionalFormat struct {
	ID     int       `db:"id" json:"id"`
	Nama   string    `db:"nama" json:"nama"`
	Alamat *string   `db:"alamat" json:"alamat"`
	Active bool      `db:"active" json:"active"`
	UserID uuid.UUID `json:"-"`
}

// alis dari json ke db untuk sort table fe
var ColumnMappRegional = map[string]interface{}{
	"id":         "id",
	"nama":       "nama",
	"alamat":     "alamat",
	"keterangan": "keterangan",
	"createdAt":  "created_at",
	"createdBy":  "created_by",
	"updatedAt":  "updated_at",
	"updatedBy":  "updated_by",
	"isDeleted":  "is_deleted",
}

// field create dan update
func (regional *Regional) RegionalFormat(reqFormat RegionalFormat) (newRegional Regional, err error) {
	var now = time.Now()
	if reqFormat.ID == 0 {
		newRegional = Regional{
			ID:        reqFormat.ID,
			Nama:      reqFormat.Nama,
			Alamat:    reqFormat.Alamat,
			Active:    reqFormat.Active,
			CreatedAt: &now,
			CreatedBy: &reqFormat.UserID,
		}
	} else {
		newRegional = Regional{
			ID:        reqFormat.ID,
			Nama:      reqFormat.Nama,
			Alamat:    reqFormat.Alamat,
			Active:    reqFormat.Active,
			UpdatedAt: &now,
			UpdatedBy: &reqFormat.UserID,
		}
	}
	return
}

// field delete soft
func (Regional *Regional) SoftDelete(userID uuid.UUID) {
	Regional.IsDeleted = true
	Regional.UpdatedBy = &userID
}
