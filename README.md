# automate-all-the-things

## Go API

- Run application:
```
cd api
go run main.go
```

- Test:

```
curl http://localhost:8080/
```

```json
{
  "message": "Automate all the things!",
  "timestamp": 1701276008
}
```

## Build and push docker image

```
cd api
docker login -u <username> -p <password>
docker build -t umeshnataraj/automate-all-the-things:latest . 
docker push umeshnataraj/automate-all-the-things:latest
```

## Infra

Providing the AWS credentials via environment variables:
```shell
export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION=<YOUR_AWS_DEFAULT_REGION>

cd terraform

terraform init
terraform plan
terraform apply --auto-approve
```


## Access the application
Once the deployment is complete, you'll find the `application_endpoint_url` as Terraform output. Copy and paste on your browser to try the application.

## Destroy

Providing the AWS credentials via environment variables:

```shell
export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION=<YOUR_AWS_DEFAULT_REGION>

cd terraform

terraform destroy --auto-approve
```
