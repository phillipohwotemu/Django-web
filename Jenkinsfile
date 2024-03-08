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
                sh 'which python3 || { echo "Python3 is not installed"; exit 1; }'
                sh 'python3 -m venv env'
            }
        }

        stage('Test') {
            steps {
                sh 'bash -c "source env/bin/activate && pip install -r requirements.txt && python manage.py test"'
            }
        }

        stage('Deploy') {
            steps {
                sshagent(credentials: ['aws-credentials']) {
                    sh 'bash -c "rsync -avz --exclude \'env/\' --exclude \'.git/\' --exclude \'db.sqlite3\' ./ ec2-user@44.212.36.244:/path/to/your/deployment/directory"'
                    sh 'bash -c "ssh -o StrictHostKeyChecking=no ec2-user@44.212.36.244 \'cd /path/to/your/deployment/directory && source env/bin/activate && pip install -r requirements.txt && python manage.py migrate && python manage.py collectstatic --no-input && sudo systemctl restart your_application_service\'"'
                }
            }
        }
    }
}
