pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Installing Node.js and npm...'
                // Install Node.js directly into the workspace to avoid plugin dependency
                sh 'curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -'
                sh 'sudo apt-get install -y nodejs'
                sh 'node -v'
                sh 'npm -v'
                echo 'Dependencies installed successfully.'
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

                // Stop and remove any existing container with the same name.
                sh 'docker stop nextjs-app || true'
                sh 'docker rm nextjs-app || true'

                // Run the new container with the newly built image.
                sh 'docker run -d --name nextjs-app -p 3000:3000 hardikdockeraws/nextjs-app'
            }
        }
    }
}
