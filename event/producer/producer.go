package producer

import "ptpn-go-boilerplate/event/model"

// Producer represents an event producer interface.
type Producer interface {
	Publish(request model.PublishRequest)
}
