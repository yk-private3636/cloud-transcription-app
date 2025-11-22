package module

import (
	"context"
	"io"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type storage struct {
	client *s3.Client
	name   string
}

type Storage interface {
	Put(ctx context.Context, objectKey string, body io.Reader) error
}

func NewStorage(client *s3.Client, name string) Storage {
	return &storage{
		client: client,
		name:   name,
	}
}

func (s *storage) Put(ctx context.Context, objectKey string, body io.Reader) error {
	_, err := s.client.PutObject(ctx, &s3.PutObjectInput{
		Bucket: aws.String(s.name),
		Key:    aws.String(objectKey),
		Body:   body,
	})

	if err != nil {
		return err
	}

	return nil
}
