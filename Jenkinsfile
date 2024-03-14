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
