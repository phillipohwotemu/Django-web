pipeline {
    agent any

    environment {
        // Example environment variable
        // SECRET_TOKEN = credentials('my-secret-token')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Cleanup and Prepare Environment') {
            steps {
                sh 'rm -rf env || true'
                sh 'python3 -m venv env'
            }
        }

        stage('Pull Docker Image') {
            steps {
                script {
                    docker.pull('wizebird/django-app:latest')
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh(label: 'Activating virtualenv and installing dependencies', script: '''
                    /bin/bash -c "source env/bin/activate && pip install -r requirements.txt || echo 'requirements.txt not found!'"
                ''')
            }
        }

        stage('Test') {
            steps {
                script {
                    docker.run('wizebird/django-app:latest', '/bin/bash -c "source env/bin/activate && python manage.py test"')
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@your-ec2-ip << EOF
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
            echo "Pipeline execution complete."
        }
    }
}
