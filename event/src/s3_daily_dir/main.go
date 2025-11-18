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
	storage *module.Storage
)

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Fatalf("unable to load SDK config, %v", err)
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

	ymd := time.Now().Format(time.DateOnly)

	err := storage.Put(ctx, ymd+"/", nil)

	if err != nil {
		log.Fatal(err.Error())
	}
}
