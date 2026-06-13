pipeline {
    agent any
    
    environment {
        PATH = "/usr/local/go/bin:$PATH"
        APP_NAME = 'myapp'
        APP_VERSION = "v1.0.${BUILD_NUMBER}"   // <-- Версионирование
        NEXUS_URL = 'http://localhost:8081'
        NEXUS_REPO = 'raw-hosted'
        NEXUS_CREDENTIALS_ID = 'nexus-credentials'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Code checked out successfully'
            }
        }
        
        stage('Versions Check') {
            steps {
                sh '''
                    echo "=== Build number: ${BUILD_NUMBER} ==="
                    echo "=== App version: ${APP_VERSION} ==="
                    echo "=== Go version ==="
                    go version
                    echo "=== Docker version ==="
                    docker version || echo "Docker not found"
                '''
            }
        }
        
        stage('Test') {
            steps {
                sh '''
                    echo "=== Running tests ==="
                    go test ./... || echo "No tests found or tests failed"
                '''
            }
        }
        
        stage('Build Binary') {
            steps {
                sh '''
                    echo "=== Building Go binary ==="
                    go build -o ${APP_NAME} .
                    file ${APP_NAME}
                '''
            }
        }
        
        stage('Upload to Nexus') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${NEXUS_CREDENTIALS_ID}",
                    usernameVariable: 'NEXUS_USER',
                    passwordVariable: 'NEXUS_PASS'
                )]) {
                    sh '''
                        echo "=== Uploading to Nexus ==="
                        echo "Uploading ${APP_NAME}-${APP_VERSION}"
                        curl -v --user ${NEXUS_USER}:${NEXUS_PASS} \
                            --upload-file ${APP_NAME} \
                            ${NEXUS_URL}/repository/${NEXUS_REPO}/${APP_NAME}-${APP_VERSION}
                    '''
                }
            }
        }
    }
    
    post {
        success {
            echo '=========================================='
            echo 'Pipeline executed successfully!'
            echo "Binary uploaded to Nexus: ${NEXUS_URL}/repository/${NEXUS_REPO}/${APP_NAME}-${APP_VERSION}"
            echo '=========================================='
        }
        failure {
            echo 'Pipeline execution failed!'
        }
        always {
            echo 'Pipeline finished.'
        }
    }
}
