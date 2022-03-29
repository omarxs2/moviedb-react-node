# moviedb react node app by omarxs2 

### Steps: 

1- Create VPC and Dev Cluster 

* Using gcloud:
```
gcloud container clusters create omar-moviedb-dev-cluster \
    --project=devops-343007 \
    --zone=us-west2-a \
    --network=omar-vpc \
    --enable-ip-alias \
	--num-nodes=1
```

* Using terraform:
``` terrafom apply ```

2- Connect to source repos

3- Create cloudebuild.yaml file that auto build and deploy, it should contain:

``` gcloud container clusters get-credentials development-cluster --zone=us-central1-a```

``` gcloud auth configure-docker --quiet  ```

``` export KUBE_DOCKER_REPO=gcr.io/omar-devops  ```

``` cd ./deploy ```

``` adapt run k8s-test --deployID omar-app-dev ```

these steps will automaticly be ruuned at every time we push our code to main branch