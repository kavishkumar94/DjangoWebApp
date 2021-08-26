# README
Kavish Kumar Choudhary, kavishkumar94@gmail.com

### Prerequisites

* Install https://www.terraform.io

##### Infrastructure Setup

Uses terraform. Once infra or resources are up, then docker-compose starts the containers.

##### Secrets

Put your AWS credentials in `creds.tfvars`:

    For MFA enabled users, you need to create the credentials using aws sts get-session-token. To do so:
    aws sts get-session-token --duration-seconds 123 --serial-number "YourMFADeviceSerialNumber" --token-code 123456

    For AWS ec2 instance:
    access_key = <aws access key>
    secret_key = <aws secret access key>
    aws_session_token=<aws session token>

##### Keys

    Put your ssh keys in a folder named keys:
    Defaults to .\keys\syntax_interview.pub and .\keys\syntax_interview

##### Create the environment

    To create an EC2 instance:
    terraform init
    terraform validate
    terraform plan --var-file="creds.tfvars"
    terraform apply --var-file="creds.tfvars"

##### Destroy it

    terraform destroy --var-file="creds.tfvars"

##### Other

    To get into the instance
    ssh ubuntu@<instance_ip> -i <path_to_aws_private_key>

##### docker containers
    Start container
    docker-compose up -f <path to docker-compose file> -d service

    Check logs
    docker-compose logs -f service or docker-compose logs -f

    Stop and remove
    docker-compose down or individually docker-compose stop service 
    docker-compose rm service
