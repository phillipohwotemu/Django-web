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
                git branch: 'main',
                    url: 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        stage('Prepare Environment') {
            steps {
                sh '/usr/bin/python3 -m venv env || true' // Attempt to create a virtual environment
            }
        }

        stage('Test') {
            steps {
                sh '''
                /bin/bash -c "if [ -f env/bin/activate ]; then source env/bin/activate; else echo 'env/bin/activate does not exist'; fi"
                /bin/bash -c "if [ -f requirements.txt ]; then pip install -r requirements.txt; else echo 'requirements.txt not found!'; fi"
                /bin/bash -c "if [ -f manage.py ]; then python manage.py test; else echo 'manage.py not found or tests failed'; fi"
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['aws-credentials']) {
                    sh '''
                    /bin/bash -c "which rsync || echo 'rsync not found'"
                    /bin/bash -c "rsync -avz --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/home/ec2-user/project || echo 'rsync command failed'"
                    /bin/bash -c "ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 'bash -s' << 'EOF'
                    if [ -d /home/ec2-user/project ]; then
                        cd /home/ec2-user/project
                        if [ -f env/bin/activate ]; then source env/bin/activate; else echo 'env/bin/activate does not exist on EC2'; fi
                        if [ -f requirements.txt ]; then pip install -r requirements.txt; else echo 'requirements.txt not found on EC2!'; fi
                        if [ -f manage.py ]; then python manage.py migrate; else echo 'manage.py not found or migration failed on EC2'; fi
                        if [ -f manage.py ]; then python manage.py collectstatic --no-input; else echo 'collectstatic failed on EC2'; fi
                        sudo systemctl restart gunicorn.service || echo 'Failed to restart gunicorn on EC2'
                    else
                        echo '/home/ec2-user/project directory does not exist on EC2'
                    fi
                    EOF || echo 'SSH command execution failed'"
                    '''
                }
            }
        }
    }
}
