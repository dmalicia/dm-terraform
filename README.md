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
https://github.com/dmalicia/dm-nodejs

# Creating the service 
For testing purpose I will apply a small point of presence with 2 autoscales with maximum 3 nodes in different regions to demonstrate the service working,
the pull request for it is this one :
https://github.com/dmalicia/dm-terraform/pull/44

In the seed server where the puppet master is running you can see the nodes bootstrapped :
```
# puppet cert list --all
+ "backend-asg-amer-us-west40-94k2.us-west4-b.c.heroic-muse-289316.internal"          (SHA256) 
+ "backend-asg-amer-us-west40-jzmb.us-west4-b.c.heroic-muse-289316.internal"          (SHA256) 
+ "backend-asg-euro-europe-west60-2pvn.europe-west6-a.c.heroic-muse-289316.internal"  (SHA256) 
+ "backend-asg-euro-europe-west60-jph6.europe-west6-a.c.heroic-muse-289316.internal"  (SHA256) 
+ "cassandra-amer-0.us-east1-b.c.heroic-muse-289316.internal"                         (SHA256) 
+ "cassandra-euro-0.europe-west4-a.c.heroic-muse-289316.internal"                     (SHA256) 
+ "dmlc-seed-6e291ed314bc831a.us-west1-a.c.heroic-muse-289316.internal"               (SHA256) 18:59:D3:4B:44:C3:AD:9E:92:1E:9A:CA:B4:06:B9:BF:08:C6:72:76:7B:82:3E:5F:F8:1A:AE:63:2C:BC:48:8A (alt names: "DNS:dmlc-seed-6e291ed314bc831a.us-west1-a.c.heroic-muse-289316.internal", "DNS:puppet")
+ "frontend-asg-amer-us-west40-fgcg.us-west4-b.c.heroic-muse-289316.internal"         (SHA256) 
+ "frontend-asg-amer-us-west40-q6c6.us-west4-b.c.heroic-muse-289316.internal"         (SHA256) 
+ "frontend-asg-amer-us-west40-zm1p.us-west4-b.c.heroic-muse-289316.internal"         (SHA256) 
+ "frontend-asg-euro-europe-west60-m2g8.europe-west6-a.c.heroic-muse-289316.internal" (SHA256) 
+ "frontend-asg-euro-europe-west60-ppjr.europe-west6-a.c.heroic-muse-289316.internal" (SHA256) 
+ "frontend-asg-euro-europe-west60-tk29.europe-west6-a.c.heroic-muse-289316.internal" (SHA256) `
```
After this the nodes will be running what was designated in their puppet manifest.


# Hybrid clouds 

To create a stack









