pipeline {
    agent any

    environment {
        // Adjust this if your python executable is in a different location
        PATH = "/usr/bin:${env.PATH}"
    }

    stages {
        stage('Check Python') {
            steps {
                sh '/usr/bin/python3 --version'
            }
        }

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
                sshagent(credentials: ['aws-credentials']) {
                    sh '''
                    /bin/bash -c "rsync -avz --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/home/ec2-user/project"
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 /bin/bash << EOF
                    cd /home/ec2-user/project
                    source env/bin/activate
                    pip install -r requirements.txt
                    python3 manage.py migrate
                    python3 manage.py collectstatic --no-input
                    sudo systemctl restart your_app_service
                    EOF
                    '''
                }
            }
        }
    }
}
