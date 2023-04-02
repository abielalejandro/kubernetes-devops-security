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

        stage('Unit test and Jacoco Coverage') {
            steps {
              sh "mvn test-compile org.pitest:pitest-maven:mutationCoverage"
            }
        } 

        /*stage('Build docker and push') {
              steps {
                withDockerRegistry(credentialsId: "docker-hub", url: "") {
                  sh "printenv"
                  sh "docker build -t rjgc2810/kubernetes-devops-security:$GIT_COMMIT ."
                  sh "docker push rjgc2810/kubernetes-devops-security:$GIT_COMMIT"
                }
              }
          }

        stage('Deploy to k8s') {
              steps {
                withKubeConfig(credentialsId: "kubeconfig", serverUrl: "https://192.168.0.8:16443") {
                  sh 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"'
                  sh 'chmod u+x kubectl'
                  sh "sed -i 's#GIT_COMMIT#$GIT_COMMIT#g' k8s_deployment_service.yaml"
                  sh "cat k8s_deployment_service.yaml"
                  sh "./kubectl apply -f k8s_deployment_service.yaml"
                }
              }
          }  */                   
    }
}
