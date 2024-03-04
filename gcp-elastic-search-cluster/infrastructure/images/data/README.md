
# Resources

Contains the tools used to build various resources outside of the normal infrastructure sequencing.  This includes the Custom Image creation process.

## Custom Images

A objective for this project is to create a set of Google Cloud compute instances that form an Elastic search cluster. With cost-optimization a key requirement, this cluster will use a Managed Instance Group containing Spot VMs to take advantage of the significant discounts available for this type of machine.

Custom images are required for the Managed Instance Group base image and for this project we will need to use the a base image for the following types of VM:
- Elastic search data nodes 
    - images will contain the shared base configuration
    - Images will support the use of Managed Instance groups of Spot VMs


## Creation Process
Custom images are created from a base virtual machine configured in preparation for their roles.

Base image creation will be configured and managed from within the 'resources > images > data' folder.


## Networking Prerequisites

A Custom-mode VPC network is required prior to building with a single subnet in the target region.  In addition a Firewall Rule need to be configured to allow internal instances to connect with one another via the ssh protocol within the confines of the subnet, whilst instances with an external IP address should be given the network tag "search-access-node" and a second Firewall Rule allowing external access to the ssh protocol. The networking prerequisite infrastructure will be configured and managed within the 'resources > modules > vpc' folder. 



## Installed Software

The data node image will have the following software installed:
- node_exporter
- curl
- unzip
- jq
- wget
- 