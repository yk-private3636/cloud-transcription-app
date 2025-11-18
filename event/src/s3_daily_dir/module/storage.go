package module

import (
	"context"
	"io"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type Storage struct {
	client *s3.Client
	name   string
}

func NewStorage(client *s3.Client, name string) *Storage {
	return &Storage{
		client: client,
		name:   name,
	}
}

func (s *Storage) Put(ctx context.Context, objectKey string, body io.Reader) error {
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
