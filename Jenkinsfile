pipeline {
    agent any

    environment {
		//AWS REGION
		REGION="us-east-1"

		//GIT VARS
        GIT_REPO="https://github.com/fsavoia/amazon-ecs-demo-with-node-express.git"
        GIT_BRANCH="main"
		GIT_APP_NAME="sample-nodejs-app"

		//ECR/ECS VARS
		ECR_REPO="sample-app"
		ECR_ACC="349396007468.dkr.ecr.us-east-1.amazonaws.com"
		CONTAINER_FILE="taskdef.json"

		//ARTIFACTS
		ZIP_FILE="sample-app.zip"
		BUCKET_ART="poc-artifacts-bucket-fsavoia"
    }

    stages {
		stage ("Git checkout"){
			steps {
			    deleteDir()
				git branch: "$GIT_BRANCH", url: "$GIT_REPO"
			}
		}
		stage ("Build"){
			steps {
                dir('sample-nodejs-app'){
                    sh 'docker build -t "$GIT_APP_NAME" .'
                }
			}
 		}
		stage ("ECR"){
			steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin "$ECR_ACC"'
                sh 'docker tag "$GIT_APP_NAME":latest "$ECR_ACC/$ECR_REPO":$BUILD_NUMBER'
                sh 'docker push "$ECR_ACC/$ECR_REPO":$BUILD_NUMBER'
				sh 'sed -i "s/<REVISION>/$BUILD_NUMBER/g" "$CONTAINER_FILE"'
			}
		}
		stage ("Update Task Definition"){
			steps {
				sh 'sed -i "s/<REVISION>/$BUILD_NUMBER/g" "$CONTAINER_FILE"'
			}
        }
		stage ("Upload Artifact"){
			steps {
				sh 'zip -r "$ZIP_FILE" * -x sample-nodejs-app/*'
				sh 'aws s3 cp "$ZIP_FILE" s3://"$BUCKET_ART"'
			}
        }
		stage ("Cleanup"){
			steps {
                sh 'docker image prune -a -f'
			}
		}
    }
}