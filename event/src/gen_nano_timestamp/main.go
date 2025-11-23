package main

import (
	"context"
	"fmt"
	"gen_nano_timestamp/module"
	"log"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
)

type Output struct {
	NanoTimestamp int64 `json:"nano_timestamp"`
}

func main() {
	if strings.ToLower(os.Getenv("APP_ENV")) == "prod" {
		lambda.Start(EventHandler)
	} else {
		fmt.Println(EventHandler(context.Background()))
	}
}

func EventHandler(ctx context.Context) (Output, error) {
	ts, err := module.GenerateNanoTimestamp(os.Getenv("APP_TIMEZONE"))

	if err != nil {
		log.Fatal(err.Error())
	}

	return Output{
		NanoTimestamp: ts,
	}, nil
}
