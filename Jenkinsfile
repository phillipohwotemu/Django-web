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
                    // Assuming you're in the root directory where the Dockerfile is located
                    sh 'docker build -t my-django-app-image:latest .'
                    // Optionally, push the image to a registry if Jenkins is running on a different host
                    // sh 'docker push my-django-app-image:latest'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Utilize your Docker image to run tests
                    sh 'docker run --rm my-django-app-image:latest python manage.py test'
                }
            }
        }

        stage('Deploy') {
            steps {
                sshagent(['ec2-deploy-key-django-app']) {
                    // Replace 'your-ec2-ip' with the actual IP address of your EC2 instance
                    // Make sure 'my-django-app-image:latest' matches the name and tag of your Docker image
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@your-ec2-ip << EOF
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
