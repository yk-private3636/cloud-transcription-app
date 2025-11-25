package module

import (
	"context"
	"io"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type storage struct {
	clinet *s3.Client
}

type Storage interface {
	GetContents(ctx context.Context, bucket, key string) ([]byte, error)
}

func NewStorage(client *s3.Client) Storage {
	return &storage{
		clinet: client,
	}
}

func (s *storage) GetContents(ctx context.Context, bucket, key string) ([]byte, error) {
	res, err := s.clinet.GetObject(ctx, &s3.GetObjectInput{
		Bucket: aws.String(bucket),
		Key:    aws.String(key),
	})

	if err != nil {
		return nil, err
	}

	defer func() {
		res.Body.Close()
	}()

	buf, err := io.ReadAll(res.Body)

	if err != nil {
		return nil, err
	}

	return buf, nil
}
