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
                sh 'rm -rf env || true' // Ensure the env directory is clean before creating a new venv
                sh '/usr/bin/python3 -m venv env' // Create virtual environment
            }
        }

        stage('Test') {
            steps {
                sh '''
                source env/bin/activate
                pip install -r requirements.txt
                python manage.py test
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['aws-credentials']) {
                    // Rsync project to EC2, excluding unnecessary files/directories
                    sh "rsync -avz --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/home/ec2-user/project"

                    // SSH into EC2 to perform deployment tasks
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 << EOF
                    cd /home/ec2-user/project
                    source env/bin/activate
                    pip install -r requirements.txt
                    python manage.py migrate
                    python manage.py collectstatic --no-input
                    # Restart your Django application, adjust the command as per your setup
                    sudo systemctl restart gunicorn.service
                    EOF
                    '''
                }
            }
        }
    }
}
