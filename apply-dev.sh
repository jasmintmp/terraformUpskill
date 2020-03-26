#!/bin/bash
<<'COMMENTS'
Reinitialize backend configuration depending on env (backend-dev.conf)
Plan and Apply conifguration based on predefinied dev.tfvars
Script run on bash terminal by command:
$bash apply-dev.sh
destroy:
reinit
terraform destroy -var-file=config/${env}.tfvars
COMMENTS

env=dev
terraform init -backend-config=config/backend-${env}.conf -reconfigure
terraform plan -var-file=config/${env}.tfvars
terraform apply -var-file=config/${env}.tfvars