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
                // Assuming virtualenv is installed, create a virtual environment
                sh 'virtualenv env || true' // Use virtualenv as an alternative
            }
        }

        stage('Test') {
            steps {
                // Explicitly use bash to source the virtual environment
                sh '/bin/bash -c "source env/bin/activate && pip install -r requirements.txt && python manage.py test"'
            }
        }

        // Continue with the 'Deploy' stage as before
    }
}
