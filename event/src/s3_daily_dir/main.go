package main

import (
	"context"
	"fmt"
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
	var opts []func(*config.LoadOptions) error

	if strings.ToLower(os.Getenv("APP_ENV")) != "prod" {
		opts = append(opts, config.WithSharedConfigProfile("local"))
	}

	cfg, err := config.LoadDefaultConfig(
		context.TODO(),
		opts...,
	)

	if err != nil {
		log.Fatal(err.Error())
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
		fmt.Println(EventHandler(context.Background()))
	}
}

func EventHandler(ctx context.Context) error {

	ymd, err := module.CurrentDateString(os.Getenv("APP_TIMEZONE"), time.DateOnly)

	if err != nil {
		return err
	}

	err = storage.Put(ctx, ymd+"/", nil)

	if err != nil {
		return err
	}

	return nil
}
