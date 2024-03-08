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
                    // Ensuring python3 is used to create a virtual environment
                    if (sh(script: 'which python3', returnStatus: true) == 0) {
                        sh 'python3 -m venv env'
                    } else {
                        error "Python3 is not installed"
                    }
                }
            }
        }

        stage('Test') {
            steps {
                sh(script: '''
                source env/bin/activate
                pip install -r requirements.txt
                python manage.py test
                ''', returnStdout: true, script: '/bin/bash')
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['aws-credentials']) {
                    sh(script: '''
                    rsync -avz --exclude 'env/' --exclude '.git/' --exclude 'db.sqlite3' ./ ec2-user@44.212.36.244:/path/to/your/deployment/directory && \
                    ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 \\
                    'cd /path/to/your/deployment/directory && \\
                    source env/bin/activate && \\
                    pip install -r requirements.txt && \\
                    python manage.py migrate && \\
                    python manage.py collectstatic --no-input && \\
                    sudo systemctl restart your_application_service'
                    ''', script: '/bin/bash')  // Adjust the command to restart your Django app
                }
            }
        }
    }
}
