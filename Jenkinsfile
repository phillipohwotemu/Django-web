pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/phillipohwotemu/Django-web.git'
            }
        }

        stage('Test') {
            steps {
                sh '''
                /usr/bin/python3 -m venv env
                source env/bin/activate
                pip install -r requirements.txt
                /usr/bin/python3 manage.py test
                '''
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['aws-credentials']) {
                    sh """
                    rsync -avz --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/path/to/target/directory/on/ec2 && \
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 \\
                    'cd /path/to/target/directory/on/ec2 && \\
                    source env/bin/activate && \\
                    pip install -r requirements.txt && \\
                    /usr/bin/python3 manage.py migrate && \\
                    /usr/bin/python3 manage.py collectstatic --no-input && \\
                    sudo systemctl restart gunicorn'  # Adjust the command to restart your app
                    """
                }
            }
        }
    }
}
