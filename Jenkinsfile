pipeline {
    agent any
    environment {
        IMAGE_NAME = "YOUR_DOCKERHUB_USERNAME/flask-devops"
    }
    stages {
        stage('Pull Code') {
            steps {
                git 'YOUR_GITHUB_REPO'
            }
        }
        stage('OWASP Dependency Check') {
            steps {
                  // Explicitly declare the tool name "owasp"
		  dependencyCheck odcInstallation: 'owasp', additionalArguments: '--scan ./'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=flask-app \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://YOUR_SERVER_IP:9000 \
                    -Dsonar.login=YOUR_TOKEN
                    '''
                }
            }
        }
        stage('Docker Build') {
	    steps {
		// Explicitly include the target hub URL parameter
	        withDockerRegistry([credentialsId: 'dockerhub', url: 'https://docker.io']) {
		     sh 'docker build -t $IMAGE_NAME:$BUILD_NUMBER .'
	        }
	    }
	}

        stage('Trivy Scan') {
            steps {
                sh 'trivy image $IMAGE_NAME:$BUILD_NUMBER'
            }
        }
        stage('Docker Push') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhub']) {
                    sh 'docker push $IMAGE_NAME:$BUILD_NUMBER'
                }
            }
        }
    }
}
