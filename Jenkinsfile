pipeline {
    // We use a generic agent to run the pipeline on the host machine,
    // which has access to the Docker daemon.
    agent any

    tools {
        // Ensure that Node.js and npm are available in the pipeline environment.
        // You'll need to configure this in Jenkins under "Global Tool Configuration"
        // and name it "NodeJS_18".
        nodejs 'NodeJS_18'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Build Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    // Build the Docker image using the Dockerfile in the project root.
                    sh 'docker build -t hardikdockeraws/nextjs-app .'
                }
            }
        }

        stage('Push and Deploy Locally') {
            steps {
                echo 'Pushing Docker image and deploying locally...'

                // Stop and remove any existing container with the same name to avoid conflicts.
                sh 'docker stop nextjs-app || true'
                sh 'docker rm nextjs-app || true'

                // Run the new container with the newly built image.
                sh 'docker run -d --name nextjs-app -p 3000:3000 hardikdockeraws/nextjs-app'
            }
        }
    }
}
