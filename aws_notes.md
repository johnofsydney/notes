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