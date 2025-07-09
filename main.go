package main

//go:generate go run github.com/swaggo/swag/cmd/swag init
//go:generate go run github.com/google/wire/cmd/wire

import (
	"os"
	"os/signal"
	"syscall"

	"github.com/jmoiron/sqlx"
	// "github.com/robfig/cron/v3"
	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/logger"
)

var config *configs.Config

var conn *sqlx.DB

func main() {
	// Initialize logger
	logger.InitLogger()

	// Initialize config
	config = configs.Get()

	// Set desired log level
	logger.SetLogLevel(config)

	// Wire everything up
	http := InitializeService()

	// RUn Crontab
	// crontab.StartCrontab(*config)

	conn = infras.CreatePostgreSQLReadConn(*config)
	// set scheduler berdasarkan zona waktu sesuai kebutuhan
	// jakartaTime, _ := time.LoadLocation("Asia/Jakarta")
	// scheduler := cron.New(cron.WithLocation(jakartaTime))

	// stop scheduler tepat sebelum fungsi berakhir
	// defer scheduler.Stop()

	// set task yang akan dijalankan scheduler
	// gunakan crontab string untuk mengatur jadwal
	// scheduler.AddFunc("*/30 * * * *", StartCrawl)

	// start scheduler
	// go scheduler.Start()
	// Run server
	http.SetupAndServe()

	// trap SIGINT untuk trigger shutdown.
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	<-sig

}
