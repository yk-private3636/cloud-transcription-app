package main

import (
	"bedrock_batch/module"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/bedrock"
)

var (
	inference module.Inference
)

type Event struct {
	JobName         string `json:"jobName"`
	ModelId         string `json:"modelId"`
	RoleArnId       string `json:"roleArnId"`
	InputBucketUri  string `json:"inputBucketUri"`
	OutputBucketUri string `json:"outputBucketUri"`
	TimeoutInHours  int32  `json:"timeoutInHours"`
}

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())

	if err != nil {
		log.Fatal(err.Error())
	}

	inference = module.NewInference(
		bedrock.NewFromConfig(cfg),
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

func EventHandler(ctx context.Context, event json.RawMessage) error {
	var param Event

	err := json.Unmarshal(event, &param)

	if err != nil {
		return err
	}

	job := &module.BatchJob{
		Name:            param.JobName,
		ModelId:         param.ModelId,
		RoleArn:         param.RoleArnId,
		InputBucketUri:  param.InputBucketUri,
		OutputBucketUri: param.OutputBucketUri,
		TimeoutInHours:  param.TimeoutInHours,
	}

	return inference.BatchJob(ctx, job)
}
