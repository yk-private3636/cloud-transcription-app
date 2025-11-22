package main

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"strings"
	"transcription/module"

	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	if strings.ToLower(os.Getenv("APP_ENV")) == "prod" {
		lambda.Start(EventHandler)
	} else {
		event := json.RawMessage(module.Content("event.json"))
		EventHandler(context.Background(), event)
	}
}

func EventHandler(ctx context.Context, event json.RawMessage) {
	data, _ := event.MarshalJSON()
	fmt.Println(string(data))
}
