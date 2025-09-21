pipeline {
    agent any // Use the main Jenkins agent for the overall pipeline.

    stages {
        stage('Checkout Code') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Build Next.js App') {
            // This block uses a temporary container for the build process.
            agent {
                docker {
                    image 'node:18-alpine'
                }
            }
            steps {
                script {
                    echo 'Building Next.js application...'
                    // We still use a local cache to avoid the permissions error.
                    withEnv(['NPM_CONFIG_CACHE=./.npm-cache']) {
                        sh 'npm install'
                        sh 'npm run build'
                    }
                }
            }
        }
        
        stage('Build and Push Docker Image') {
            // This stage runs on the main Jenkins agent, where the Docker CLI is available.
            steps {
                echo 'Building and pushing Docker image...'
                sh 'docker build -t hardikdockeraws/nextjs-app .'
                // Uncomment the line below to push the image to Docker Hub
                // sh 'docker push hardikdockeraws/nextjs-app'
                // This is the new part for Docker login and push
                // The withCredentials block securely handles your Docker Hub credentials
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker login -u ${env.DOCKER_USERNAME} -p ${env.DOCKER_PASSWORD}"
                    sh "docker push hardikdockeraws/nextjs-app"
            }
        }
        
        stage('Deploy Locally') {
            // This stage also runs on the main Jenkins agent.
            steps {
                echo 'Deploying locally...'
                sh 'docker stop nextjs-app || true'
                sh 'docker rm nextjs-app || true'
                sh 'docker run -d --name nextjs-app -p 3000:3000 hardikdockeraws/nextjs-app'
            }
        }
    }
}
