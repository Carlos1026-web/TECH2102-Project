pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '545349725573.dkr.ecr.us-east-1.amazonaws.com/tech2102-project-group13'
        IMAGE_NAME = 'tech2102-project-group13'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Build'){
            steps {
                bat 'npm install && npm run build'
            }
        }

        stage('Test'){
            steps {
                bat 'set CI=true && npm test -- --watchAll=false --passWithNoTests'
            }
        }

        stage('Build My Docker Image'){
            steps {
                bat 'docker build -t %IMAGE_NAME%:%IMAGE_TAG% . && docker images'
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-ecr-creds', usernameVariable: 'AWS_USER', passwordVariable: 'AWS_PASS')]) {
                    bat 'set AWS_ACCESS_KEY_ID=%AWS_USER%&& set AWS_SECRET_ACCESS_KEY=%AWS_PASS%&& set AWS_DEFAULT_REGION=us-east-1&& aws ecr get-login-password --region us-east-1 > ecr_password.txt'
                    bat 'docker login --username AWS --password-stdin 545349725573.dkr.ecr.us-east-1.amazonaws.com < ecr_password.txt'
                    bat 'docker tag %IMAGE_NAME%:%IMAGE_TAG% %ECR_REPO%:%IMAGE_TAG%'
                    bat 'docker push %ECR_REPO%:%IMAGE_TAG%'
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-ecr-creds', usernameVariable: 'AWS_USER', passwordVariable: 'AWS_PASS')]) {
                    bat 'set AWS_ACCESS_KEY_ID=%AWS_USER%&& set AWS_SECRET_ACCESS_KEY=%AWS_PASS%&& set AWS_DEFAULT_REGION=us-east-1&& aws ecs register-task-definition --cli-input-json file://taskdef.json'
                    bat 'set AWS_ACCESS_KEY_ID=%AWS_USER%&& set AWS_SECRET_ACCESS_KEY=%AWS_PASS%&& set AWS_DEFAULT_REGION=us-east-1&& aws ecs update-service --cluster tech2102-cluster --service tech2102-service --task-definition react-app-task --force-new-deployment'
                }
            }
        }
    }
}
