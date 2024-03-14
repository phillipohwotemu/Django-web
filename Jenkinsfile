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
                    // Update this if you're building the image as part of the pipeline
                    sh 'docker build -t wizebird/django-app:latest .'
                    // Optionally, push the image to Docker Hub (assuming credentials are set up)
                    // sh 'docker push wizebird/django-app:latest'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests using the built Docker image
                    sh 'docker run --rm wizebird/django-app:latest python manage.py test'
                }
            }
        }

        stage('Deploy') {
    steps {
        sshagent(credentials: ['ec2-deploy-key-django-app']) {
            sh '''
            ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 'docker pull wizebird/django-app:latest && docker stop django-app-container || true && docker rm django-app-container || true && docker run -d --name django-app-container -p 8000:8000 wizebird/django-app:latest'
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
