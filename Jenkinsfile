pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO = '806169617511.dkr.ecr.us-east-1.amazonaws.com/tech2102-project-group13'
        IMAGE_NAME = 'tech2102-group13'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Build'){
            agent {
                docker {
                    image 'node:24.14.0-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm install
                    CI='' npm run build
                    ls -la
                '''
            }
        }

        stage('Test'){
            agent {
                docker {
                    image 'node:24.14.0-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    test -f build/index.html
                    npm test -- --watchAll=false
                '''
            }
        }

        stage('Build My Docker Image'){
            steps {
                sh '''
                    docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    docker images
                '''
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-ecr-creds', usernameVariable: 'AWS_USER', passwordVariable: 'AWS_PASS')]) {
                    sh '''
                        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                        unzip -q awscliv2.zip
                        ./aws/install --install-dir $HOME/.local/aws-cli --bin-dir $HOME/.local/bin
                        export PATH=$PATH:$HOME/.local/bin
                        aws --version

                        export AWS_ACCESS_KEY_ID=$AWS_USER
                        export AWS_SECRET_ACCESS_KEY=$AWS_PASS
                        export AWS_DEFAULT_REGION=us-east-1
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 806169617511.dkr.ecr.us-east-1.amazonaws.com
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_REPO}:${IMAGE_TAG}
                        docker push ${ECR_REPO}:${IMAGE_TAG}
                    '''
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-ecr-creds', usernameVariable: 'AWS_USER', passwordVariable: 'AWS_PASS')]) {
                    sh '''
                        export PATH=$PATH:$HOME/.local/bin
                        export AWS_ACCESS_KEY_ID=$AWS_USER
                        export AWS_SECRET_ACCESS_KEY=$AWS_PASS
                        export AWS_DEFAULT_REGION=us-east-1
                        aws ecs register-task-definition --cli-input-json file://taskdef.json
                        aws ecs update-service --cluster tech2102-cluster --service tech2102-service --task-definition react-app-task --force-new-deployment
                    '''
                }
            }
        }
    }
}
