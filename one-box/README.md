# Deployment steps.
Actually we have two ways to deploy the cf-lite environment:

# Deploy the cf-lite environment using azure vms.




# Deploy the cf-lite environment using local bosh.

## Step 1: prepare one dev box (maybe you already have that)
### Install one Ubuntu machine.
### Install Virtual Box 5.1+

__DO NOT__ simply use `apt-get install virtualbox` directly. In this way `VirtualBox 5.0` will be installed, which has a buggy implement for NAT network and will make your bosh director unable to access network.

```
# add the official repository
wget -q -O - https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add -
echo deb http://download.virtualbox.org/virtualbox/debian `lsb_release -cs` non-free contrib | sudo tee /etc/apt/sources.list.d/virtualbox.org.list

# install the newer version of virtualbox
sudo apt-get update
sudo apt-get install virtualbox-5.1
```


##### MacOS:

#### Step 2: deploy bosh-lite