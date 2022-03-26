# moviedb react node app by omarxs2 

### Steps: 

1- Create Dev Cluster 
```
gcloud container clusters create omar-moviedb-dev-cluster \
    --project=devops-343007 \
    --zone=us-west2-a \
    --network=omar-vpc \
    --enable-ip-alias \
	--num-nodes=1
```

2- Connect to source repos

3- Create cloudebuild.yaml file that auto build and deploy, it should contain:

``` npm install -g @adpt/cli ```

``` gcloud container clusters get-credentials omar-moviedb-dev-cluster --zone=us-west2-a ```

``` gcloud auth configure-docker --quiet  ```

``` export KUBE_DOCKER_REPO=gcr.io/devops-343007  ```

``` cd repo/deploy ```

``` adapt run k8s-test --deployID omar-app-dev ```
