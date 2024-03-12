pipeline {
    agent any

    stages {
        stage('Prepare Workspace') {
            steps {
                // Cleans the workspace to ensure a fresh start
                cleanWs()
                echo 'Workspace cleaned.'
            }
        }

        stage('Checkout SCM') {
            steps {
                echo 'Checking out source code...'
            }
        }

        // Other stages remain unchanged
    }

    // Post stage remains unchanged
}
