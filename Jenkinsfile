pipeline {
    agent any

    stages {
        stage('Cleanup and Prepare Environment') {
            steps {
                sh 'rm -rf env || true'
                sh 'python3 -m venv env'
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'bash -c "source env/bin/activate && pip install -r requirements.txt || echo \\"requirements.txt not found!\\""'
            }
        }

        stage('Test') {
            steps {
                sh 'bash -c "source env/bin/activate && python3 manage.py test"'
            }
        }

        stage('Deploy') {
    steps {
        sshagent(credentials: ['ec2-deploy-key-django-app']) {
            sh '...'
        }
    }
}

    }
}
