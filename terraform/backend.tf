provider "aws" {
  region = "us-east-1"
  default_tags {
   tags = {
     Environment = "Test"
     Owner       = "TFProviders"
     Project     = "Test"
   }
 }
}


terraform {

# YOUR BACKEND CONFIGURATION
# If you want to enable S3 and DynamoDB as Backend, you must to add Permissions Policy on the CodeBuild Role 

terraform {
  backend "s3" {
    bucket         = "terraform-backend-demo-fsavoia"
    key            = "sample-app.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}

}