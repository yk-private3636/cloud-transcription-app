package main

import (
	"context"
	"log"
	"os"
	"s3_daily_dir/module"
	"strings"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

var (
	storage module.Storage
)

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Fatalf(err.Error())
	}

	storage = module.NewStorage(
		s3.NewFromConfig(cfg),
		os.Getenv("STORAGE_NAME"),
	)
}

func main() {
	if strings.ToLower(os.Getenv("APP_ENV")) == "prod" {
		lambda.Start(EventHandler)
	} else {
		EventHandler(context.Background())
	}
}

func EventHandler(ctx context.Context) {

	loc, err := time.LoadLocation(os.Getenv("APP_TIMEZONE"))

	if err != nil {
		log.Fatal(err.Error())
	}

	ymd := time.Now().In(loc).Format(time.DateOnly)

	err = storage.Put(ctx, ymd+"/", nil)

	if err != nil {
		log.Fatal(err.Error())
	}
}
