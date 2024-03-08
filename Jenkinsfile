pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        stage('Prepare Environment') {
            steps {
                sh 'python3 -m venv env || { echo "Failed to create venv"; exit 1; }'
            }
        }

        stage('Test') {
            steps {
                sh '''
                #!/bin/bash
                source env/bin/activate
                pip install -r requirements.txt
                python manage.py test
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['aws-credentials']) {
                    sh '''
                    #!/bin/bash
                    rsync -avz --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/path/to/your/deployment/directory && \
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 "
                    cd /path/to/your/deployment/directory &&
                    source env/bin/activate &&
                    pip install -r requirements.txt &&
                    python manage.py migrate &&
                    python manage.py collectstatic --no-input &&
                    sudo systemctl restart your_application_service"
                    '''
                }
            }
        }
    }
}
