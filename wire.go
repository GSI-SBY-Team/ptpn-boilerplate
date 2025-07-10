//go:build wireinject
// +build wireinject

package main

import (
	"github.com/google/wire"

	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/internal/domain/auth"
	"ptpn-go-boilerplate/internal/domain/master"
	"ptpn-go-boilerplate/internal/files"
	"ptpn-go-boilerplate/internal/handlers"
	"ptpn-go-boilerplate/transport/http"
	"ptpn-go-boilerplate/transport/http/middleware"
	"ptpn-go-boilerplate/transport/http/router"
)

// Wiring for configurations.
var configurations = wire.NewSet(
	configs.Get,
)

// Wiring for persistences.
var persistences = wire.NewSet(
	infras.ProvidePostgreSQLConn,
)

// Wiring for all domains.
var domains = wire.NewSet(
	domainAuth,
	domainMaster,
	domainReport,
)

// Wiring for domain Auth
var domainAuth = wire.NewSet(
	// FileService and implementation
	files.ProvideFileServiceImpl,
	wire.Bind(new(files.FileService), new(*files.FileServiceImpl)),

	// Log System interface and implementation
	auth.ProvideLogSystemServiceImpl,
	wire.Bind(new(auth.LogSystemService), new(*auth.LogSystemServiceImpl)),
	// LogSystemRepository interface and implementation
	auth.ProvideLogSystemRepositoryPostgreSQL,
	wire.Bind(new(auth.LogSystemRepository), new(*auth.LogSystemRepositoryPostgreSQL)),

	// Menu interface and implementation
	auth.ProvideMenuServiceImpl,
	wire.Bind(new(auth.MenuService), new(*auth.MenuServiceImpl)),
	// MenuRepository interface and implementation
	auth.ProvideMenuRepositoryPostgreSQL,
	wire.Bind(new(auth.MenuRepository), new(*auth.MenuRepositoryPostgreSQL)),

	// Role interface and implementation
	auth.ProvideRoleServiceImpl,
	wire.Bind(new(auth.RoleService), new(*auth.RoleServiceImpl)),
	// RoleRepository interface and implementation
	auth.ProvideRoleRepositoryPostgreSQL,
	wire.Bind(new(auth.RoleRepository), new(*auth.RoleRepositoryPostgreSQL)),

	// UserService interface and implementation
	auth.ProvideUserServiceImpl,
	wire.Bind(new(auth.UserService), new(*auth.UserServiceImpl)),
	// UserRepository interface and implementation
	auth.ProvideUserRepositoryPostgreSQL,
	wire.Bind(new(auth.UserRepository), new(*auth.UserRepositoryPostgreSQL)),
)

var domainMaster = wire.NewSet(
	// RegionalService and Implementation
	master.ProvideRegionalServiceImpl,
	wire.Bind(new(master.RegionalService), new(*master.RegionalServiceImpl)),
	// RegionalRepository interfacce and implementation
	master.ProvideRegionalRepositoryPostgreSQL,
	wire.Bind(new(master.RegionalRepository), new(*master.RegionalRepositoryPostgreSQL)),
)

var domainReport = wire.NewSet(
	// RegionalService and Implementation
	report.ProvideReportServiceImpl,
	wire.Bind(new(master.ReportService), new(*master.ReportServiceImpl)),
	// RegionalRepository interfacce and implementation
	report.ProvideReportRepositoryPostgreSQL,
	wire.Bind(new(master.ReportRepository), new(*master.ReportRepositoryPostgreSQL)),
)

// Wiring for HTTP routing.
var routing = wire.NewSet(
	wire.Struct(new(router.DomainHandlers), "*"),
	// Auth
	handlers.ProvideLogSystemHandler,
	handlers.ProvideMenuHandler,
	handlers.ProvideRoleHandler,
	handlers.ProvideUserHandler,
	// master
	handlers.ProvideRegionalHandler,
	// Report
	handlers.ProvideReportHandler,
	//File
	handlers.ProvideFileHandler,

	// JWT
	middleware.ProvideJWTMiddleware,
	router.ProvideRouter,
)

// Wiring for everything.
func InitializeService() *http.HTTP {
	wire.Build(
		// configurations
		configurations,
		// persistences
		persistences,
		// domains
		domains,
		// routing
		routing,
		// selected transport layer
		http.ProvideHTTP)
	return &http.HTTP{}
}
