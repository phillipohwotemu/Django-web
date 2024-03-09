pipeline {
    agent any

    stages {
        // Other stages...

        stage('Test') {
            steps {
                script {
                    // Use script block for conditional execution
                    if (fileExists('env/bin/activate')) {
                        // Explicitly call bash to run the script
                        sh '/bin/bash -c "source env/bin/activate && pip install -r requirements.txt && python manage.py test"'
                    } else {
                        echo 'Virtual environment activation script does not exist.'
                    }
                }
            }
        }

        // Further stages...
    }
}
