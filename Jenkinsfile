pipeline {
    agent any

    environment {
        // Example of setting a dummy environment variable if you have no actual variables to set
        DUMMY_VAR = 'dummy'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/phillipohwotemu/Django-web.git'

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
                    // Pull the latest version of your Docker image from Docker Hub
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
                    // This assumes your tests can run within the Docker environment
                    // Adjust if necessary for your setup
                    docker.run('wizebird/django-app:latest', '/bin/bash -c "source env/bin/activate && python manage.py test"')
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    // Commands to SSH into your EC2 instance, stop existing container, remove it, and run a new one
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@<Your_EC2_IP> << EOF
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
