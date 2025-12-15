package module

import (
	"context"
	"encoding/json"
	"io"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type reader struct {
	client *s3.Client
}

type Reader interface {
	TranscriptionResult(ctx context.Context, bucket, key string) (*ReaderResult, error)
}

type ReaderResult struct {
	JobName   string `json:"jobName"`
	AccountID string `json:"accountId"`
	Status    string `json:"status"`
	Results   struct {
		Transcripts []struct {
			Transcript string `json:"transcript"`
		} `json:"transcripts"`
	} `json:"results"`
}

func NewReader(client *s3.Client) Reader {
	return &reader{
		client: client,
	}
}

func (r *reader) TranscriptionResult(ctx context.Context, bucket, key string) (*ReaderResult, error) {

	obj, err := r.client.GetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
	})

	if err != nil {
		return nil, err
	}

	defer obj.Body.Close()

	data, err := io.ReadAll(obj.Body)

	if err != nil {
		return nil, err
	}

	var result ReaderResult

	err = json.Unmarshal(data, &result)

	if err != nil {
		return nil, err
	}

	return &result, nil
}
