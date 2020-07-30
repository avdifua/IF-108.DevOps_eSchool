## Deploying the app eSchool in google cloud.
Don't forget to open 8080 port in google cloud:
VPC network > Firewall

Google Cloud Platform Setup Prior to using this plugin, you will first need to make sure you have a Google Cloud Platform account, enable Google Compute Engine, and create a Service Account for API Access.

    1. Log in with your Google Account and go to Google Cloud Platform and click on the Try it free button.

    2. Create a new project and remember to record the Project ID

    3. Next, enable the Google Compute Engine API for your project in the API console. If prompted, review and agree to the terms of service.

    4. While still in the API Console, go to Credentials subsection, and click Create credentials -> Service account key. In the next dialog, create a new service account, select JSON key type and click Create.

    5. Download the JSON private key and save this file in a secure and reliable location. This key file will be used to authorize all API requests to Google Compute Engine.

    6. Still on the same page, click on Manage service accounts link to go to IAM console. Copy the Service account id value of the service account you just selected. (it should end with gserviceaccount.com) You will need this email address and the location of the private key file to properly configure this Vagrant plugin.

    7. Add the SSH key you're going to use to GCE Metadata in Compute -> Compute Engine -> Metadata section of the console, SSH Keys tab. (Read the SSH Support readme section for more information.)
    
What do you have to change in vagrant file. Example:
```bash
    google.google_project_id = "sofserv-if" - Project ID
    google.google_json_key_location = "/home/al/Vagrant/sofserv-if-123573ea618.json" - path to JSON

    override.ssh.username = "al" - name in linux system
    override.ssh.private_key_path = "~/.ssh/virtual_home" - path where stored keys
```
For running the creation of instances:
```bash      
    vagrant up --provider=google
```
If you want to change Region your instances. Look here - > VPC networks in Google cloud and choose correct IP address ranges

In the output, you have to get a working eSchool app which deployed in google cloud! Enjoy!
