# AWS Services (that I use, there are thousands more). 

### Lambda: This is a serverless function.
- It can be triggered by several things, including: Time (cron job) an item landing in an S3 bucket, a message appearing on an SQS queue,  a request being received by an API Gateway
- A lambda might fetch and save records to / from a database, but it doesn't have to.
- It's incoming argument is known as an event - we use ruby, so for us this is a hash, but if using JavaScript this would be an object.
- The return value from a lambda might be returned to: An API gateway as a response, an SQS queue as a message, or might be the input argument to another lambda (if they are arranged together as a Step Function)
- A lambda can send emails and alerts - ie it can do things internally as well as return a value.
- A lambda can fetch / move / delete things from S3 buckets. If they've been fetched into memory it can also process them and for instance perform database actions based on that. (edited) 


### S3 Bucket: This is storage, S3 == Simple Storage Service
- Users, or other services such as Lambdas can save to / retrieve from S3 buckets. Mostly it will be other services. Not just microservices like Lambdas, but a rails project can read / write to S3 as well.
- A serverless project in a container does not have a file system for storage, ie no ~/Users/john/foo so if you have files you need to import & process (common thing at my work) they need to go into S3.
- An item landing in (or being deleted / moved from) an S3 bucket can be a trigger to invoke a Lambda


### SQS: Simple Queue Service
- Other Services such as Lambdas (maybe other things too?) can drop messages into a queue
- A message appearing in a queue can be a trigger for a lambda to be invoked, with that message as part of the event argument.
- We use SQS when we are communicating with a service that we don't want to overwhelm, like an API with a throughput of 2 transactions per second, or just our own database when dealing with many thousands of records. We can draw messages from the queue at a rate we specify, thus throttling our calls to database or external API