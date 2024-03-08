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
                script {
                    // Creates a virtual environment only if it doesn't already exist
                    if (sh(script: 'test -d env || echo "envNotFound"', returnStdout: true).trim() == 'envNotFound') {
                        sh 'python3 -m venv env'
                    }
                }
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
                    // Exclude the local virtual environment directory but include other necessary files and directories
                    sh """
                    rsync -avz --exclude '/env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/path/to/your/deployment/directory && \
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 \\
                    'cd /path/to/your/deployment/directory && \\
                    if [ ! -d env ]; then python3 -m venv env; fi && \\
                    source env/bin/activate && \\
                    pip install -r requirements.txt && \\
                    python manage.py migrate && \\
                    python manage.py collectstatic --no-input && \\
                    sudo systemctl restart your_application_service'
                    """
                }
            }
        }
    }
}
