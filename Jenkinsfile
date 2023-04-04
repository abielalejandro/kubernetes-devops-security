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
                always{
                    junit "target/surefire-reports/*.xml"
                    jacoco execPattern: "target/jacoco.exe"
                }
            }
        }

        stage('Mutation test') {
            steps {
              sh "mvn clean test-compile org.pitest:pitest-maven:mutationCoverage"
              archive 'target/pit-reports/**/*.html'
            }
        } 

        stage('Sonarqube SAST') {
          steps {
            withSonarQubeEnv('Sonarqube') {
              sh 'mvn clean compile sonar:sonar'
            }
            timeout(time: 2, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
          }
        }

        stage('Dependency check') {
            steps {
              sh "mvn org.owasp:dependency-check-maven:check"
            }
            post {
                always {
                        dependencyCheckPublisher pattern: "target/dependency-check-report.xml"
                }
            }
        }
            /*steps {
              sh '''
                mvn clean verify sonar:sonar \
                  -Dsonar.projectKey=numeric \
                  -Dsonar.host.url=http://192.168.0.8:9000 \
                  -Dsonar.login=sqp_1cdf424379935ec323f20979baceb765378f0da3
              '''
            }
        stage('Build docker and push') {
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
