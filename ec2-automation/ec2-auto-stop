# This is based on the region of the ec2 instances
import boto3
region = 'ca-central-1'
def lambda_handler(event, context):
    
    ec2 = boto3.resource("ec2", region_name=region)

    ec2_tag = [{"Name": "tag:lambda", "Values": ["in-hours"]}]
    ec2_state = [{"Name": "instance-state-name", "Values": ["running"]}]
    
    ec2.instances.filter(Filters=ec2_tag).stop()
