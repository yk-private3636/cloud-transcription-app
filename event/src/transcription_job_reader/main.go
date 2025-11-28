package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"
	"transcription_job_reader/module"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/transcribe"
)

var (
	reader module.Reader
)

type Event struct {
	JobName string `json:"jobName"`
}

type Output struct {
	JobStatus string `json:"jobStatus"`
}

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Fatalf(err.Error())
	}

	reader = module.NewReader(
		transcribe.NewFromConfig(cfg),
	)
}

func main() {
	if strings.ToLower(os.Getenv("APP_ENV")) == "prod" {
		lambda.Start(EventHandler)
	} else {
		event := module.FileContent("event.json")
		fmt.Println(EventHandler(context.Background(), event))
	}
}

func EventHandler(ctx context.Context, event json.RawMessage) (Output, error) {
	var param Event
	err := json.Unmarshal(event, &param)

	if err != nil {
		return Output{}, err
	}

	res, err := reader.TranscriptionJob(ctx, param.JobName)

	if err != nil {
		return Output{}, err
	}

	return Output{
		JobStatus: res.Status,
	}, nil
}
