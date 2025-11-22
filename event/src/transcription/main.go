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
	MediaBucketURI        string `json:"mediaBucketURI"`
	DatetimeNanoTimestamp string `json:"DatetimeNanoTimestamp"`
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

func EventHandler(ctx context.Context, event json.RawMessage) {
	bson, err := event.MarshalJSON()

	if err != nil {
		log.Fatal(err)
	}

	var param Event
	err = json.Unmarshal(bson, &param)

	if err != nil {
		log.Fatal(err)
	}

	matches, err := module.ExtractByRegex(param.DatetimeNanoTimestamp, `\d+`)

	if err != nil {
		log.Fatal(err)
	}

	job := &module.TranscriberJob{
		Name:             os.Getenv("TRANSCRIPTION_JOB_NAME") + "_" + strings.Join(matches, ""),
		LanguageCode:     os.Getenv("APP_LANG"),
		MediaBucketURI:   param.MediaBucketURI,
		OutputBucketName: os.Getenv("STORAGE_NAME"),
	}

	err = transcriber.StartJob(ctx, job)

	if err != nil {
		log.Fatal(err)
	}
}
