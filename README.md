* Install terraform and ansible
```
brew install terraform
brew install ansible
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-395.0.0-darwin-arm.tar.gz
tar zxvf google-cloud-cli-395.0.0-darwin-arm.tar.gz
./google-cloud-sdk/install.sh
./google-cloud-sdk/bin/gcloud init
```

* Setup GCP

```
export project=<GCP-PROJECT>
export impersonated-sa=terraform-runner
export terraform-sa=terraform-sa
gcloud auth login
gcloud iam service-accounts create terraform-runner
gcloud projects add-iam-policy-binding $project --member=serviceAccount:$impersonated@$project.iam.gserviceaccount.com --role=roles/editor
gcloud iam service-accounts create $terraform-sa
gcloud iam service-accounts add-iam-policy-binding $impersonated-sa@$project.iam.gserviceaccount.com --member=serviceAccount:$terraform-sa@$project.iam.gserviceaccount.com --role=roles/iam.serviceAccountTokenCreator
gcloud iam service-accounts keys create key.json --iam-account=$terraform-sa@$project.iam.gserviceaccount.com
```

* Fill in terraform.tfvars and kick off

```
terraform init
terraform apply --auto-approve
```

