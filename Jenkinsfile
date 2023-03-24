pipeline {
  agent any

  stages {
        stage('Build Artifact') {
              steps {
                sh "mvn clean package -DskipTests=true"
                archive 'target/*.jar' //so that they can be downloaded later
              }
          }

        stage('Unit test and Jacoco Coverage') {
            steps {
              sh "mvn test"
            }
            post {
              always {
                junit "target/surefire-reports/*.xml"
                jacoco execPattern: "target/jacoco.exe"
              }
            }
        } 

        stage('Build docker and push') {
              steps {
                sh "printenv"
                sh "docker build -t rjgc2810/kubernetes-devops-security:"$GIT_COMMIT" ."
                sh "docker push rjgc2810/kubernetes-devops-security:"$GIT_COMMIT" ."
              }
          }          
    }
}
