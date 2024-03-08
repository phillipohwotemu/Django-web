pipeline {
    agent any

    environment {
        DJANGO_PROJECT_DIR = 'Django-web' // Adjust based on your Django project directory name
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

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
                    // Use a single sh step for rsync and SSH commands
                    sh """
                    rsync -avz --exclude 'venv/' --exclude '.git/' ./ ${DJANGO_PROJECT_DIR} ec2-user@44.212.36.244:/path/to/target/directory/on/ec2 && \
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 \\
                    'cd /path/to/target/directory/on/ec2/${DJANGO_PROJECT_DIR} && \\
                    source venv/bin/activate && \\
                    pip install -r requirements.txt && \\
                    python manage.py migrate && \\
                    python manage.py collectstatic --no-input && \\
                    sudo systemctl restart gunicorn'  # Adjust the command to restart your app
                    """
                }
            }
        }
    }
}
