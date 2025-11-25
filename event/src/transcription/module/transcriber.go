package module

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/transcribe"
	"github.com/aws/aws-sdk-go-v2/service/transcribe/types"
)

type transcriber struct {
	client *transcribe.Client
}

type Transcriber interface {
	StartJob(ctx context.Context, job *TranscriberJob) error
}

type TranscriberJob struct {
	Name             string
	LanguageCode     string
	MediaBucketURI   string
	OutputBucketName string
	OutputKey        string
}

func NewTranscriber(client *transcribe.Client) Transcriber {
	return &transcriber{
		client: client,
	}
}

func (t *transcriber) StartJob(ctx context.Context, job *TranscriberJob) error {
	_, err := t.client.StartTranscriptionJob(ctx, &transcribe.StartTranscriptionJobInput{
		TranscriptionJobName: aws.String(job.Name),
		LanguageCode:         types.LanguageCode(job.LanguageCode),
		Media: &types.Media{
			MediaFileUri: aws.String(job.MediaBucketURI),
		},
		OutputBucketName: aws.String(job.OutputBucketName),
		OutputKey:        aws.String(job.OutputKey),
	})

	return err
}
