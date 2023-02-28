def branch = "staging"
def remote_name = "origin"
def directory = "~/fe-dumbmerch/"
def credential = 'appserver'
def server = 'app@103.67.186.80'
def image = 'angga6699/dumbmerch-frontend-staging'
def container = 'dumbmerch-frontend-staging'

pipeline {
    agent any

    stages {
        stage('Repository Pull') {
            steps {
                sshagent([credential]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker container stop ${container}
                    docker image prune
                    git pull ${remote_name} ${branch}
                    exit
                    EOF"""
                }
            }
        }

        stage('Building Docker Image') {
            steps {
                sshagent([credential]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker build -t ${image}:${env.BUILD_ID} .
                    exit
                    EOF"""
                }
            }
        }

        stage('Image Deployment') {
            steps {
                sshagent([credential]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker tag ${image}:${env.BUILD_ID} ${image}:${env.BUILD_ID}-latest
                    docker compose -f docker-compose.yml up -d
                    exit
                    EOF"""
                }
            }
        }

        stage('Pushing to Docker Hub') {
            steps {
                sshagent([credential]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker image push ${image}:${env.BUILD_ID}-latest
                    exit
                    EOF"""
                }
            }
        }
        stage('Push Notification Discord') {
           steps {
                sshagent([credential]){
                    discordSend description: "dumbmerch-frontend-staging:" + BUILD_ID, footer: "appserver-frontend-staging", link: BUILD_URL, result: currentBuild.currentResult, scmWebUrl: '', title: 'dumbmerch-frontend-staging', webhookURL: 'https://discord.com/api/webhooks/1080008510240198746/o1cZVi_EFKiwBOTd3GyqGCSBd3VI6XFuyMwmuZL9Wlh-fU3SOU3d_GKyR7ijMVW6vQ0V'
                }
            }
        }
    }
}
