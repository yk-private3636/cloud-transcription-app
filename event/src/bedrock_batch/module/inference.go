package module

import (
	"context"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/service/bedrock"
	"github.com/aws/aws-sdk-go-v2/service/bedrock/types"
)

type inference struct {
	client *bedrock.Client
}

type Inference interface {
	BatchJob(ctx context.Context, job *BatchJob) error
}

type BatchJob struct {
	Name            string
	ModelId         string
	RoleArn         string
	InputBucketUri  string
	OutputBucketUri string
	TimeoutInHours  int32
}

func NewInference(client *bedrock.Client) Inference {
	return &inference{
		client: client,
	}
}

func (b *inference) BatchJob(ctx context.Context, job *BatchJob) error {
	_, err := b.client.CreateModelInvocationJob(ctx, &bedrock.CreateModelInvocationJobInput{
		JobName: aws.String(job.Name),
		ModelId: aws.String(job.ModelId),
		RoleArn: aws.String(job.RoleArn),
		InputDataConfig: &types.ModelInvocationJobInputDataConfigMemberS3InputDataConfig{
			Value: types.ModelInvocationJobS3InputDataConfig{
				S3Uri: aws.String(job.InputBucketUri),
			},
		},
		OutputDataConfig: &types.ModelInvocationJobOutputDataConfigMemberS3OutputDataConfig{
			Value: types.ModelInvocationJobS3OutputDataConfig{
				S3Uri: aws.String(job.OutputBucketUri),
			},
		},
		TimeoutDurationInHours: aws.Int32(job.TimeoutInHours),
	})

	return err
}
