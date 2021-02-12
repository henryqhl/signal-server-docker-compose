# Docker compose to run Signal server
```
docker-compose up
```
## Current progress
Just start the service up but not E2E test
## Cloud service substitution
* AWS S3 -> minio
* AWS SQS -> elasticmq

## To do
* Redirect AWS S3 request to minio (dns resolve)
* GCP CloudStorage
* GCP firebase
* Captcha
* Voice otp verification
* Twilio SMS
* CDS server
* APN

