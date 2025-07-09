package auth

import (
	"bytes"
	"database/sql"
	"fmt"
	"strings"

	"github.com/gofrs/uuid"
	"github.com/jmoiron/sqlx"

	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/failure"
	"ptpn-go-boilerplate/shared/logger"
	"ptpn-go-boilerplate/shared/model"
	"ptpn-go-boilerplate/shared/pagination"
)

var (
	userQuery = struct {
		Insert,
		Exist,
		Select,
		SelectDTO,
		SelectVerifikasi,
		SelectPerson,
		SelectKomoditas,
		SelectJenisPengolahan,
		Count,
		Update,
		UpdateFcmToken,
		UpdatePassword,
		resetImei,
		UpdateFoto,
		UpdateDeviceId,
		SelectEmergency,
		SelectUserComodity,
		InsertUserComodity,
		InsertUserComodityPlaceholder,
		UpdateEmergency string
	}{
		SelectUserComodity: `SELECT ur.id, ur.comodity_id, r.kode, r.nama, ur.id_user, ur.created_at, ur.updated_at, ur.is_deleted FROM auth_user_commodity ur
			left join m_commodity r on r.id = ur.comodity_id `,
		InsertUserComodity:            `INSERT INTO public.auth_user_commodity(id, comodity_id, id_user, created_at) VALUES `,
		InsertUserComodityPlaceholder: ` (:id, :comodity_id, :id_user, :created_at) `,
		Insert: `INSERT INTO auth_user (
			id,
			name,
			username,
			email,
			password,
			role_id,
			commodity_id,
			person_id,
			status, 
			active,
			manual_produksi_tph,
			manual_produksi_pabrik,
			toleh_kanan,
			toleh_kiri,
			pabrik_id,
			trigger,
			tracehold,
			created_at,
			created_by
		) VALUES (
			:id,
			:name,
			:username,
			:email,
			:password,
			:role_id,
			:commodity_id,
			:person_id,
			:status, 
			:active,
			:manual_produksi_tph,
			:manual_produksi_pabrik,
			:toleh_kanan,
			:toleh_kiri,
			:pabrik_id,
			:trigger,
			:tracehold,
			:created_at,
			:created_by
		) `,
		Exist: `SELECT COUNT(u.id) > 0 FROM auth_user u`,
		Select: `SELECT u.id, u.name, u.username, u.email, u.password, u.status, u.role_id, u.commodity_id, u.person_id, u.foto, u.active, u.manual_produksi_tph, u.manual_produksi_pabrik, u.toleh_kanan, u.toleh_kiri, u.pabrik_id, u.trigger, u.tracehold, u.created_by, u.updated_by, u.created_at, u.updated_at, u.deleted_at, u.is_deleted 
			FROM auth_user u
			left join person_data k on u.person_id = k.id `,
		SelectDTO: `SELECT u.id, u.name, u.username, u.email, u.password, u.status, u.role_id, u.commodity_id, '' commodity, u.person_id, u.active,
			'' person_name, '' nik, r.name as role, u.foto , u.manual_produksi_tph, u.manual_produksi_pabrik, u.toleh_kanan, u.toleh_kiri, u.pabrik_id, u.trigger, u.tracehold,
			'' positionsdesc, '' as nama_kebun, '' as nama_afdeling, '' iot_factory_id, u.is_deleted
			FROM auth_user u
			left join auth_role r on r.id = u.role_id
			 `,
		SelectPerson: ` select a.id, a.nik ,a.nama, a.regional_id, a.register, a.personelsubareanew, a.nama_kebun, a.positionsdesc, a.afdeling, a.afdeling_id, a.kebun_id, b.kode as kode_kebun, c.kode as kode_afdeling from person_data a
						left join m_kebun b on b.id = a.kebun_id
						left join m_afdeling c on c.id = a.afdeling_id `,
		SelectKomoditas: `SELECT r.id, r.kode, r.nama  FROM auth_user_commodity ur
			left join m_commodity r on r.id = ur.comodity_id `,
		SelectJenisPengolahan: `SELECT r.id, r.nama  FROM pabrik_jenis_pengolahan ur
			left join m_jenis_pengolahan r on r.id = ur.jenis_pengolahan_id `,
		Count: `select count(u.id) from auth_user u 
			left join auth_role r on r.id = u.role_id`,
		Update: `UPDATE auth_user SET 
		    id=:id,
			name=:name,
			username=:username,
			email=:email,
			password=:password, 
			status=:status, 
			role_id=:role_id,
			commodity_id=:commodity_id,
			person_id=:person_id,
			active=:active,
			manual_produksi_tph=:manual_produksi_tph,
			manual_produksi_pabrik=:manual_produksi_pabrik,
			toleh_kanan=:toleh_kanan,
			toleh_kiri=:toleh_kiri,
			pabrik_id=:pabrik_id,
			trigger=:trigger,
			tracehold=:tracehold,
			is_deleted=:is_deleted,
			deleted_at=:deleted_at,
			updated_by=:updated_by,
			updated_at=:updated_at `,
		UpdateFcmToken: `UPDATE auth_user SET 
			firebase_token=:firebase_token, 
			updated_at=:updated_at `,
		UpdatePassword: `UPDATE auth_user SET
			password=:password,
			updated_at=:updated_at `,
		UpdateFoto: `UPDATE auth_user SET 
			id=:id, 
			foto=:foto,
			updated_at=:updated_at `,
	}

	loginActivityQuery = struct {
		Insert string
	}{
		Insert: `INSERT INTO log_activity (
			id,
			username,
			jam
		) VALUES (
			:id,
			:username,
			:jam
		)`,
	}
)

// UserRepositoryPostgreSQL digunakan untuk Repository User
type UserRepositoryPostgreSQL struct {
	DB             *infras.PostgresqlConn
	roleRepisitory RoleRepository
}

// ProvideUserRepositoryPostgreSQL is the provider for this repository.
func ProvideUserRepositoryPostgreSQL(db *infras.PostgresqlConn, rr RoleRepository) *UserRepositoryPostgreSQL {
	return &UserRepositoryPostgreSQL{
		DB:             db,
		roleRepisitory: rr,
	}
}

type UserRepository interface {
	ResolveAll(req model.StandardRequestUser) (dataProyek pagination.Response, err error)
	CreateLoginActivity(loginActivity LoginActivity) error
	ExistByUsername(username string) (exist bool, err error)
	ResolveUserByUsername(username string) ([]User, error)
	ResolveUserByUsernameRole(username string) (UserDTO, error)
	ResolveUserByID(id uuid.UUID) (User, error)
	ResolveUserByRole(roleName string, idBidang string) (data []User, err error)
	ResolveUserByIDDTO(id uuid.UUID) (UserDTO, error)
	TransactionCreateUser(user User) error
	TransactionUpdateUser(user User) error
	UpdateUser(id uuid.UUID, user User) error
	UpdateUserFcmToken(id uuid.UUID, user User) error
	UpdateUserPassword(id uuid.UUID, user User) error
	UpdateFoto(data ModelUpdateFoto) error
	ResolvePerson(personId int) (PersonData, error)
	ResolveKomoditas(personId string) (komoditas []Komoditas, err error)
	ResolveJenisPengolahan(pabrikId int) (jenisPengolahan []JenisPengolahan, err error)
}

// TransactionCreateUser digunakan untuk menambahkan user baru dalam blok transaction
func (u *UserRepositoryPostgreSQL) TransactionCreateUser(user User) error {
	return u.DB.WithTransaction(func(db *sqlx.Tx, errs chan error) {
		err := u.createUser(user)
		if err != nil {
			errs <- err
			return
		}

		// Create user multi role
		if err := txCreateUserComodity(db, user.Commodities); err != nil {
			fmt.Println("err create user comodity : ", err)
			errs <- err
			return
		}

		errs <- nil
	})
}

func (u *UserRepositoryPostgreSQL) TransactionUpdateUser(user User) error {
	return u.DB.WithTransaction(func(db *sqlx.Tx, errs chan error) {
		err := u.UpdateUser(user.ID, user)
		if err != nil {
			errs <- err
			return
		}

		ids := make([]string, 0)
		for _, d := range user.Commodities {
			ids = append(ids, d.ID.String())
		}
		if err := u.txDeleteDetailNotIn(db, user.ID.String(), ids); err != nil {
			errs <- err
			return
		}

		if err := txCreateUserComodity(db, user.Commodities); err != nil {
			fmt.Println("err update user comodity : ", err)
			errs <- err
			return
		}

		errs <- nil
	})
}

// createUser is method to create a new user
func (u *UserRepositoryPostgreSQL) createUser(user User) error {
	stmt, err := u.DB.Read.PrepareNamed(userQuery.Insert)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	_, err = stmt.Exec(user)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	return nil
}

func txCreateUserComodity(tx *sqlx.Tx, details []UserHasComodity) (err error) {
	if len(details) == 0 {
		return
	}
	query, args, err := composeBulkUpsertUserRoleQuery(details)
	if err != nil {
		return
	}

	query = tx.Rebind(query)
	stmt, err := tx.Preparex(query)
	if err != nil {
		return
	}
	defer stmt.Close()

	_, err = stmt.Stmt.Exec(args...)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	return
}

func composeBulkUpsertUserRoleQuery(details []UserHasComodity) (qResult string, params []interface{}, err error) {
	values := []string{}
	for _, d := range details {
		param := map[string]interface{}{
			"id":          d.ID,
			"comodity_id": d.ComodityId,
			"id_user":     d.IdUser,
			"created_at":  d.CreatedAt,
		}
		q, args, err := sqlx.Named(userQuery.InsertUserComodityPlaceholder, param)
		if err != nil {
			return qResult, params, err
		}
		values = append(values, q)
		params = append(params, args...)
	}
	qResult = fmt.Sprintf(`%v %v 
						ON CONFLICT (id) 
						DO UPDATE SET comodity_id=EXCLUDED.comodity_id `, userQuery.InsertUserComodity, strings.Join(values, ","))
	return
}

func (r *UserRepositoryPostgreSQL) txDeleteDetailNotIn(tx *sqlx.Tx, idUser string, ids []string) (err error) {
	if len(ids) > 0 {
		query, args, err := sqlx.In("delete from auth_user_commodity where id_user = ? AND id NOT IN (?)", idUser, ids)
		query = tx.Rebind(query)
		if err != nil {
			logger.ErrorWithStack(err)
			return err
		}

		res, _ := r.DB.Write.Exec(query, args...)
		_, err = res.RowsAffected()
		if err != nil {
			return err
		}
	} else {
		stmt, err := r.DB.Read.PrepareNamed("delete from auth_user_commodity where id_user=:id_user")
		if err != nil {
			logger.ErrorWithStack(err)
			return err
		}
		arg := map[string]interface{}{
			"id_user": idUser,
		}
		defer stmt.Close()
		_, err = stmt.Exec(arg)
		if err != nil {
			logger.ErrorWithStack(err)
			return err
		}
	}
	return
}

// ExistByUsername is function to check that username exist or not
func (u *UserRepositoryPostgreSQL) ExistByUsername(username string) (exist bool, err error) {
	err = u.DB.Read.Get(&exist, userQuery.Exist+" WHERE username = $1 AND u.active is true AND u.is_deleted is false ", username)
	if err != nil {
		logger.ErrorWithStack(err)
	}

	return exist, err
}

// ResolveUserByUsername is function resolving user data by username
func (u *UserRepositoryPostgreSQL) ResolveUserByUsername(username string) (user []User, err error) {
	err = u.DB.Read.Select(&user, userQuery.Select+" WHERE u.username = $1 AND u.deleted_at is null", username)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	return user, nil
}

// ResolveUserByUsername is function resolving user data by username and role id
func (u *UserRepositoryPostgreSQL) ResolveUserByUsernameRole(username string) (UserDTO, error) {
	var user UserDTO
	err := u.DB.Read.Get(&user, userQuery.SelectDTO+" WHERE u.username = $1 and u.active = true and u.is_deleted = false  ", username)
	if err != nil {
		logger.ErrorWithStack(err)
		return UserDTO{}, err
	}

	return user, nil
}

// ResolveUserByID is function resolving user data by id
func (u *UserRepositoryPostgreSQL) ResolveUserByID(id uuid.UUID) (User, error) {
	var user User
	err := u.DB.Read.Get(&user, userQuery.Select+" WHERE u.id = $1", id)
	if err != nil {
		if err == sql.ErrNoRows {
			return User{}, err
		}
		logger.ErrorWithStack(err)
		return User{}, err
	}
	return user, nil
}

// ResolveUserByRole is function resolving user data by role
func (u *UserRepositoryPostgreSQL) ResolveUserByRole(roleName string, idBidang string) (data []User, errr error) {
	rows, err := u.DB.Read.Queryx(userQuery.Select+" WHERE u.role_id = $1  AND u.active = true", roleName)
	if err == sql.ErrNoRows {
		errr = failure.NotFound("User")
		return
	}

	if err != nil {
		logger.ErrorWithStack(err)
		return
	}
	for rows.Next() {
		var master User
		err = rows.StructScan(&master)
		if err != nil {
			return
		}
		data = append(data, master)
	}
	return
}

// ResolveUserByID is function resolving user data by email
func (u *UserRepositoryPostgreSQL) ResolveUserByIDDTO(id uuid.UUID) (UserDTO, error) {
	var user UserDTO
	err := u.DB.Read.Get(&user, userQuery.SelectDTO+" WHERE u.id = $1 ", id)
	if err != nil {
		if err == sql.ErrNoRows {
			return UserDTO{}, err
		}
		logger.ErrorWithStack(err)
		return UserDTO{}, err
	}
	userHasComodity, err := u.ResolveUserHasComodity(id)
	if err != nil {
		logger.ErrorWithStack(err)
		return UserDTO{}, err
	}
	user.Commodities = userHasComodity
	return user, nil
}

// UpdateUser is function to update the user entity
func (u *UserRepositoryPostgreSQL) UpdateUser(id uuid.UUID, user User) error {
	stmt, err := u.DB.Read.PrepareNamed(userQuery.Update + " WHERE id = :id")
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	_, err = stmt.Exec(user)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	return nil
}

// UpdateUserFcmToken is function to update the user fcm token
func (u *UserRepositoryPostgreSQL) UpdateUserFcmToken(id uuid.UUID, user User) error {
	stmt, err := u.DB.Read.PrepareNamed(userQuery.UpdateFcmToken + " WHERE id = :id")
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	_, err = stmt.Exec(user)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	return nil
}

// UpdateUserPassword is function to update the user password
func (u *UserRepositoryPostgreSQL) UpdateUserPassword(id uuid.UUID, user User) error {
	stmt, err := u.DB.Read.PrepareNamed(userQuery.UpdatePassword + " WHERE id = :id")
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	_, err = stmt.Exec(user)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	return nil
}

// CreateLoginActivity is function to create log from login activity
func (u *UserRepositoryPostgreSQL) CreateLoginActivity(loginActivity LoginActivity) error {
	stmt, err := u.DB.Read.PrepareNamed(loginActivityQuery.Insert)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	_, err = stmt.Exec(loginActivity)
	if err != nil {
		logger.ErrorWithStack(err)
		return err
	}

	return nil
}

// ResolveAll digunakan untuk menampilkan semua data
func (r *UserRepositoryPostgreSQL) ResolveAll(req model.StandardRequestUser) (response pagination.Response, err error) {
	var searchParams []interface{}
	var searchRoleBuff bytes.Buffer
	searchRoleBuff.WriteString(" WHERE u.id is not null ")

	if req.Status != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" u.is_deleted = ?   ")
		searchParams = append(searchParams, req.Status)
	}

	if req.Keyword != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" concat (u.name, u.username, u.email, k.nama, mc.nama, r.name, k.positionsdesc) ilike ? ")
		searchParams = append(searchParams, "%"+req.Keyword+"%")
	}

	if req.IdRole != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" u.role_id = ?  ")
		searchParams = append(searchParams, req.IdRole)
	}

	if req.PabrikId != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" u.pabrik_id = ?  ")
		searchParams = append(searchParams, req.PabrikId)
	}

	if req.IdKomoditas != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" u.commodity_id = ?  ")
		searchParams = append(searchParams, req.IdKomoditas)
	}

	if req.IdRegional != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" k.regional_id::varchar = ?   ")
		searchParams = append(searchParams, req.IdRegional)
	}

	if req.IdKebun != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" k.kebun_id = ?  ")
		searchParams = append(searchParams, req.IdKebun)
	}

	if req.IdAfdeling != "" {
		searchRoleBuff.WriteString(" AND ")
		searchRoleBuff.WriteString(" k.afdeling_id = ?  ")
		searchParams = append(searchParams, req.IdAfdeling)
	}

	query := r.DB.Read.Rebind("select count(*) from (" + userQuery.SelectDTO + searchRoleBuff.String() + ")s")
	var totalData int
	err = r.DB.Read.QueryRow(query, searchParams...).Scan(&totalData)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	if totalData < 1 {
		response.Items = make([]interface{}, 0)
		return
	}

	searchRoleBuff.WriteString("order by " + ColumnMappUser[req.SortBy].(string) + " " + req.SortType + " ")

	offset := (req.PageNumber - 1) * req.PageSize
	searchRoleBuff.WriteString("limit ? offset ? ")
	searchParams = append(searchParams, req.PageSize)
	searchParams = append(searchParams, offset)

	searchUserQuery := searchRoleBuff.String()
	searchUserQuery = r.DB.Read.Rebind(userQuery.SelectDTO + searchUserQuery)
	rows, err := r.DB.Read.Queryx(searchUserQuery, searchParams...)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	for rows.Next() {
		var userDTO UserDTO
		err = rows.StructScan(&userDTO)
		if err != nil {
			return
		}

		response.Items = append(response.Items, userDTO)
	}

	response.Meta = pagination.CreateMeta(totalData, req.PageSize, req.PageNumber)

	return
}

func (r *UserRepositoryPostgreSQL) UpdateFoto(data ModelUpdateFoto) error {
	return r.DB.WithTransaction(func(tx *sqlx.Tx, e chan error) {
		if err := txUpdateFoto(tx, data); err != nil {
			e <- err
			return
		}
		e <- nil
	})
}

func txUpdateFoto(tx *sqlx.Tx, data ModelUpdateFoto) (err error) {
	stmt, err := tx.PrepareNamed(userQuery.UpdateFoto + " where id=:id")
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

func (u *UserRepositoryPostgreSQL) ResolvePerson(personId int) (PersonData, error) {
	var user PersonData
	err := u.DB.Read.Get(&user, userQuery.SelectPerson+" WHERE a.id = $1  and  a.is_deleted = false  ", personId)
	if err != nil {
		logger.ErrorWithStack(err)
		return PersonData{}, err
	}

	return user, nil
}

func (u *UserRepositoryPostgreSQL) ResolveKomoditas(idUser string) (komoditas []Komoditas, err error) {
	where := " where ur.id_user=$1 "
	rows, err := u.DB.Read.Queryx(userQuery.SelectKomoditas+where, idUser)
	if err == sql.ErrNoRows {
		err = failure.NotFound("Komoditas")
		return
	}

	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	for rows.Next() {
		var kom Komoditas
		err = rows.StructScan(&kom)
		if err != nil {
			return
		}

		komoditas = append(komoditas, kom)
	}
	return
}

func (u *UserRepositoryPostgreSQL) ResolveJenisPengolahan(pabrikId int) (jenisPengolahan []JenisPengolahan, err error) {
	where := " where ur.pabrik_id=$1 "
	rows, err := u.DB.Read.Queryx(userQuery.SelectJenisPengolahan+where, pabrikId)
	if err == sql.ErrNoRows {
		err = failure.NotFound("Jenis Pengolahan")
		return
	}

	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	for rows.Next() {
		var kom JenisPengolahan
		err = rows.StructScan(&kom)
		if err != nil {
			return
		}

		jenisPengolahan = append(jenisPengolahan, kom)
	}
	return
}

func (u *UserRepositoryPostgreSQL) ResolveUserHasComodity(idUser uuid.UUID) (userComodity []UserHasComodity, err error) {
	err = u.DB.Read.Select(&userComodity, userQuery.SelectUserComodity+" WHERE ur.id_user = $1 AND ur.is_deleted=false", idUser)
	if err != nil {
		logger.ErrorWithStack(err)
		return
	}

	return userComodity, nil
}
