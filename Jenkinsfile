pipeline {
    agent any
    stages {
		stage ("Git checkout"){
			steps {
			    deleteDir()
				git branch: "main",
					url: "https://github.com/fsavoia/amazon-ecs-demo-with-node-express.git"
			}
		}
		stage ("Build"){
			steps {
				sh 'sed -i "s/<REVISION>/$BUILD_NUMBER/g" appspec.yml'
				sh 'cat appspec.yml'
                dir('sample-nodejs-app'){
                    sh 'docker build -t sample-nodejs-app .'
                }
			}
 		}
		stage ("ECR"){
			steps {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 652839185683.dkr.ecr.us-east-1.amazonaws.com'
                sh 'docker tag sample-nodejs-app:latest 652839185683.dkr.ecr.us-east-1.amazonaws.com/sample-app:$BUILD_NUMBER'
                sh 'docker push 652839185683.dkr.ecr.us-east-1.amazonaws.com/sample-app:$BUILD_NUMBER'
			}
		}
		stage ("Cleanup"){
			steps {
                sh 'docker image prune -a -f'
			}
		}
    }
}