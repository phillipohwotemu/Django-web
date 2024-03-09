pipeline {
    agent any

    stages {
        stage('Setup & Debug') {
            steps {
                sh 'rm -rf env || true' // Clean up previous environment attempts
                sh '/usr/bin/python3 -m venv env || true' // Attempt to create the virtual environment
                sh 'ls -la' // List current directory to debug file presence
                sh '/usr/bin/python3 --version' // Verify Python installation
            }
        }

        stage('Test') {
            steps {
                sh 'if [ -f env/bin/activate ]; then source env/bin/activate; fi' // Conditionally activate venv
                sh 'if [ -f requirements.txt ]; then pip install -r requirements.txt; else echo "requirements.txt not found!"; fi'
                sh 'if [ -f manage.py ]; then /usr/bin/python3 manage.py test; else echo "manage.py not found or tests failed"; fi'
            }
        }
        
        // Keep the Deploy stage as is, ensuring adjustments for your specific setup
    }
}
