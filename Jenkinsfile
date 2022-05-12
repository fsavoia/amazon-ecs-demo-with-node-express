pipeline {
    agent any

    environment {
		//AWS REGION
		REGION="us-east-1"

		//GIT VARS
        GIT_REPO="https://github.com/fsavoia/amazon-ecs-demo-with-node-express.git"
        GIT_BRANCH="main"
		GIT_APP_NAME="sample-nodejs-app"

		//DEPLOYMENT VARS
		ECR_REPO="sample-app"
		ECR_ACC="652839185683.dkr.ecr.us-east-1.amazonaws.com"
		CONTAINER_FILE="taskdef.json"
		ECS_CLUSTER="poc-ecs-cluster"
		ECS_SERVICE="poc-ecs-svc"
		DEPLOYMENT_APP="AppECS-poc-sample-svc-sample-app"
		DEPLOYMENT_GROUP="DgpECS-poc-sample-svc-sample-app"
		APP_SPEC_FILE="appspec.yaml"
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
		stage ("Deploy"){
			steps {
				sh 'sed -i "s/<REVISION>/$BUILD_NUMBER/g" "$CONTAINER_FILE"'
				sh 'aws ecs deploy \
					--cluster $ECS_CLUSTER \
					--service $ECS_SERVICE \
					--codedeploy-application $DEPLOYMENT_APP \
					--codedeploy-deployment-group $DEPLOYMENT_GROUP \
					--task-definition $CONTAINER_FILE \
					--codedeploy-appspec $APP_SPEC_FILE \
					--region $REGION'
			}
        }
		stage ("Cleanup"){
			steps {
                sh 'docker image prune -a -f'
			}
		}
    }
}