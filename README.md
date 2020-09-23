# dm-terraform

dm-terraform is a boilerplate made in terraform to spawn a high availability webserver in hybrid clouds
 
the stack is composed by :
>- Terraform,Atlantis,Puppet,Git,NodeJS,Grafana,Puppet,Prometheus , Docker , Cassandra 

to be implemented: 
>- Consul, Packer

# supported clouds :
  >- GCP - implemented
  >- AWS - implementing
  >- Digital Ocean, Vsphere , Openstack or any other terraform has the providers.  - to be implemented
  

# suggested initial architecture GCP
![Image of GCP](https://github.com/dmalicia/dm-terraform/blob/master/docs/dmlc.svg)

https://dmlc.pw is the domain of our service using google load balancer with CDN serving the content, autoscales running the docker application.
The external load balancer offloads the SSL and route the client to the nearest autoscale frontend vip.
The regions can have multiple autoscale in multiple zones to improve the high availability.
Here is an example of a pull request that can recreate this arch using the atlantis automation with github webhook:
https://github.com/dmalicia/dm-terraform/pull/42

In this pull request it would be firing :

 > 4 autoscaling for frontend with max 3 nodes each in 4 differente zones
 
 > 4 autoscaling for backend with max 3 nodes each in 4 differente zones
 
 > 3 cassandra instances for the cluster

The instances will be bootstrapped to puppet that will run these manifests here :
https://github.com/dmalicia/dm-puppet

The webserver application is docker container running nodejs from this simple app here :
https://github.com/dmalicia/dm-nodejs

# starting a small cluster for testing
for testing purpose I will apply a small point of presence with 2 autoscales limited to 2 in different regions to demonstrate the service working,
the pull request for it is this one :
https://github.com/dmalicia/dm-terraform/pull/44

After "atlantis apply" the nodes will be booted and they wiil reach puppet for the bootstrap : 
```
# puppet cert list --all
+ "backend-asg-amer-us-west40-94k2.us-west4-b.c.heroic-muse-289316.internal"          (SHA256) 
+ "backend-asg-amer-us-west40-jzmb.us-west4-b.c.heroic-muse-289316.internal"          (SHA256) 
+ "backend-asg-euro-europe-west60-2pvn.europe-west6-a.c.heroic-muse-289316.internal"  (SHA256) 
+ "backend-asg-euro-europe-west60-jph6.europe-west6-a.c.heroic-muse-289316.internal"  (SHA256) 
+ "cassandra-amer-0.us-east1-b.c.heroic-muse-289316.internal"                         (SHA256) 
+ "cassandra-euro-0.europe-west4-a.c.heroic-muse-289316.internal"                     (SHA256) 
+ "dmlc-seed-6e291ed314bc831a.us-west1-a.c.heroic-muse-289316.internal"               (SHA256) 
+ "frontend-asg-amer-us-west40-fgcg.us-west4-b.c.heroic-muse-289316.internal"         (SHA256) 
+ "frontend-asg-amer-us-west40-q6c6.us-west4-b.c.heroic-muse-289316.internal"         (SHA256) 
+ "frontend-asg-amer-us-west40-zm1p.us-west4-b.c.heroic-muse-289316.internal"         (SHA256) 
+ "frontend-asg-euro-europe-west60-m2g8.europe-west6-a.c.heroic-muse-289316.internal" (SHA256) 
+ "frontend-asg-euro-europe-west60-ppjr.europe-west6-a.c.heroic-muse-289316.internal" (SHA256) 
+ "frontend-asg-euro-europe-west60-tk29.europe-west6-a.c.heroic-muse-289316.internal" (SHA256) `
```
After this the nodes will be running what was designated in their puppet manifest. In this case for frontend a nodejs app in docker.

https://dmlc.pw -> 34.129.231.79:443 is the load balancer that deals with the ssl and offloads it in port 80 to the autoscales.

I enabled CDN on the load balancer so the request should be redirected for the nearest google edge location.


# URLs/ Endpoints of the Project :

>- Main URL served by google CDN : https://dmlc.pw
>- Prometheus : http://monitoring.dmlc.pw:9090/graph ( admin / yes123 )  ( node exporters to be implemented )
>- Alert Manager : http://monitoring.dmlc.pw:9093/#/alerts ( admin / yes123 )
>- Atlantis : http://seed.dmlc.pw:4141/
>- Graphana : http://monitoring.dmlc.pw:3000/?orgId=1 ( admin / diego ) (no data yet)


# Expand to other clouds or vmware ( under construction )
To enable other clouds or vsphere we can create a folder in the service with the provider configuration, auths, network info , image and other attributes:

```├── frontend
│   ├── aws_nodes
│   ├── gcp_autoscale
│   ├── gcp_nodes
│   └── openstack_autoscale
```
After the provider is authenticated and configured you will create the tfstate in the gcp backend bucket and add an entry like this in atlantis :

```  - name: frontend_euro_aws_autoscale
    dir: frontend/aws_autoscale
    autoplan:
      when_modified: ["../frontend/aws_autoscale/*.terraform", "../frontend/bootstrap/*", "*.tf", "*.tfvars"]
    workspace: euro
``` 
After this when you have the VIP you can add an external endpoint in Google Cloud External Load Balancer IP.


# Todo
- Create golden image for bootstrap with Packer
- Improve firewall and recipes rules in Puppet
- Finish grafana / prometheus setup
- Automate DNS removal when Autoscale scale down
- Setup Cassandra Rings
- Add AWS Autoscaling


# References
https://github.com/Einsteinish/Docker-Compose-Prometheus-and-Grafana
https://forge.puppet.com/garethr/docker







