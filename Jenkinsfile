pipeline {
    // Defines the Docker agent for the entire pipeline.
    agent {
        docker { image 'node:18-alpine' }
    }

    // Set environment variables for the project.
    environment {
        // Replace with your Docker Hub username or registry.
        DOCKER_HUB_USERNAME = 'hardikdockeraws'
        // Replace with your image name.
        IMAGE_NAME = 'nextjs-app'
    }

    // This section defines the stages of the CI/CD pipeline.
    stages {
        // Stage 1: Build the Docker Image
        stage('Build Image') {
            steps {
                // Use a script block to run multiple commands.
                script {
                    echo "Building Docker image..."
                    // Build the Docker image with a version tag based on the build number.
                    // This creates a unique image for each successful build.
                    docker.build("${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_NUMBER}")
                }
            }
        }

        // Stage 2: Push and Deploy Locally
        stage('Push and Deploy Locally') {
            steps {
                script {
                    echo "Pushing Docker image to registry..."
                    // Push the newly built image to the Docker registry.
                    docker.withRegistry("https://registry.hub.docker.com", 'docker-hub-credentials') {
                        docker.image("${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_NUMBER}").push()
                    }

                    echo "Deploying on local machine..."
                    // Stop any existing container with the same name.
                    sh "docker stop nextjs-app-container || true"
                    // Remove the stopped container.
                    sh "docker rm nextjs-app-container || true"
                    // Run the new container from the newly pushed image.
                    sh "docker run -d --name nextjs-app-container -p 3000:3000 ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }
}
