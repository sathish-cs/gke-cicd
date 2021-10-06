# Docker

Docker is a os level virtualization to package applications in form of containers.

## Usage

Docker run is a command to create container which creates writable layer to the image. 

PROJECT_ID = id of gcp project

```
docker run -it -d --name appname -p 80:8000  gcr.io/${PROJECT_ID}/web:v1
```
Options

`- it` - Used to open interactive (STDIN) and allocate tty.

`-d` - used to run container in detach mode so container can be accessible at any time since its keep running in backround.

`-p` - Exposing application port to host.

## Best Practices followed

* Each docker RUN, COPY creates layer to minimize image layer footprint running all dependences using single RUN 
* Used only stable versions of the images
* Running application using root user is never recommended, created non root user to run application.
* Use COPY rather than ADD. COPY just copy the source to destination whereas ADD can download the file from any URL & extract them (in some cases file could be vulnerable)
* Used .dockerignore to exclude the .git and other unnecessary files like modules. It works similar to .gitignore to exclude the files.

Optional
* Volumes can be mounted to container using -v, if container needs persitant storage.

### CICD using gcp cloudbuilders

Cloud builders using containers to build, push images to repository and deploy images on GKE cluster. Its automatically scales up and down with no need provisioning servers.

In cloudbuilders configured the follow things to integreate Github

* Name
* Description
* Event - Selected `Push to a branch` - This will invoke if any push event occurs on the Github repository
* Sources - Selected my repo and branch 
* Build configuration - cloudbuild.yaml


To work with cloudbuilders configuration (cloudbuild.yaml) file has to be defined.

  * Name - image name to excute our steps
  * Args - used to pass list of arguments to the builder.


### Passed values as variables on cloud build

* PROJECT_ID - id of project
* SHORT_SHA - is part of default and it captures commit id tag it with the image 
* CLOUDSDK_COMPUTE_ZONE - availablity zone 
* CLOUD_LOGGING_ONLY - enables logs of build and stores it on cloud storage

* Cloud builder triggers if any push event occurs on repository which build the image and push to container registry with latest commit id and deploy to the GKE cluster. 

Each stage has defined as steps `build, push, deploy`. We can involve multiple steps before deployment like backend test, image scanner using trivy to find CRICTICAL vulnerabilities etc.

* Tests on container can able to do by using latest docker image and run test by specifying args and then deploy application. This will come before deployment stage. 

```
  - name: 'gcr.io/cloud-builders/docker'
    entrypoint: 'bash'
    args: ['-c', 'docker run gcr.io/${PROJECT_ID}/web:$SHORT_SHA pytest']
```
* `pytest` only works with python application. 
----------------
=======
# gke-cicd
CICD  pipeline to deploy application into GKE using cloud builders
