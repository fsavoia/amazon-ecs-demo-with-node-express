pipeline {
    agent any

    environment {
		//AWS PROFILE
		REGION="us-east-1"

		//GIT DETAILS
        GIT_REPO="https://github.com/fsavoia/amazon-ecs-demo-with-node-express.git"
        GIT_BRANCH="main"
		GIT_APP_NAME="sample-nodejs-app"

		//ECR DETAILS
		ECR_REPO="652839185683.dkr.ecr.us-east-1.amazonaws.com/sample-app"
		ECR_ACC="652839185683.dkr.ecr.us-east-1.amazonaws.com"

		//ARTIFACTS
		ZIP_FILE="sample-app.zip"
		BUCKET_ART="terraform-backend-demo-fsavoia"

		//ECS TASK DEFINITION
		ECS_EX_ROLE="arn:aws:iam::652839185683:role/ecsTaskExecutionRole"
		CONTAINER_FILE="taskdef.json"
		ECS_FAMILY="td-sample-app"
		ECS_MEM="1024"
		ECS_CPU="512"
		ECS_NET_MODE="awsvpc"
		ECS_REQ_COMP="FARGATE"
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
                sh 'docker tag "$GIT_APP_NAME":latest "$ECR_REPO":$BUILD_NUMBER'
                sh 'docker push "$ECR_REPO":$BUILD_NUMBER'
				sh 'sed -i "s/<REVISION>/$BUILD_NUMBER/g" "$CONTAINER_FILE"'
			}
		}
		stage ("Update Task Definition"){
			steps {
				sh 'sed -i "s/<REVISION>/$BUILD_NUMBER/g" "$CONTAINER_FILE"'
				sh 'aws ecs register-task-definition \
				--region "$REGION" \
				--memory "$ECS_MEM" \
				--cpu "$ECS_CPU" \
				--execution-role-arn "$ECS_EX_ROLE" \
				--network-mode "$ECS_NET_MODE" \
				--family "$ECS_FAMILY" \
				--requires-compatibilities "$ECS_REQ_COMP" \
				--cli-input-json file://"$CONTAINER_FILE"'
			}
        }
		// stage ("Upload Artifact"){
		// 	steps {
		// 		sh 'zip -r "$ZIP_FILE" * -x diagram/*'
		// 		sh 'aws s3 cp "$ZIP_FILE" s3://"$BUCKET_ART"'
		// 	}
        // }
		// stage ("Cleanup"){
		// 	steps {
        //         sh 'docker image prune -a -f'
		// 	}
		// }
    }
}