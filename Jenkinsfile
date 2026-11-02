pipeline {
    agent any

    environment {
        gitLabel = VersionNumber([
            projectStartDate: '2024-01-01',
            versionNumberString: "${params.gitLabel}",
            worstResultForIncrement: 'SUCCESS'
        ])
    }

    stages {
        stage('Unit Test') {
            steps {
                script {
                    currentBuild.displayName = "${params.gitLabel}"
                }
                echo 'Skipped...'
            }
        }
        stage('Docker Build') {
            steps {
                sh "docker build --build-arg debug_mode=--no-dev -t rmamba/tor-ip-check:latest ."
            }
        }
        stage('E2E Test (local)') {
            steps {
                echo 'Skipped...'
            }
        }
        stage('Docker:login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'rmamba_docker_io',
                                                usernameVariable: 'DH_USER',
                                                passwordVariable: 'DH_TOKEN')]) {
                    sh '''
                        set -e
                        export DOCKER_CONFIG=$(mktemp -d)        # isolated, no stale helper/cache
                        echo "$DH_TOKEN" | docker login -u $DH_USER --password-stdin
                    '''
                }
            }
        }
        stage('Docker:latest') {
            steps {
                sh "docker push rmamba/tor-ip-check:latest"
            }
        }
        stage('Push to stage') {
            steps {
                echo 'Skipped...'
                // sh './redeploy-rancher-stage.sh'
            }
        }
        stage('E2E Test (stage)') {
            steps {
                echo 'Skipped...'
            }
        }
        stage('Docker:tag') {
            steps {
                sh "docker tag rmamba/tor-ip-check:latest rmamba/tor-ip-check:${params.gitLabel}"
                sh "docker push rmamba/tor-ip-check:${params.gitLabel}"
                sh "docker rmi rmamba/tor-ip-check:${params.gitLabel}"
                sh "docker rmi rmamba/tor-ip-check:latest"
            }
        }
        stage('Docker:logout') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'rmamba_docker_io',
                                                usernameVariable: 'DH_USER',
                                                passwordVariable: 'DH_TOKEN')]) {
                sh '''
                    set -e
                    export DOCKER_CONFIG=$(mktemp -d)        # isolated, no stale helper/cache
                    docker logout
                    rm -rf "$DOCKER_CONFIG"
                '''
                }
            }
        }
        stage('Push to production') {
            steps {
                echo 'Skipped...'
            }
        }
        stage('E2E Test (production)') {
            steps {
                echo 'Skipped...'
            }
        }
    }
}
