pipeline {
    agent any

    stages {
        stage('Cleanup and Prepare Environment') {
            steps {
                echo 'Cleaning up and preparing environment...'
                sh 'rm -rf env || true'
                sh 'python3 -m venv env'
            }
        }

        stage('Pull Docker Image') {
            steps {
                script {
                    // Correct syntax to pull the latest version of your Docker image from Docker Hub
                    echo 'Pulling Docker image...'
                    docker.image('wizebird/django-app:latest').pull()
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies...'
                sh '''
                    /bin/bash -c "source env/bin/activate && pip install -r requirements.txt || echo 'requirements.txt not found!'"
                '''
            }
        }

        // Optional: Adjust or remove this stage based on your testing setup
        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    // Example of how to run a simple test command inside your Docker container
                    // This needs to be adjusted according to your actual application's test commands
                    docker.image('wizebird/django-app:latest').inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    echo 'Deploying application...'
                    // Ensure your EC2 instance has Docker installed and the Jenkins user has SSH access
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 << EOF
                        docker pull wizebird/django-app:latest
                        docker stop django-app-container || true
                        docker rm django-app-container || true
                        docker run -d --name django-app-container -p 8000:8000 wizebird/django-app:latest
                    EOF
                    '''
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
