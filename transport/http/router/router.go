package router

import (
	"github.com/go-chi/chi"

	"ptpn-go-boilerplate/internal/handlers"
	"ptpn-go-boilerplate/transport/http/middleware"
)

// DomainHandlers is a struct that contains all domain-specific handlers.
type DomainHandlers struct {
	// Auth
	LogSystemHandler handlers.LogSystemHandler
	MenuHandler      handlers.MenuHandler
	RoleHandler      handlers.RoleHandler
	UserHandler      handlers.UserHandler
	// master
	RegionalHandler handlers.RegionalHandler

	// File
	FileHandler handlers.FileHandler
}

// Router is the router struct containing handlers.
type Router struct {
	JwtMiddleware  *middleware.JWT
	DomainHandlers DomainHandlers
}

// ProvideRouter is the provider function for this router.
func ProvideRouter(domainHandlers DomainHandlers, jwtMiddleware *middleware.JWT) Router {
	return Router{
		DomainHandlers: domainHandlers,
		JwtMiddleware:  jwtMiddleware,
	}
}

// SetupRoutes sets up all routing for this server.
func (r *Router) SetupRoutes(mux *chi.Mux) {
	mux.Route("/v1", func(rc chi.Router) {
		// Auth
		r.DomainHandlers.LogSystemHandler.Router(rc, r.JwtMiddleware)
		r.DomainHandlers.MenuHandler.Router(rc, r.JwtMiddleware)
		r.DomainHandlers.RoleHandler.Router(rc, r.JwtMiddleware)
		r.DomainHandlers.UserHandler.Router(rc, r.JwtMiddleware)
		// master
		r.DomainHandlers.RegionalHandler.Router(rc, r.JwtMiddleware)
		// File
		r.DomainHandlers.FileHandler.Router(rc, r.JwtMiddleware)
	})
}
