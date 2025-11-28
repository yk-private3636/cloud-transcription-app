package module

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/transcribe"
)

type reader struct {
	client *transcribe.Client
}

type Reader interface {
	TranscriptionJob(ctx context.Context, jobName string) (*JobReader, error)
}

type JobReader struct {
	Status string
}

func NewReader(client *transcribe.Client) Reader {
	return &reader{
		client: client,
	}
}

func (r *reader) TranscriptionJob(ctx context.Context, jobName string) (*JobReader, error) {
	res, err := r.client.GetTranscriptionJob(ctx, &transcribe.GetTranscriptionJobInput{
		TranscriptionJobName: aws.String(jobName),
	})

	if err != nil {
		return nil, err
	}

	return &JobReader{
		Status: string(res.TranscriptionJob.TranscriptionJobStatus),
	}, nil
}
