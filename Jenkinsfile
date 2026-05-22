pipeline {
    agent any
    environment {
        // Your real Docker Hub target image mapping
        IMAGE_NAME = "nikhileshsandela/flask-devops"
    }
    stages {
        // Step 1: Removed the redundant 'Pull Code' stage. 
        // Jenkins handles SCM checkouts automatically based on your Job UI settings.

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck odcInstallation: 'owasp', additionalArguments: '--scan ./ --nvdConfigFile https://github.io'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                // Dynamically reads the global SonarQube configuration credentials
                withSonarQubeEnv('sonarqube') {
                    sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=flask-app \
                    -Dsonar.sources=.
                    '''
                }
            }
        }
        
        stage('Docker Build') {
            steps {
                // Fixed: Explicitly mapped to the correct official v1 Docker Hub endpoint API
                withDockerRegistry([credentialsId: 'dockerhub', url: 'https://docker.io']) {
                     sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                // Runs security scans over the newly created image layer
                sh 'trivy image $IMAGE_NAME:$BUILD_NUMBER'
            }
        }
        
        stage('Docker Push') {
            steps {
                // Fixed: Added the correct URL registry argument to the push task as well
                withDockerRegistry([credentialsId: 'dockerhub', url: 'https://docker.io']) {
                    sh 'docker push $IMAGE_NAME:$BUILD_NUMBER'
                }
            }
        }
    }
}

