pipeline {
    agent any

    environment {
        DJANGO_PROJECT_DIR = 'Django-web' // Your Django project directory name
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        // Example: Testing stage
        stage('Test') {
            steps {
                sh '''
                cd ${DJANGO_PROJECT_DIR}
                python -m venv venv
                source venv/bin/activate
                pip install -r requirements.txt
                python manage.py test
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['aws-credentials']) {
                    // Sync project files to your EC2 instance
                    sh "rsync -avz --exclude 'venv/' --exclude '.git/' ./ ${DJANGO_PROJECT_DIR} ec2-user@44.212.36.244:/path/to/target/directory/on/ec2"

                    // SSH commands to restart your application on the EC2 instance
                    sh 'ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 "bash -s" <<EOF
                    cd /path/to/target/directory/on/ec2/${DJANGO_PROJECT_DIR}
                    source venv/bin/activate
                    pip install -r requirements.txt
                    python manage.py migrate
                    python manage.py collectstatic --no-input
                    sudo systemctl restart gunicorn  # Or any other command to restart your Django app
                    EOF'
                }
            }
        }
    }
}
