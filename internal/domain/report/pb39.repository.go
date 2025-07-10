package report

import (
	"bytes"
	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/logger"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"
)

var (
	reportQuery = struct {
		Select string
	}{
		Select: `select * from fn_report_pb39`,
	}
)

type ReportRepository interface {
	ResolveAll(req model.StandardRequest) (data pagination.Response, err error)
}

type ReportRepositoryPostgreSQL struct {
	DB *infras.PostgresqlConn
}

func ProvideRegionalRepositoryPostgreSQL(db *infras.PostgresqlConn) *ReportRepositoryPostgreSQL {
	s := new(ReportRepositoryPostgreSQL)
	s.DB = db
	return s
}

func (r *ReportRepositoryPostgreSQL) ResolveAll(req model.StandardRequest) (data pagination.Response, err error) {
	var searchParams []interface{}
	var searchRoleBuff bytes.Buffer
	searchRoleBuff.WriteString(" WHERE is_deleted is false ")

	if req.IdKebun != "" {
		searchRoleBuff.WriteString(" AND kebun_id = ? ")
		searchParams = append(searchParams, req.IdKebun)
	}

	query := r.DB.Read.Rebind("SELECT count(*) FROM (" + reportQuery.Select + searchRoleBuff.String() + ")x")

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

	searchRoleBuff.WriteString("order by " + ColumnMappReport[req.SortBy].(string) + " " + req.SortType + " ")

	offset := (req.PageNumber - 1) * req.PageSize
	searchRoleBuff.WriteString("limit ? offset ? ")
	searchParams = append(searchParams, req.PageSize)
	searchParams = append(searchParams, offset)

	searchreportQuery := searchRoleBuff.String()
	searchreportQuery = r.DB.Read.Rebind(reportQuery.Select + searchreportQuery)
	rows, err := r.DB.Read.Queryx(searchreportQuery, searchParams...)
	if err != nil {
		return
	}
	for rows.Next() {
		var Report Report
		err = rows.StructScan(&Report)
		if err != nil {
			return
		}

		data.Items = append(data.Items, Report)
	}

	data.Meta = pagination.CreateMeta(totalData, req.PageSize, req.PageNumber)
	return
}
