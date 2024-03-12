pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
            steps {
                // This step is automatically handled by Jenkins' SCM checkout process
                // Ensure your Jenkins job is configured to checkout the correct GitHub repository and branch
                echo 'Checking out source code from GitHub...'
            }
        }

        stage('Pull Docker Image') {
            steps {
                script {
                    // Pulls the specified Docker image from Docker Hub
                    // Ensure Docker is installed and Jenkins has permissions to run Docker commands
                    echo 'Pulling Docker image...'
                    docker.image('wizebird/django-app:latest').pull()
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Here you can add commands to build your project
                    // For example, you might compile code, run tests, or perform other build steps
                    echo 'Building the project...'
                    // Example: sh 'mvn clean install'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Add deployment steps here
                    // This might involve SSH commands to a server, Kubernetes deployment commands, etc.
                    echo 'Deploying application...'
                    // Example for Docker: docker run -d -p 80:80 wizebird/django-app:latest
                }
            }
        }
    }

    post {
        always {
            // This block executes after the pipeline execution, regardless of the result
            echo 'Pipeline execution complete.'
        }
    }
}
