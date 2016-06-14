# docker-cloudops-ci
This Dockerfile creates https://hub.docker.com/r/cfcloudops/docker-cloudops-ci/

# Apline
The docker file in the alpine folder builds this image:
https://hub.docker.com/r/cfcloudops/cloudops-minimal/

# Docker bosh-init
This dockerfile creates an image for bosh-init located here
https://hub.docker.com/r/cfcloudops/cloudops-bosh-init/


Anything workstation that uses construct does not need the vagrant file.  Simply type your docker commands from any location at any time.

To build tag and push:

```
    docker login
    docker build .
    # go take a coffee break
    docker tag <image> cfcloudops/docker-cloudops-ci:0.x.y
    docker tag <image> cfcloudops/docker-cloudops-ci:latest
    docker push cfcloudops/docker-cloudops-ci
```

note: you can find the image from the command `docker images` the most recent build is probably your image