# MongoDB S3 Backup Cron Docker image

A Docker image that will periodically (configured using crontab) perform a MongoDB database dumping and send the compressed dump files as a single tar file to Amazon S3 bucket.

## Configuration

The following table describes the available configuration environment variables.

Name | Description | Default
--- | --- | ---
`MONGO_HOST` | MongoDB instance host | *Required*
`MONGO_PORT` | MongoDB instance port | *Required*
`MONGO_DATABASE` | MongoDB database name | *Required*
`MONGO_USERNAME` | MongoDB username |
`MONGO_PASSWORD` | MongoDB password |
`AWS_ACCESS_KEY_ID` | You can create IAM access keys with the IAM console | *Required*
`AWS_SECRET_ACCESS_KEY` | AWS secret access key | *Required*
`AWS_MONGO_BACKUP_PATH` | Format `:bucket_name/:path` | *Required*
`CRON` | min hour day/month month day/week | default to `0 1 * * *` (every day at 1 AM)

## Example

### Using docker-compose
Start a compose file that will perform the backup every day at 1 AM
- Cd to example directory
- Copy `env-sample` to `.env`. Modify it with your own setting.
- Run `docker-compose up`

### Using command line
Start a container that will perform the backup every day at 1 AM:

```
docker run -e MONGO_HOST=mongo -e MONGO_PORT=27017 -e MONGO_DATABASE=database -e AWS_ACCESS_KEY_ID=key_id -e AWS_SECRET_ACCESS_KEY=key_secret -e AWS_MONGO_BACKUP_PATH=bucket/path -e CRON="0 1 * * *" wahyucnugraha/mongo-backup-cron-s3
```