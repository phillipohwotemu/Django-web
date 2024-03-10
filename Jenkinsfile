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
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                source env/bin/activate
                pip install -r requirements.txt || echo "requirements.txt not found!"
                '''
            }
        }

        stage('Test') {
            steps {
                sh '''
                source env/bin/activate && python3 manage.py test
                '''
            }
        }

        stage('Deploy') {
            steps {
                // Assuming you have the SSH private key accessible within Jenkins or its running environment
                sh '''
                rsync -avz -e "ssh -i /path/to/your/key -o StrictHostKeyChecking=no" --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/home/ec2-user/project
                '''
            }
        }
    }
}
