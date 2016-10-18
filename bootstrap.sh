#!/usr/bin/env bash

installDocker="true"

##See note below.. leave these set to false for now.
containerDefectDojo="false"
containerJenkins="false"
containerSonarQube="false"

#install Docker
if [ "$installDocker" = "true" ]; then
	apt-get update
	apt-get -y install curl
	curl -fsSL https://get.docker.com/ | sh
	usermod -aG docker vagrant
fi

### These options do not currently work. The commands below can be run manually to set up the environments, but they do not work if Vagrant runs them. I suspect these may need to be run as daemons, but I'm not sure.
#setup defect dojo
if [ "$containerDefectDojo" = "true" ]; then
	echo "Setting up Defect Dojo"
	docker run -it -p 8000:8000 aweaver/django-defectdojo bash -c "export LOAD_SAMPLE_DATA=True && bash /django-DefectDojo/docker/docker-startup.bash"
fi

#setup Jenkins
if [ "$containerJenkins" = "true" ]; then 
	docker run -p 8080:8080 -p 50000:50000 jenkins
	#docker run -p 8080:8080 -p 50000:50000 -v /your/home:/var/jenkins_home jenkins #this will mount jenkins home to the host's home dir
fi

#setup SonarQube
if [ "$containerSonarQube" = "true" ]; then 
	docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube
fi

	echo 'Script finished.'
