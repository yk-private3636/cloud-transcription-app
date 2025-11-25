package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"s3_content/module"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

var (
	storage module.Storage
)

type Event struct {
	Bucket string `json:"bucket"`
	Key    string `json:"key"`
}

type Output struct {
	Content string `json:"content"`
}

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Fatalf(err.Error())
	}

	storage = module.NewStorage(
		s3.NewFromConfig(cfg),
	)
}

func main() {
	if strings.ToLower(os.Getenv("APP_ENV")) == "prod" {
		lambda.Start(EventHandler)
	} else {
		event := json.RawMessage(module.FileContent("event.json"))
		fmt.Println(EventHandler(context.Background(), event))
	}
}

func EventHandler(ctx context.Context, event json.RawMessage) (Output, error) {

	var param Event
	err := json.Unmarshal(event, &param)

	if err != nil {
		log.Fatal(err)
	}

	content, err := storage.GetContents(ctx, param.Bucket, param.Key)

	if err != nil {
		log.Fatal(err)
	}

	return Output{
		Content: string(content),
	}, nil
}
