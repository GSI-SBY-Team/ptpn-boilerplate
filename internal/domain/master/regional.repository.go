package master

import (
	"bytes"
	"database/sql"
	"fmt"
	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/failure"
	"ptpn-go-boilerplate/shared/logger"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"

	"github.com/jmoiron/sqlx"
)

var (
	regionalQuery = struct {
		Select      string
		SelectInc   string
		Insert      string
		Update      string
		Delete      string
		Count       string
		Exist       string
		ExistRelasi string
	}{
		Select:    `select id, nama, alamat, active, created_at, created_by, updated_at, updated_by, is_deleted from m_regional`,
		SelectInc: `select coalesce(max(id), 0)+1 id from m_regional `,
		Insert: `insert into m_regional
				(id, nama, alamat, active, created_at, created_by)
				values
				(:id, :nama, :alamat, :active, :created_at, :created_by) `,
		Update: `update m_regional set
				id=:id,
				nama=:nama,
				alamat=:alamat,
				active=:active,
				updated_at=:updated_at,
				updated_by=:updated_by,
				is_deleted=:is_deleted `,
		Delete: `delete from m_regional mj `,
		Count: `select count (id)
				from m_regional mj `,
		Exist: `select count(id)>0 from m_regional `,
	}
)

type RegionalRepository interface {
	Create(data Regional) error
	GetAll() (data []Regional, err error)
	ResolveAll(req model.StandardRequest) (data pagination.Response, err error)
	ResolveByID(id int) (data Regional, err error)
	DeleteByID(id int) (err error)
	Update(data Regional) error
	ExistByNama(nama string, id string) (bool, error)
	GenIncrementID() (no int, err error)
}

type RegionalRepositoryPostgreSQL struct {
	DB *infras.PostgresqlConn
}

func ProvideRegionalRepositoryPostgreSQL(db *infras.PostgresqlConn) *RegionalRepositoryPostgreSQL {
	s := new(RegionalRepositoryPostgreSQL)
	s.DB = db
	return s
}

func (r *RegionalRepositoryPostgreSQL) Create(data Regional) error {
	stmt, err := r.DB.Read.PrepareNamed(regionalQuery.Insert)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	defer stmt.Close()
	_, err = stmt.Exec(data)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}
	return nil
}

func (r *RegionalRepositoryPostgreSQL) ResolveAll(req model.StandardRequest) (data pagination.Response, err error) {
	var searchParams []interface{}
	var searchRoleBuff bytes.Buffer
	searchRoleBuff.WriteString(" WHERE is_deleted is false ")

	if req.Keyword != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" concat(nama, alamat, keterangan) ilike ?  ")
		searchParams = append(searchParams, "%"+req.Keyword+"%")
	}

	query := r.DB.Read.Rebind(regionalQuery.Count + searchRoleBuff.String())

	var totalData int
	err = r.DB.Read.QueryRow(query, searchParams...).Scan(&totalData)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	if totalData < 1 {
		data.Items = make([]interface{}, 0)
		return
	}

	searchRoleBuff.WriteString("order by " + ColumnMappRegional[req.SortBy].(string) + " " + req.SortType + " ")

	offset := (req.PageNumber - 1) * req.PageSize
	searchRoleBuff.WriteString("limit ? offset ? ")
	searchParams = append(searchParams, req.PageSize)
	searchParams = append(searchParams, offset)

	searchregionalQuery := searchRoleBuff.String()
	searchregionalQuery = r.DB.Read.Rebind(regionalQuery.Select + searchregionalQuery)
	rows, err := r.DB.Read.Queryx(searchregionalQuery, searchParams...)
	if err != nil {
		return
	}
	for rows.Next() {
		var Regional Regional
		err = rows.StructScan(&Regional)
		if err != nil {
			return
		}

		data.Items = append(data.Items, Regional)
	}

	data.Meta = pagination.CreateMeta(totalData, req.PageSize, req.PageNumber)
	return
}

func (r *RegionalRepositoryPostgreSQL) GetAll() (data []Regional, err error) {
	where := " where coalesce(is_deleted, false) = false "

	rows, err := r.DB.Read.Queryx(regionalQuery.Select + where)
	if err == sql.ErrNoRows {
		_ = failure.NotFound("Regional NotFound")
		return
	}

	if err != nil {
		logger.ErrorWithStack(err)
		return
	}
	for rows.Next() {
		var dataList Regional
		err = rows.StructScan(&dataList)

		if err != nil {
			return
		}

		data = append(data, dataList)
	}
	return
}

func (r *RegionalRepositoryPostgreSQL) ResolveByID(id int) (Regional Regional, err error) {
	err = r.DB.Read.Get(&Regional, regionalQuery.Select+" WHERE id=$1  ", id)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}
	return
}

func (r *RegionalRepositoryPostgreSQL) DeleteByID(id int) (err error) {
	_, err = r.DB.Read.Query(regionalQuery.Delete+" WHERE id=$1  ", id)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}
	return
}

func (r *RegionalRepositoryPostgreSQL) Update(data Regional) error {
	return r.DB.WithTransaction(func(tx *sqlx.Tx, e chan error) {
		if err := txUpdateRegional(tx, data); err != nil {
			e <- err
			return
		}
		e <- nil
	})
}

func txUpdateRegional(tx *sqlx.Tx, data Regional) (err error) {
	stmt, err := tx.PrepareNamed(regionalQuery.Update + " WHERE id=:id")
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}
	defer stmt.Close()
	_, err = stmt.Exec(data)
	if err != nil {
		logger.ErrorWithStack(err)
	}
	return
}

func (r *RegionalRepositoryPostgreSQL) ExistByNama(nama string, id string) (bool, error) {
	var exist bool
	where := " where upper(nama)=upper($1) and coalesce(is_deleted, false)=false "
	if id != "" {
		where += fmt.Sprintf(" and id <> '%v' ", id)
	}

	err := r.DB.Read.Get(&exist, regionalQuery.Exist+where, nama)
	if err != nil {
		logger.ErrorWithStack(err)
	}
	return exist, err
}

func (r *RegionalRepositoryPostgreSQL) GenIncrementID() (no int, err error) {
	err = r.DB.Read.Get(&no, regionalQuery.SelectInc)
	if err != nil {
		logger.ErrorWithStack(err)
	}
	return no, err
}
