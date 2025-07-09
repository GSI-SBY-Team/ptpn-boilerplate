package auth

import (
	"bytes"
	"fmt"

	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/logger"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"
)

var (
	logSystemQuery = struct {
		Insert    string
		SelectDto string
		CountDto  string
	}{

		Insert: `Insert into log_activity(id, actions, jam, keterangan, id_user, platform, ip_address, user_agent, kode) 
		values (:id, :actions, :jam, :keterangan, :id_user, :platform, :ip_address, :user_agent, :kode)`,
		SelectDto: `select 
						la.id, la.actions, la.jam, la.keterangan, la.id_user, la.platform, la.ip_address, la.user_agent, la.kode,
						au.nama as nama_user, au.username, au.email, au.id_role, au.id_pegawai,
						ar.nama as nama_role,
						p.nip, p.nama as nama_pegawai
					from 
						public.log_activity la
					left join 
						public.auth_user au on au.id = la.id_user
					left join 
						public.auth_role ar on ar.id = au.id_role
					left join 
						public.m_pegawai p  on p.id = au.id_pegawai  `,
		CountDto: `select 
						count(la.id)
					from 
						public.log_activity la
					left join 
						public.auth_user au on au.id = la.id_user
					left join 
						public.auth_role ar on ar.id = au.id_role
					left join 
						public.m_pegawai p  on p.id = au.id_pegawai `,
	}
)

type LogSystemRepository interface {
	CreateLogSystem(logSystem LogSystem) error
	ResolveAll(req model.StandardRequest) (data pagination.Response, err error)
}

type LogSystemRepositoryPostgreSQL struct {
	DB *infras.PostgresqlConn
}

func ProvideLogSystemRepositoryPostgreSQL(db *infras.PostgresqlConn) *LogSystemRepositoryPostgreSQL {
	s := new(LogSystemRepositoryPostgreSQL)
	s.DB = db
	return s
}

func (r *LogSystemRepositoryPostgreSQL) CreateLogSystem(logSystem LogSystem) error {
	stmt, err := r.DB.Read.PrepareNamed(logSystemQuery.Insert)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}
	defer stmt.Close()
	_, err = stmt.Exec(logSystem)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}
	return nil
}

func (r *LogSystemRepositoryPostgreSQL) ResolveAll(req model.StandardRequest) (data pagination.Response, err error) {
	var searchParams []interface{}
	var searchRoleBuff bytes.Buffer
	searchRoleBuff.WriteString(" where coalesce(au.is_deleted, false) = ? ")
	searchParams = append(searchParams, false)

	if req.Keyword != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" concat(la.actions, la.platform, au.nama, ar.nama, au.username, au.email) ilike ?  ")
		searchParams = append(searchParams, "%"+req.Keyword+"%")
	}

	if req.IdRole != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" au.id_role = ? ")
		searchParams = append(searchParams, req.IdRole)
	}

	query := r.DB.Read.Rebind(logSystemQuery.CountDto + searchRoleBuff.String())

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

	searchRoleBuff.WriteString("order by " + ColumnLogSystemDto[req.SortBy].(string) + " " + req.SortType + " ")

	offset := (req.PageNumber - 1) * req.PageSize
	searchRoleBuff.WriteString("limit ? offset ? ")
	searchParams = append(searchParams, req.PageSize)
	searchParams = append(searchParams, offset)

	searchLoagActivityQuery := searchRoleBuff.String()
	searchLoagActivityQuery = r.DB.Read.Rebind(logSystemQuery.SelectDto + searchLoagActivityQuery)
	fmt.Println("query : ", searchLoagActivityQuery)

	rows, err := r.DB.Read.Queryx(searchLoagActivityQuery, searchParams...)
	if err != nil {
		return
	}
	for rows.Next() {
		var logSystemDto LogSystemDto
		err = rows.StructScan(&logSystemDto)
		if err != nil {
			return
		}

		data.Items = append(data.Items, logSystemDto)
	}

	data.Meta = pagination.CreateMeta(totalData, req.PageSize, req.PageNumber)
	return
}
