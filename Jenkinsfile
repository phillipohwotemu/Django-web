pipeline {
    agent any

    // Define environment variables if needed
    // environment { }

    stages {
        stage('Checkout SCM') {
            steps {
                // This step is automatically handled by Jenkins' SCM checkout process
                // Ensure your Jenkins job is configured to checkout the correct branch (e.g., 'main')
                echo 'Checking out source code...'
            }
        }

        stage('Pull Docker Image') {
            steps {
                script {
                    // Pull your Docker image from Docker Hub
                    // Ensure Docker is installed and Jenkins has permissions to run Docker commands
                    echo 'Pulling Docker image...'
                    docker.image('wizebird/django-app:latest').pull()
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying application...'
                    // Add deployment steps here
                    // For example, deploying to an AWS EC2 instance could involve SSH commands
                    // to pull the Docker image on the EC2 instance and restart the container
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
        }
    }
}
