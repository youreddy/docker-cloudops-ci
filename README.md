# docker-cloudops-ci
This Dockerfile creates https://hub.docker.com/r/cfcloudops/cloudops-ci/

# Automatic build:

push changes to the Dockerfile. 

# Manual build
- [ ] confirm you want to do this. This will take forever. 
- [ ] `vagrant up`
- [ ] Seriously? You want to do this manually?
- [ ] 

```
    vagrant ssh
    cd /vagrant
    docker build .
    # go take a coffee break
    docker tag <image> cfcloudops/docker-cloudops-ci:0.x.y
    docker tag <image> cfcloudops/docker-cloudops-ci:latest
    docker login
    docker push cfcloudops/docker-cloudops-ci
```

