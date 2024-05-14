terraform {
  backend "s3" {
    bucket = "allthingspractice"
    region = "us-east-1"
    key = "fullDevOpsWithK8/jenkins-server/terraform.tfstate"
  }
}