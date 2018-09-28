pipeline {
    agent any
    environment { 
        maintainer = "t"
        imagename = 'm'
        tag = 'l'
    }
    stages {
        stage ('Setting build context') {
            steps {
                script {
                    maintainer = maintain()
                    imagename = imagename()
                    if (env.BRANCH_NAME == "master" || env.BRANCH_NAME == "bats") {		// temporary
                       tag = "latest"
                    } else {
                       tag = env.BRANCH_NAME
                    }
                    if (!imagename) {
                        echo "You must define imagename in common.bash"
                        currentBuild.result = 'FAILURE'
                    }
                    sh 'mkdir -p bin'
                    sh 'mkdir -p tmp'
                    dir ('tmp') {
                        git([ url: "https://github.internet2.edu/docker/util.git", credentialsId: "jenkins-github-access-token" ])
                        sh 'ls'
                        sh 'mv bin/* ../bin/.'
                    }
                }  
            }
        }    
        stage ('Build') {
            steps {
                script {
                    try {
			sh '(docker image ls ; echo Destroying ; bin/destroy.sh ; docker image ls) 2>&1 | tee debug'	// temporary
                        sh './download-midpoint 2>&1 | tee -a debug'
                        sh 'bin/rebuild.sh 2>&1 | tee -a debug'
                        //sh 'echo Build output ; cat debug'
                    } catch (error) {
                        def error_details = readFile('./debug')
                        def message = "BUILD ERROR: There was a problem building ${imagename}:${tag}. \n\n ${error_details}"
                        sh "rm -f ./debug"
                        handleError(message)
                    }
                }
            }
        }
        stage ('Test') {
            steps {
                script {
                    try {
                        sh 'bin/test.sh 2>&1 | tee debug'
                        sh '(cd demo/simple ; bats tests ) 2>&1 | tee -a debug'
                        sh '(cd demo/shibboleth ; bats tests ) 2>&1 | tee -a debug'
                        // sh 'echo Test output ; cat debug'
                    } catch (error) {
                        def error_details = readFile('./debug')
                        def message = "BUILD ERROR: There was a problem testing ${imagename}:${tag}. \n\n ${error_details}"
                        sh "rm -f ./debug"
                        handleError(message)
                    }
                }
            }
        }
        stage ('Push') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com/', "dockerhub-$maintainer") {
                        def baseImg = docker.build("$maintainer/$imagename")
                        baseImg.push("$tag")
                    }
                }
            }
        }
        stage ('Notify') {
            steps {
                echo "$maintainer"
                slackSend color: 'good', message: "$maintainer/$imagename:$tag pushed to DockerHub"
            }
        }
    }
    post { 
        always { 
            echo 'Done Building.'
        }
        failure {
            // slackSend color: 'good', message: "Build failed"
            handleError("BUILD ERROR: There was a problem building ${maintainer}/${imagename}:${tag}.")
        }
    }
}


def maintain() {
    def matcher = readFile('common.bash') =~ 'maintainer="(.+)"'
    matcher ? matcher[0][1] : 'tier'
}

def imagename() {
    def matcher = readFile('common.bash') =~ 'imagename="(.+)"'
    matcher ? matcher[0][1] : null
}

def handleError(String message) {
    echo "${message}"
    currentBuild.setResult("FAILED")
    slackSend color: 'danger', message: "${message}"
    sh 'exit 1'
}
