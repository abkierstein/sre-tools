# SRE Tools
A collection of utilities commonly used by SRE for debugging

### Docker
[sre-tools container image available on dockerhub](https://hub.docker.com/r/abkierstein/sre-tools)

Interactive usage of sre-tools
```
$ docker run -it abkierstein/sre-tools:latest dig +short adam-yells-at-cloud.com
13.226.210.110
13.226.210.87
13.226.210.57
13.226.210.31
```

Testing the response from nginx
```
$ docker run -dp 8080:80 -t abkierstein/sre-tools
598f546bf5ad9f73513bb101736ab171bd547ae7868dfd73707464d8c2b5227a

$ curl -I localhost:8080
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 10 Jun 2022 04:28:47 GMT
Content-Type: text/html
Content-Length: 669
Last-Modified: Thu, 09 Jun 2022 15:14:21 GMT
Connection: keep-alive
ETag: "62a20e4d-29d"
Accept-Ranges: bytes
```

### Kubernetes
*See the examples/kubernetes/ directory more options*

Quick and dirty deploy
```
$ kubectl create deployment sre-tools --image=abkierstein/sre-tools:latest --port=80
```

Full "stack" deploy
```
$ kubectl create -f https://raw.githubusercontent.com/abkierstein/sre-tools/main/examples/kubernetes/sre-tools.yaml
```

Interactive usage of sre-tools pod
```
$ kubectl exec -it $(kubectl get pods -l app=sre-tools -o jsonpath='{.items[*].metadata.name}') -- nc -zv -w3 adam-yells-at-cloud.com 443
Connection to adam-yells-at-cloud.com (13.33.21.127) 443 port [tcp/https] succeeded!
```

Port Forward Access to Pod
```
$ kubectl port-forward deployment/sre-tools 8080:80 &
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80

$ curl -I localhost:8080
Handling connection for 8080
HTTP/1.1 200 OK
Server: nginx/1.18.0 (Ubuntu)
Date: Fri, 10 Jun 2022 04:41:34 GMT
Content-Type: text/html
Content-Length: 669
Last-Modified: Fri, 10 Jun 2022 02:15:09 GMT
Connection: keep-alive
ETag: "62a2a92d-29d"
Accept-Ranges: bytes
```

Load Testing w/HPA

DISCLAIMER: This creates a deployment running a CPU stress test with a horizontal pod autoscaler. Make sure you read the cpu-load-test.yaml manifest before deploying the resource

```
$ kubectl create -f https://raw.githubusercontent.com/abkierstein/sre-tools/main/examples/kubernetes/cpu-load-test.yaml

$ kubectl get pods -l app=sre-tools
NAME                                   READY   STATUS    RESTARTS   AGE
sre-tools-load-test-7f4fdfb9c7-fnlfj   1/1     Running   0          92s
sre-tools-load-test-7f4fdfb9c7-j4rlq   1/1     Running   0          2m32s
sre-tools-load-test-7f4fdfb9c7-mg4br   1/1     Running   0          32s

$ kubectl top pods -l app=sre-tools
NAME                                   CPU(cores)   MEMORY(bytes)   
sre-tools-load-test-7f4fdfb9c7-fnlfj   101m         1Mi             
sre-tools-load-test-7f4fdfb9c7-j4rlq   100m         2Mi             
sre-tools-load-test-7f4fdfb9c7-mg4br   100m         1Mi    
```
## Packages Installed
- inetutils-ping
- net-tools
- dnsutils
- curl
- ca-certificates
- stress
- tcpdump
- wget
- netcat
- vim
- nginx
- awscli
- software-properties-common
## Nginx
Nginx on this container is used to as a way to test availability of a pod through various ingresses & services
