pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Install Node.js') {
            steps {
                script {
                    echo 'Installing Node.js and npm...'
                    // Download the Node.js setup script
                    sh 'curl -fsSL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh'
                    // Execute the script with sudo
                    sh 'sudo bash nodesource_setup.sh'
                    // Install Node.js
                    sh 'sudo apt-get install -y nodejs'
                    echo 'Node.js installed successfully.'
                }
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
