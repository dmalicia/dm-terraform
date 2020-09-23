# dm-terraform

dm-terraform is a boilerplate made in terraform to spawn a high availability webserver in hybrid clouds
 
the stack is composed by :
>- Terraform
>- Atlantis
>- Puppet
>- Gi
>- NodeJS
>- Grafana
>- Prometheus
>- Docker
>- Cassandra
>- Consul ( to be implemented )
>- Packer ( to be implemented )

# supported clouds :
  >- GCP - implemented
  >- AWS - implementing
  >- Digital Ocean, Vsphere , Openstack or any other terraform has the providers.  - to be implemented
  

# Suggested architecture GCP
![Image of GCP](https://github.com/dmalicia/dm-terraform/blob/master/docs/dmlc.svg)

https://dmlc.pw is the domain of the main vip using google load balancer with CDN.
The external load balancer offloads the SSL and route the client to the nearest autoscale frontend vip
The regions can have multiple autoscale in multiple zones to improve the high availability.
Here is an example of a pull request that can recreate this arch using the atlantis automation with github webhook:
https://github.com/dmalicia/dm-terraform/pull/42

In this pull request it will be firing :

 > 4 autoscaling for frontend with max 3 nodes each in 4 differente zones
 
 > 4 autoscaling for backend with max 3 nodes each in 4 differente zones
 
 > 3 cassandra instances for the cluster

The instances will be bootstrapped to puppet that will run these manifests here :
https://github.com/dmalicia/dm-puppet

The webserver application is docker container running nodejs from this simple app here :

