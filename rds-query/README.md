## Create a serveless funtion using AWS lambda function

Configure the lambda function inside VPC as DB is generally present in a private subnet.

Attach an IAM role with policy the will allow lambda to execute.
`AWSLambdaVPCAccessExecutionRole` is the AWS managed ploicy that is required for this role.

From cloud 9 console added a layer with psycopg2 in python folder.
```
python3.8 -m pip install psycopg2 -t python/ (for pip install psycopg2-binary -t .)
```
outside python folder:
```
sudo yum install python-psycopg2
```
Zip just the `.py` file not psycopg binaries.
