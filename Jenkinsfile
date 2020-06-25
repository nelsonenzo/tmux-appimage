node {
    // #### define a variable "app"
    def app
    // def shortCommit
    def latestTmuxRelease

    stage("fetch tmux release version") {
        script {
            // 3.1b
            latestTmuxRelease = sh("curl -s https://api.github.com/repos/tmux/tmux/releases/latest | jq .tag_name")

            //   shortCommit = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
            //   DOCKERTAG = "${env.BUILD_ID}-${shortCommit}"
            //   def customImage = docker.build("wizelinedevops/wize-devops-nelsonh-ruby:${DOCKERTAG}", "./cidr_convert_api/ruby")
            //   customImage.inside {
            //     sh 'ruby /app/tests.rb'
            //   }
            //   customImage.push()
        }
    }

    stage("clone repository") { 
        checkout scm
    }
    stage("Build image") {
        // do this with args.
        app = docker.build('nelsonenzo/tmux-appimage')
    }
    stage("push image") {
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            app.push(latestTmuxRelease)
        }
    }


}