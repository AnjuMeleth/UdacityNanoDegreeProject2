# UdacityNanoDegreeProject2 : Deploying higly available webapp using CloudFormation scripts
## Usage : 
To deploy the infrastructure use the helper script udacityinfra.sh as follows:

**./udacityinfra.sh**

## Description :
The script triggers the CloudFormation script to create two stacks "UdacityInfra" for generic infrastructure like VPC, subnet,etc and
"ServersUdacityInfra" for creating EC2 instances, load balancers etc.

## output
The DNSName of the load balancer is used to view the webapplication. The output URL would be viewed in the "output" tab
under the "ServersUdacityInfra" stack with the name "UdacityProject2-URL"
The screenshot of the output URL is shown in URL.jpg
