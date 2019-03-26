Returnpath Task
=======

## Dependencies

This project is run using [docker](https://www.docker.com/) and [kubernetes](https://kubernetes.io/).
It assumes there is a local, up-to-date installation of [`docker`](https://docs.docker.com/install/) and [`minikube`](https://kubernetes.io/docs/tasks/tools/install-minikube/).
It also uses [`make`](https://www.gnu.org/software/make/) to automate common series of `bash` commands, so that is the only other dependency.

## Running

Running is simple: just `make run`, or just `make`.
This command will:

1. build the docker container in which the webapp will run
2. run the container with `docker` and attach it to your tty

The server will be bound to `0.0.0.0:8000`, so you can then access the webapp at `localhost:8000`.
To stop the process, `^C` will work fine.
If you just want to build the container, try `make build`.

## Deployment

The required Service and Deployment needed to deploy to kubernetes are defined in `kubernetes.yaml`.
These can be installed to kubernetes (assuming `kubectl` is properly configured) with `kubectl apply -f kubernetes.yaml`.
Note that this only creates a kubernetes-facing service, so an Ingress still needs to be configured (or a loadbalancer pointed to the correct NodePort).

The most direct and simple way to run the app on kubernetes is on minikube.
First, run `minikube start` to launch kubernetes in a vm.
Once that command has exited, run `kubectl apply -f kubernetes.yaml` to install the Deployment and Service.
Wait until both are running (check with `kubectl get deployments`), and then you can test the service with `curl $(minikube service returnpath-task --url)`.

*Note*: the configurations defined in `kubernetes.yaml` use an image I uploaded to dockerhub.
If you wish to use an image you built instead, you need to replace the image (`.spec.template.spec.containers[].image`) in the Deployment configuration.

## The Webapp

The app is a simple [Flask](http://flask.pocoo.org/) webapp (5 lines of code) run behind a [gunicorn](https://gunicorn.org/) wsgi server bound to `0.0.0.0:8000`.
The only libraries that are installed to the docker container are `flask` and `gunicorn`.
