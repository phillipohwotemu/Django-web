pipeline {
    agent any

    stages {
        stage('Cleanup and Prepare Environment') {
            steps {
                sh 'rm -rf env || true'
                sh 'python3 -m venv env'
            }
        }

        stage('Pull Docker Image') {
            steps {
                script {
                    // Pull the latest version of your Docker image from Docker Hub
                    docker.pull('wizebird/django-app:latest')
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    /bin/bash -c "source env/bin/activate && pip install -r requirements.txt || echo 'requirements.txt not found!'"
                '''
            }
        }

        stage('Test') {
            steps {
                script {
                    // Assuming your tests can run within the Docker environment
                    // This is a simple placeholder; adjust based on your actual test command
                    docker.run('wizebird/django-app:latest', 'python manage.py test')
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    // Commands to SSH into your EC2 instance, stop existing container, remove it, and run a new one
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
            // Steps to clean up, send notifications, etc., after the pipeline runs
            echo "Pipeline execution complete."
        }
    }
}
