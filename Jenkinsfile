pipeline {
    agent any
    
    tools {
        nodejs 'node' 
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
        NODEJS_HOME = tool 'node'
        
    }
    
    

    stages {
        stage('checkout git') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/gurleen131/Dishify_CICD.git'
            }
        }
        
        
        stage('install dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        // stage('static code analysis') {
        //     steps {
        //         sh 'npm run lint'
        //     }
        // }
        
        // stage('unit testing') {
        //     steps {
        //         sh 'npm test'
        //     }
        // }
        
        stage('Verify Workspace') {
            steps {
                sh 'ls -la'
            }
        }
        
        
        stage('trivy scan') {
            steps {
                sh 'trivy fs --format table -o trivy-fs-report.html .'
            }
        }
        
        stage('sonarqube analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                     sh '''$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=dishify -Dsonar.projecName=dishify \
                            -Dsonar.sources=public,server,views,app.js '''
                }
            }
        }
        
        
        stage('Publish') {
            steps {
                echo "Publishing...."
                sh "npm publish"
            }
        }
        
        stage('Build and Tag Docker image') {
            steps {
                echo "building image..."
                sh '''docker build -t gurleen131/dishify:latest . '''
                
            }
        }
        
        stage('trivy scan image') {
            steps {
                sh 'trivy image --format table -o trivy-image-report.html gurleen131/dishify:latest'
            }
        }
        
        stage('Publish Docker image') {
            steps {
                echo "building image..."
                withCredentials([usernamePassword(credentialsId:'docker-creds', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                    sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
                    sh 'docker tag gurleen131/dishify:latest gurleen131/dishify'
                    sh ' docker push gurleen131/dishify'
                    sh 'docker logout'
                    }
            }
        }

    }
}