pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build your Docker image
                    sh 'docker build -t my-django-app-image:latest .'
                    // Optionally, push the image to a Docker registry
                    // sh 'docker push my-django-app-image:latest'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests using the built Docker image
                    sh 'docker run --rm my-django-app-image:latest python manage.py test'
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    // Deploy to your EC2 instance using SSH
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 << EOF
                    docker pull my-django-app-image:latest
                    docker stop django-app-container || true
                    docker rm django-app-container || true
                    docker run -d --name django-app-container -p 8000:8000 my-django-app-image:latest
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
