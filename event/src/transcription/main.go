package main

import (
	"context"
	"encoding/json"
	"log"
	"os"
	"strings"
	"transcription/module"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/transcribe"
)

var (
	transcriber module.Transcriber
)

type Event struct {
	JobName               string `json:"jobName"`
	MediaBucketURI        string `json:"mediaBucketURI"`
	OutputBucketName      string `json:"outputBucketName"`
	OutputKey             string `json:"outputKey"`
	Lang                  string `json:"lang"`
	DatetimeNanoTimestamp string `json:"datetimeNanoTimestamp"`
}

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Fatal(err.Error())
	}

	transcriber = module.NewTranscriber(
		transcribe.NewFromConfig(cfg),
	)
}

func main() {
	if strings.ToLower(os.Getenv("APP_ENV")) == "prod" {
		lambda.Start(EventHandler)
	} else {
		event := json.RawMessage(module.FileContent("event.json"))
		EventHandler(context.Background(), event)
	}
}

func EventHandler(ctx context.Context, event json.RawMessage) error {

	var param Event
	err := json.Unmarshal(event, &param)

	if err != nil {
		return err
	}

	matches, err := module.ExtractByRegex(param.DatetimeNanoTimestamp, `\d+`)

	if err != nil {
		return err
	}

	job := &module.TranscriberJob{
		Name:             param.JobName + "_" + strings.Join(matches, ""),
		LanguageCode:     param.Lang,
		MediaBucketURI:   param.MediaBucketURI,
		OutputBucketName: param.OutputBucketName,
		OutputKey:        param.OutputKey,
	}

	err = transcriber.StartJob(ctx, job)

	if err != nil {
		return err
	}

	return nil
}
