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
                // Attempt to create a virtual environment, ignore errors if it already exists
                sh '/usr/bin/python3 -m venv env || true'
            }
        }

        stage('Test') {
            steps {
                // Activating the virtual environment and installing dependencies from requirements.txt
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
                    // Sync project to EC2, excluding unnecessary files/directories
                    sh "rsync -avz --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/home/ec2-user/project"

                    // Execute deployment commands on EC2
                    sh '''
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 'bash -s' << 'EOF'
                    cd /home/ec2-user/project
                    source env/bin/activate
                    pip install -r requirements.txt
                    python manage.py migrate
                    python manage.py collectstatic --no-input
                    sudo systemctl restart gunicorn.service
                    EOF
                    '''
                }
            }
        }
    }
}
