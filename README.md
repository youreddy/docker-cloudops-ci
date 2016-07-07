# docker-cloudops-ci/Dockerfile
This Dockerfile creates https://hub.docker.com/r/cfcloudops/docker-cloudops-ci/

# cloudops-minimal/Dockerfile
The docker file in the alpine folder builds this image:
https://hub.docker.com/r/cfcloudops/cloudops-minimal/

# cloudops-bosh-init/Dockerfile
This dockerfile creates an image for bosh-init located here
https://hub.docker.com/r/cfcloudops/cloudops-bosh-init/


Anything workstation that uses construct does not need the vagrant file.  Simply type your docker commands from any location at any time.


To build tag and push:

```
    docker login
    docker build .
    # go take a coffee break
    docker tag <image> cfcloudops/<repo_name>:0.x.y
    docker tag <image> cfcloudops/<repo_name>:latest
    docker push cfcloudops/<repo_name>
```

note: you can find the image from the command `docker images` the most recent build is probably your image
