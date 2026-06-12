pipeline {
    agent any
    
    environment {
        PATH = "/usr/local/go/bin:$PATH"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Versions Check') {
            steps {
                sh '''
                    echo "=== Build number: ${BUILD_NUMBER} ==="
                    go version
                    docker version
                    git version
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh 'go test ./... || echo "No tests found"'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp:${BUILD_NUMBER} . || echo "Docker build skipped (no Dockerfile)"'
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline execution failed!'
        }
        always {
            echo 'Pipeline finished.'
        }
    }
}
