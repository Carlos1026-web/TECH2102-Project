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
                bat '''
                    npm install
                    npm run build
                '''
            }
        }

        stage('Test'){
            steps {
                bat '''
                    set CI=true
                    npm test -- --watchAll=false --passWithNoTests
                '''
            }
        }

        stage('Build My Docker Image'){
            steps {
                bat '''
                    docker build -t %IMAGE_NAME%:%IMAGE_TAG% .
                    docker images
                '''
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-ecr-creds',
                    usernameVariable: 'AWS_USER',
                    passwordVariable: 'AWS_PASS'
                )]) {
                    bat '''
                        set AWS_ACC