pipeline {
    agent any

    environment {
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
                    // Using Docker Pipeline syntax to pull the image
                    def appImage = docker.image('wizebird/django-app:latest')
                    appImage.pull()
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Activating virtual environment and installing dependencies within Docker
                    def appImage = docker.image('wizebird/django-app:latest')
                    appImage.inside {
                        sh '''
                        python3 -m venv env
                        source env/bin/activate
                        pip install -r requirements.txt || echo 'requirements.txt not found!'
                        '''
                    }
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Running tests within the Docker container
                    def appImage = docker.image('wizebird/django-app:latest')
                    appImage.inside {
                        sh 'python manage.py test'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    // Deploying to EC2, leveraging Docker for pulling and running the container
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
            echo "Pipeline execution complete."
        }
    }
}
