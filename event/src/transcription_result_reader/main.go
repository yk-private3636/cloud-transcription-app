package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"
	"transcription_result_reader/module"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

var (
	reader module.Reader
)

type Event struct {
	Bucket string `json:"bucket"`
	Key    string `json:"key"`
}

type Output struct {
	JobName    string `json:"jobName"`
	AccountID  string `json:"accountId"`
	Status     string `json:"status"`
	Transcript string `json:"transcript"`
}

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Fatalf(err.Error())
	}

	reader = module.NewReader(
		s3.NewFromConfig(cfg),
	)
}

func main() {
	if strings.ToLower(os.Getenv("APP_ENV")) == "prod" {
		lambda.Start(EventHandler)
	} else {
		event, _ := os.ReadFile("./event.json")
		fmt.Println(EventHandler(context.Background(), event))
	}
}

func EventHandler(ctx context.Context, event json.RawMessage) (Output, error) {

	var param Event
	err := json.Unmarshal(event, &param)

	if err != nil {
		return Output{}, err
	}

	result, err := reader.TranscriptionResult(ctx, param.Bucket, param.Key)

	if err != nil {
		return Output{}, err
	}

	if len(result.Results.Transcripts) == 0 {
		return Output{}, fmt.Errorf("transcript is empty")
	}

	return Output{
		JobName:    result.JobName,
		AccountID:  result.AccountID,
		Status:     result.Status,
		Transcript: result.Results.Transcripts[0].Transcript,
	}, nil
}
