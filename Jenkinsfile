pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        stage('Setup Python Environment') {
            steps {
                script {
                    // Using a Python Docker image to create a virtual environment and install dependencies
                    docker.image('python:3.8-slim').inside {
                        sh '''
                        python -m venv env
                        . env/bin/activate
                        pip install -r requirements.txt
                        '''
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Using the same Python Docker image to run your Django tests
                    docker.image('python:3.8-slim').inside {
                        sh '''
                        . env/bin/activate
                        python manage.py test
                        '''
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    // Assuming your deployment commands here don't need Python.
                    // They execute on the EC2 instance which should have all the necessary environment setup.
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
