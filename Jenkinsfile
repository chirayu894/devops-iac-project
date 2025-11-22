pipeline {
    agent any
    
    environment {
        // REPLACE THIS with your actual ECR Repository URI
        REGISTRY = "234026642133.dkr.ecr.us-east-1.amazonaws.com/my-flask-app"
        
        // Default AWS Region
        AWS_DEFAULT_REGION = "us-east-1"
    }
    
    stages {
        stage('Build Image') {
            steps {
                script {
                    echo "🔨 Building the Docker Image..."
                    // Build the image and tag it with the full registry URL
                    sh 'docker build -t $REGISTRY:latest .'
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    echo "🔓 Authenticating with AWS ECR..."
                    
                    // We use 'withCredentials' to securely load the secrets we just saved
                    withCredentials([string(credentialsId: 'aws-access-key', variable: 'ACCESS_KEY'), string(credentialsId: 'aws-secret-key', variable: 'SECRET_KEY')]) {
                        
                        // THE TRICK: We run a temporary 'amazon/aws-cli' container just to generate the login token.
                        // We pipe (|) that token directly into 'docker login' on the Jenkins server.
                        sh 'docker run --rm -e AWS_ACCESS_KEY_ID=$ACCESS_KEY -e AWS_SECRET_ACCESS_KEY=$SECRET_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION amazon/aws-cli ecr get-login-password | docker login --username AWS --password-stdin $REGISTRY'
                        
                        echo "🚀 Pushing image to ECR..."
                        sh 'docker push $REGISTRY:latest'
                    }
                }
            }
        }
    }
}