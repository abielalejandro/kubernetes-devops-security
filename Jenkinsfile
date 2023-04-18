pipeline {
  agent any
  environment {
    APP_NAME = "devsecops"
  }
  stages {

        stage('Unit test and Jacoco Coverage') {
            steps {
              sh "mvn clean test"
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

        stage('Sonarqube - SAST') {
          steps {
            withSonarQubeEnv('Sonarqube') {
              sh 'mvn clean compile sonar:sonar'
            }
            //timeout(time: 2, unit: 'MINUTES') {
            //    waitForQualityGate abortPipeline: true
            //}
          }
        }

        stage('Vulnerabilities scan') {
            steps {
                parallel(
                    "Dependency check": {
                        sh "mvn org.owasp:dependency-check-maven:check"
                    },
                    "Image scan": {
                        sh "bash vulnerability-scan.sh"
                    },
                    "OPA Confest": {
                        sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-docker-security.rego Dockerfile'
                    }
                )

            }
            post {
                always {
                  dependencyCheckPublisher pattern: "target/dependency-check-report.xml"
                }
            }
        }

        stage('Build Artifact') {
              steps {
                sh "mvn clean package -DskipTests=true"
                archive 'target/*.jar' //so that they can be downloaded later
              }
        }

        stage('Build docker and push') {
              steps {
                withDockerRegistry(credentialsId: "docker-hub", url: "") {
                  sh "printenv"
                  sh "mvn clean package -DskipTests=true"
                  sh "docker build -t rjgc2810/kubernetes-devops-security:$GIT_COMMIT ."
                  sh "docker push rjgc2810/kubernetes-devops-security:$GIT_COMMIT"
                }
              }
          }

        stage('Vulnerabilities scan K8S') {
          steps {
             parallel(
                "OPA": {
                  sh 'docker run --rm -v $(pwd):/project openpolicyagent/conftest test --policy opa-k8s-security.rego k8s_deployment_service.yaml'
                  },
                "Kubesec": {
                     sh ''' 
                       valid=$(docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < k8s_deployment_service.yaml | jq ".[0].valid")

                     sh "score=$(docker run -i kubesec/kubesec:512c5e0 scan /dev/stdin < k8s_deployment_service.yaml | jq ".[0].score")
                     if [[ "${score}" -gt 5 ] && [ "${valid}" == true ]];
                     then
                        echo 'Valid k8s file'
                     else 
                        echo 'Invalid k8s file'
                        exit 1
                     fi
                     '''
                }  
             )
          } 
        }

        //stage("Download kubectl client") {
          //steps {
            //sh "bash download-kubectl.sh"
          //}          
        //}

        stage('Deploy to k8s') {
              steps {
                  parallel(
                    "Deploy": {
                      withKubeConfig(credentialsId: "kubeconfig") {
                        sh "sed -i 's#GIT_COMMIT#$GIT_COMMIT#g' k8s_deployment_service.yaml"
                        sh "sed -i 's#APP_NAME#$APP_NAME#g' k8s_deployment_service.yaml"
                        sh "./kubectl apply -f k8s_deployment_service.yaml --record=true"
                      }
                    },
                    "Validate running status": {
                      withKubeConfig(credentialsId: "kubeconfig") {
                        sh 'bash validate.rollout.sh'                        
                      }
                    },
                  )                  
              }
          }
    }
}
