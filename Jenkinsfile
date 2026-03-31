pipeline {
    agent any
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
                    npm test
                '''
            }
        }
    }
}