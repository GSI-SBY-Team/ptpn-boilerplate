package configs

import (
	"sync"

	"github.com/rs/zerolog/log"
	"github.com/spf13/viper"
)

// Config is a struct that will receive configuration options via environment
// variables.
type Config struct {
	App struct {
		CORS struct {
			AllowCredentials bool     `mapstructure:"ALLOW_CREDENTIALS"`
			AllowedHeaders   []string `mapstructure:"ALLOWED_HEADERS"`
			AllowedMethods   []string `mapstructure:"ALLOWED_METHODS"`
			AllowedOrigins   []string `mapstructure:"ALLOWED_ORIGINS"`
			Enable           bool     `mapstructure:"ENABLE"`
			MaxAgeSeconds    int      `mapstructure:"MAX_AGE_SECONDS"`
		}
		File struct {
			Dir              string `mapstructure:"DIR"`
			FotoProfile      string `mapstructure:"FOTO_PROFILE"`
			FotoTap          string `mapstructure:"FOTO_TAP"`
			FotoPerson       string `mapstructure:"FOTO_PERSON"`
			FotoHpt          string `mapstructure:"FOTO_HPT"`
			FotoPengendalian string `mapstructure:"FOTO_PENGENDALIAN"`
			FotoPemupukan    string `mapstructure:"FOTO_PEMUPUKAN"`
			LogAbsensi       string `mapstructure:"LOG_ABSENSI"`
			FotoPKualitas    string `mapstructure:"FOTO_PKUALITAS"`
			DokumenPetani    string `mapstructure:"DOKUMEN_PETANI"`
			User             string `mapstructure:"USER"`
			TarifAngkutan    string `mapstructure:"TARIF_ANGKUTAN"`
		}
		Name     string `mapstructure:"NAME"`
		Revision string `mapstructure:"REVISION"`
		URL      string `mapstructure:"URL"`
	}

	APIExternal struct {
		IpCds       string `mapstructure:"IP_CDS"`
		UsernameCds string `mapstructure:"USERNAME_CDS"`
		PasswordCds string `mapstructure:"PASSWORD_CDS"`
		Cds         string `mapstructure:"CDS"`
		IpIot       string `mapstructure:"IP_IOT"`
		TokenIot    string `mapstructure:"TOKEN_IOT"`
	}

	BankJatim struct {
		Username   string `mapstructure:"USERNAME"`
		Password   string `mapstructure:"PASSWORD"`
		URL        string `mapstructure:"URL"`
		URL_MUTASI string `mapstructure:"URL_MUTASI"`
	} `mapstructure:"BANK_JATIM"`

	Cache struct {
		Redis struct {
			Primary struct {
				Host     string `mapstructure:"HOST"`
				Port     string `mapstructure:"PORT"`
				Password string `mapstructure:"PASSWORD"`
			}
		}
	}

	DB struct {
		PostgreSQL struct {
			Read struct {
				Host     string `mapstructure:"HOST"`
				Port     string `mapstructure:"PORT"`
				Username string `mapstructure:"USER"`
				Password string `mapstructure:"PASSWORD"`
				Name     string `mapstructure:"NAME"`
				Timezone string `mapstructure:"TIMEZONE"`
			}
			Write struct {
				Host     string `mapstructure:"HOST"`
				Port     string `mapstructure:"PORT"`
				Username string `mapstructure:"USER"`
				Password string `mapstructure:"PASSWORD"`
				Name     string `mapstructure:"NAME"`
				Timezone string `mapstructure:"TIMEZONE"`
			}
		}
	}

	Event struct {
		Consumer struct {
			SQS struct {
				AccessKeyID       string `mapstructure:"ACCESS_KEY_ID"`
				BackoffSeconds    int    `mapstructure:"BACKOFF_SECONDS"`
				MaxMessage        int64  `mapstructure:"MAX_MESSAGE"`
				MaxRetries        int    `mapstructure:"MAX_RETRIES"`
				MaxRetriesConsume int    `mapstructure:"MAX_RETRIES_CONSUME"`
				Region            string `mapstructure:"REGION"`
				SecretAccessKey   string `mapstructure:"SECRET_ACCESS_KEY"`
				UUID              string `mapstructure:"UUID"`
				WaitTimeSeconds   int64  `mapstructure:"WAIT_TIME_SECONDS"`

				Topics struct {
					Order struct {
						Enabled bool   `mapstructure:"ENABLED"`
						URL     string `mapstructure:"URL"`
					} `mapstructure:"ORDER"`
				}
			}
		}

		Producer struct {
			SNS struct {
				AccessKeyID     string `mapstructure:"ACCESS_KEY_ID"`
				MaxRetries      int    `mapstructure:"MAX_RETRIES"`
				Region          string `mapstructure:"REGION"`
				SecretAccessKey string `mapstructure:"SECRET_ACCESS_KEY"`
				Topics          struct {
					FooCreated struct {
						ARN     string `mapstructure:"ARN"`
						Enabled bool   `mapstructure:"ENABLED"`
					} `mapstructure:"FOO_CREATED"`
				}
			}
		}
	}

	External struct {
		NotifPublisher struct {
			BaseURL  string `mapstructure:"BASE_URL"`
			Endpoint struct {
				Whatsapp string `mapstructure:"WHATSAPP"`
			}
			Source   string `mapstructure:"SOURCE"`
			Identity string `mapstructure:"IDENTITY"`
			Template string `mapstructure:"TEMPLATE"`
			Type     string `mapstructure:"TYPE"`
			Dial     struct {
				TimeoutSeconds   int64 `mapstructure:"TIMEOUT_SECONDS"`
				KeepAliveSeconds int64 `mapstructure:"KEEP_ALIVE_SECONDS"`
			}
			Client struct {
				TimeoutSeconds int64 `mapstructure:"TIMEOUT_SECONDS"`
			}
		} `mapstructure:"NOTIF_PUBLISHER"`

		Shipment struct {
			URL string `mapstructure:"URL"`
		} `mapstructure:"SHIPMENT"`
	} `mapstructure:"EXTERNAL"`

	Order struct {
		Tracking struct {
			LastMileKeywords []string `mapstructure:"LAST_MILE_KEYWORDS"`
		} `mapstructure:"TRACKING"`
	} `mapstructure:"ORDER"`

	Token struct {
		JWT struct {
			AccessToken   string `mapstructure:"ACCESS_TOKEN"`
			ExpiredInHour int    `mapstructure:"EXPIRED_IN_HOUR"`
		} `mapstructure:"JWT"`
	} `mapstructure:"TOKEN"`

	Server struct {
		Env      string `mapstructure:"ENV"`
		LogLevel string `mapstructure:"LOG_LEVEL"`
		Port     string `mapstructure:"PORT"`
		Shutdown struct {
			CleanupPeriodSeconds int64 `mapstructure:"CLEANUP_PERIOD_SECONDS"`
			GracePeriodSeconds   int64 `mapstructure:"GRACE_PERIOD_SECONDS"`
		}
	}

	Storage struct {
		S3 struct {
			BaseURL  string `mapstructure:"BASE_URL"`
			DataFile struct {
				Directory string `mapstructre:"DIRECTORY"`
			} `mapstructure:"DATAFILE"`
		} `mapstructure:"S3"`
	} `mapstructure:"STORAGE"`
}

var (
	conf Config
	once sync.Once
)

// Get are responsible to load env and get data an return the struct
func Get() *Config {
	viper.SetConfigFile(".env")
	err := viper.ReadInConfig()

	if err != nil {
		log.Fatal().Err(err).Msg("Failed reading config file")
	}

	once.Do(func() {
		log.Info().Msg("Service configuration initialized.")
		err = viper.Unmarshal(&conf)
		if err != nil {
			log.Fatal().Err(err).Msg("")
		}
	})

	return &conf
}
