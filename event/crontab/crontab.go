package crontab

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"ptpn-go-boilerplate/configs"
	"ptpn-go-boilerplate/infras"
	"ptpn-go-boilerplate/shared/logger"

	"github.com/jmoiron/sqlx"
	"github.com/robfig/cron/v3"
)

const (
	noRekening  = "0099011769"
	rekeningKey = "7lJayynJAGPEKHBSJkFv7G147d5ZqtZ422NeP46Uvp29tPADZ+MNiSGF3t3LWTBAzM4zWSjNa61/gyzlO265xjkCMura9NAjOiSQyRjWpdbrCShKXuycNTS6MEq8yemy"
	YYYYMMDD    = "20060102"
)

var conn *sqlx.DB

func StartCrontab(config configs.Config) {
	conn = infras.CreatePostgreSQLReadConn(config)
	// set scheduler berdasarkan zona waktu sesuai kebutuhan
	jakartaTime, _ := time.LoadLocation("Asia/Jakarta")
	scheduler := cron.New(cron.WithLocation(jakartaTime))

	// stop scheduler tepat sebelum fungsi berakhir
	defer scheduler.Stop()

	// set task yang akan dijalankan scheduler
	// gunakan crontab string untuk mengatur jadwal
	scheduler.AddFunc("30 * * * *", StartCrawl)

	// start scheduler
	go scheduler.Start()

	// trap SIGINT untuk trigger shutdown.
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	<-sig
}

func StartCrawl() {
	// ... instruksi untuk mengirim automail berisi tagihan
	fmt.Printf(time.Now().Format("2006-01-02 15:04:05") + " CRAWL DATA TRANSAKSI DARI REKENING BPRD DIJALANKAN.\n")
	url := "https://majapahit.bankjatim.co.id/digital/rest/nontrx/v"
	now := time.Now()
	param := fmt.Sprintf("\n{\n  \"nomorRekening\": \"%v\",\n\t\t \t\t \"key\":\"%v\",\n\t\t\"tglawal\": \"%v\",\n\t \"tglakhir\": \"%v\"\n}", noRekening, rekeningKey, now.Format(YYYYMMDD), now.Format(YYYYMMDD))
	payload := strings.NewReader(param)
	req, _ := http.NewRequest("POST", url, payload)
	req.SetBasicAuth("pasir_lumajang", "ePasir1234!")
	req.Header.Add("Content-Type", "application/json")

	res, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Println("error disini: ", err)
	}
	defer res.Body.Close()

	if res.StatusCode != http.StatusOK {
		_, err := ioutil.ReadAll(res.Body)
		if err != nil {
			panic(err)
		}
		log.Println("error sini: ", err)
	}
	body, err := ioutil.ReadAll(res.Body)
	log.Println("error: ", err)
	dataList := ResponseBankJatim{}
	json.Unmarshal([]byte(string(body)), &dataList)
	// fmt.Println("BODY:=>", dataList)
	for _, v := range dataList.History {
		if v.Flag == "D" {
			s := strings.Split(v.Description, " ")
			if s[0] == "PURCHASE" {
				var msg string
				err = conn.Get(&msg, "select fn_sync_insert_log_mutasi_rekening($1,$2,$3,$4)", v.DateTime, v.Description, v.Amount, v.ReffNo)
				fmt.Println("Result :", msg)
				if err != nil {
					logger.ErrorWithStack(err)
					return
				}

			}
		}
	}
}
