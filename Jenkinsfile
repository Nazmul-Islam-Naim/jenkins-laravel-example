pipeline {
    agent any

    environment {
        APP_NAME = 'jenkins-laravel-example'
    }

    stages {
        stage('Checkout') {
            steps {
                sshagent(['github-key']) {   // Use the Jenkins credential ID
                    sh 'git clone git@github.com:Nazmul-Islam-Naim/jenkins-laravel-example.git || echo "Repo exists"'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'composer install --no-interaction --prefer-dist'
            }
        }

        // stage('Run Migrations') {
        //     steps {
        //         sh 'php artisan migrate --force'
        //     }
        // }

        stage('Run Tests') {
            steps {
                sh 'php artisan test'
            }
        }

        stage('Build/Cache') {
            steps {
                sh 'php artisan config:cache'
                sh 'php artisan route:cache'
                sh 'php artisan view:cache'
            }
        }
    }

    post {
        success {
            echo 'Build and tests completed successfully!'
        }
        failure {
            echo 'Build or tests failed!'
        }
    }
}
