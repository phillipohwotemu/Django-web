pipeline {
    agent any

    stages {
        stage('Cleanup and Prepare Environment') {
            steps {
                sh 'rm -rf env || true'
                sh '/usr/bin/python3 -m venv env'
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                /bin/bash -c "source env/bin/activate"
                pip install -r requirements.txt || echo "requirements.txt not found!"
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                /bin/bash -c "source env/bin/activate && python3 manage.py test"
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['ec2-deploy-key-django-app']) {
                    sh '''
                    rsync -avz -e 'ssh -o StrictHostKeyChecking=no' --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/home/ec2-user/project
                    '''
                }
            }
        }
    }
}
