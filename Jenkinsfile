pipeline {
    agent any

    environment {
        APP_NAME = "jenkins-laravel-example"
        PHP_IMAGE = "php:8.2-cli"
        WORKDIR = "jenkins-laravel-example"
    }

    stages {

        stage('Checkout') {
            steps {
                sshagent(['github-key']) {
                    sh '''
                        rm -rf jenkins-laravel-example
                        git clone git@github.com:Nazmul-Islam-Naim/jenkins-laravel-example.git
                    '''
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                dir(WORKDIR) {
                    sh '''
                        docker run --rm \
                          -v $PWD:/app \
                          -w /app \
                          php:8.2-cli bash -c "
                            apt-get update &&
                            apt-get install -y zip unzip curl &&
                            curl -sS https://getcomposer.org/installer | php &&
                            php composer.phar install --no-interaction --prefer-dist
                          "
                    '''
                }
            }
        }

        stage('Setup Environment') {
            steps {
                dir(WORKDIR) {
                    sh '''
                        cp .env.example .env || true

                        docker run --rm \
                          -v $PWD:/app \
                          -w /app \
                          php:8.2-cli php artisan key:generate
                    '''
                }
            }
        }

        stage('Run Migrations') {
            steps {
                dir(WORKDIR) {
                    sh '''
                        docker run --rm \
                          -v $PWD:/app \
                          -w /app \
                          php:8.2-cli php artisan migrate --force || true
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir(WORKDIR) {
                    sh '''
                        docker run --rm \
                          -v $PWD:/app \
                          -w /app \
                          php:8.2-cli php artisan test
                    '''
                }
            }
        }

        stage('Build Laravel Cache') {
            steps {
                dir(WORKDIR) {
                    sh '''
                        docker run --rm \
                          -v $PWD:/app \
                          -w /app \
                          php:8.2-cli php artisan config:cache

                        docker run --rm \
                          -v $PWD:/app \
                          -w /app \
                          php:8.2-cli php artisan route:cache

                        docker run --rm \
                          -v $PWD:/app \
                          -w /app \
                          php:8.2-cli php artisan view:cache
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir(WORKDIR) {
                    sh '''
                        docker build -t ${APP_NAME}:latest .
                        docker save ${APP_NAME}:latest -o ${APP_NAME}.tar
                    '''
                }
            }
        }

    }

    post {
        success {
            echo "CI/CD pipeline completed successfully!"
            archiveArtifacts artifacts: "${WORKDIR}/${APP_NAME}.tar", fingerprint: true
        }
        failure {
            echo "CI/CD pipeline failed!"
        }
    }
}
