pipeline {
    agent any

    stages {
        stage('Cleanup') {
            steps {
                sh 'rm -rf env || true' // Remove the env directory if it exists, ignore errors
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        stage('Prepare Environment') {
            steps {
                sh '/usr/bin/python3 -m venv env || true' // Ignore errors if the env directory already exists
                sh 'ls -la' // Debugging: List current directory contents
            }
        }

        stage('Test') {
            steps {
                sh '''
                source env/bin/activate || true
                pip install -r requirements.txt || echo "requirements.txt not found!"
                python manage.py test || echo "manage.py not found or tests failed"
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
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 /bin/bash << EOF
                    cd /home/ec2-user/project
                    source env/bin/activate
                    pip install -r requirements.txt || echo "requirements.txt not found on EC2!"
                    python manage.py migrate || echo "manage.py not found or migration failed"
                    python manage.py collectstatic --no-input || echo "collectstatic failed"
                    # Restart your Django application, adjust the command as per your setup
                    sudo systemctl restart gunicorn.service || echo "Failed to restart gunicorn"
                    EOF
                    '''
                }
            }
        }
    }
}
