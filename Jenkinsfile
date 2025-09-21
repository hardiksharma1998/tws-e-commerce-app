pipeline {
    // We use a Docker container as the build agent.
    // This provides a clean, consistent environment and avoids all host-related permission issues.
    agent {
        docker {
            image 'node:18-alpine'
            // The volumes argument is crucial. It mounts the host's Docker socket into the container,
            // allowing the agent to execute Docker commands on the host.
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
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
                    echo 'Building Next.js application and Docker image...'
                    
                    // The withEnv block sets an environment variable that tells npm to use a
                    // cache directory within the workspace, resolving the EACCES permissions error.
                    withEnv(['NPM_CONFIG_CACHE=./.npm-cache']) {
                        // These commands run inside the node:18-alpine container.
                        sh 'rm -rf node_modules'
                        sh 'npm cache clean --force'
                        sh 'npm install'
                        sh 'npm run build'
                    }

                    // Now, we use the Docker CLI inside the container to build the final image on the host.
                    sh 'docker build -t hardikdockeraws/nextjs-app .'
                }
            }
        }
        
        stage('Push and Deploy Locally') {
            steps {
                echo 'Pushing Docker image and deploying locally...'
                
                // These commands run on the host system, not inside the container agent.
                // They are simple Docker commands that the Jenkins user must be able to run.
                // This requires the Jenkins user to be in the 'docker' group.
                sh 'docker stop nextjs-app || true'
                sh 'docker rm nextjs-app || true'
                sh 'docker run -d --name nextjs-app -p 3000:3000 hardikdockeraws/nextjs-app'
            }
        }
    }
}
