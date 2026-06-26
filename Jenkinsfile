pipeline {
    agent any
    tools {
        jdk 'jdk'
        nodejs 'node'
    }
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        TRIVY_CACHE_DIR = "/var/lib/jenkins/.trivy-cache"
    }
    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            steps {
                git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/xyushman/StackBucks-Project-End-toEnd-Pipeline'
            }
        }
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''$SCANNER_HOME/bin/sonar-scanner \
                        -Dsonar.projectName=starbucks \
                        -Dsonar.projectKey=starbucks'''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('TRIVY FS Scan') {
            steps {
                sh """
                    trivy fs \
                        --cache-dir ${TRIVY_CACHE_DIR} \
                        --no-progress \
                        . > trivyfs.txt 2>&1 || true
                    cat trivyfs.txt
                """
            }
        }
        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                        sh "docker build -t xyushman/starbucks:latest ."
                        sh "docker push xyushman/starbucks:latest"
                    }
                }
            }
        }
        stage('TRIVY Image Scan') {
            steps {
                sh """
                    trivy image \
                        --cache-dir ${TRIVY_CACHE_DIR} \
                        --no-progress \
                        xyushman/starbucks:latest > trivyimage.txt 2>&1 || true
                    cat trivyimage.txt
                """
            }
        }
        stage('App Deploy to Docker Container') {
            steps {
                sh '''
                    docker stop starbucks || true
                    docker rm   starbucks || true
                    docker run -d --name starbucks -p 3000:3000 xyushman/starbucks:latest
                '''
            }
        }
    }
    post {
        always {
            script {
                def status = currentBuild.currentResult
                emailext(
                    subject: "Pipeline ${status}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                    body: """
                        <p>Build result: <b>${status}</b></p>
                        <p>Job: ${env.JOB_NAME} | Build: #${env.BUILD_NUMBER}</p>
                        <p><a href="${env.BUILD_URL}">View console output</a></p>
                    """,
                    to: 'ayushmanng04@gmail.com',
                    mimeType: 'text/html',
                    attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
                )
                sh "docker rmi xyushman/starbucks:latest || true"
            }
        }
    }
}
