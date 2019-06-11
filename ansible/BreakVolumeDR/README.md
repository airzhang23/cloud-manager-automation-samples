## How To Use Ansible PlayBook for breaking Volume at DR environment ##

# General
	* There are 3 playbook (YML) that will be use for breaking volume in DR environment:
	 - main.yml
	 Main Playbook that need will be execute via ansible 
	 - parms.yml
	 Parameters file that should be fill by the End User and will be use by main Playbook 
	 - checkvol.yml 
	 inside Playbook that update the lateset data from source volume 

# Steps for executing 

1.	Playbook paramters that need to be edit.
	* parms.yml contain 5 paramters that needed to be change according to your working environment 
	  - refToken: Go to https://services.cloud.netapp.com/refresh-token
		Generate refresh token for CloudManager ( You need to have a Cloud Central Account )
	  - occm_ip: IP of the OCCM 
	  - weName: Working Enviorment that contain destination volume (DR) 
	  - occmEnv: Cloud Service (aws/azure/gcp) 
	  - destVolName: Name of the volume that need to be break 

2.  Copy all 3 Playbook file to your Ansible server to the same location e.g:/var/tmp/

3.	Submit main playbook 
	$ansible-playbook main.yml

4. validate that Playbook ended successfully and print out the status of the Volume 
	e.g:
		ok: [localhost] => { 
		"msg": " The Volume vol1a_copy svm_cvo2td , MirrorState is --> broken-off"}




