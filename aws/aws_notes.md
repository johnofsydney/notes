# AWS Notes

- Signup for an AWS account. At work, use jumpcloud and work credentials. At home use home credentials of course.

## Getting set up 

- at work review the confluence page. Otherwise;

- `brew install awscli`
- sign in to AWS console - https://ap-southeast-2.console.aws.amazon.com
- choose Sydney region
- login is different for home use vs 2FA @ work



## Ruby AWS Lambda tutorial

Start here:
https://serverless.com/blog/api-ruby-serverless-framework/

at work it is necessary to set a run-time env variable for AWS_PROFILE
e.g. `AWS_PROFILE=testing serverless deploy`

## Local
```
$ saml2aws login
$ AWS_PROFILE=testing npx sls invoke local -f makeFileAndWriteToS3 --stage testing
```

queues in aws

Reading from queue
https://serverless.com/framework/docs/providers/aws/events/sqs/
https://serverless.com/blog/aws-lambda-sqs-serverless-integration/


triggering an event when s3 receives an item
https://serverless.com/framework/docs/providers/aws/events/s3/


sending a message to a queue
https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/sqs-example-send-messages.html


## Serverless.yml
_from Jim at work..._
Serverless article on variables
https://serverless.com/framework/docs/providers/aws/guide/variables/
 
This article explains a simple way to work with stage variables.
https://serverless-stack.com/chapters/serverless-environment-variables.html
 
I have also used this in the past. Be mindful that this method uses a plugin and from memory, you can only use standard naming for stages (I think)
https://www.jeremydaly.com/how-to-manage-serverless-environment-variables-per-stage/
 
Both methods work. Ultimately we would like to see that each deployment of a stack is self-contained. The resources that we reference would not need to be hard-coded into any of the function handlers which would allow for resources changes to be made in config which in turn would make the code more portable.

# Notes for the AWS Certified Developer Course

## IAM - Identity Access Management
IAM roles, policies etc govern the permissions that allow / restrict interaction of users to resources, and resources to other resources. IAM information is held globally rarther than in a region.

- Users
  - _root_ user is the one whos identity is linked to the credit card at sign up. This account has full access
  - other user accounts can be defined as either or both of
    - _human users_ who can logon via the console with a username and password and access resources.
    - _programmatic users_ have a user key and user secret key combination to login and access resources either through code or CLI
- Groups
  -  groupings of eg users with same securirty / access requirements
- Roles
  - 
- Policies
  - a JSON document describing a collection of individual permissions.