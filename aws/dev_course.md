
# Notes for the AWS Certified Developer Course

## IAM - Identity Access Management
IAM roles, policies etc govern the permissions that allow / restrict interaction of users to resources, and resources to other resources. IAM information is held globally rarther than in a region.

- Users
  - _root_ user is the one whos identity is linked to the credit card at sign up. This account has full access
  - other user accounts can be defined as either or both of
    - _human users_ who can logon via the console with a username and password and access resources.
    - _programmatic users_ have a user key and user secret key combination to login and access resources either through code or CLI
    - New users have no permissions at all when they are first created
- Groups
  -  groupings of eg users with same securirty / access requirements. E.G. HR, Sales, Database Users. Suits human and programmatic users.
- Roles
  - safely delegate access / permissions to resources to other AWS entities, such as users, EC2 instances, lambdas etc.
- Policies
  - a JSON document describing a collection of individual permissions.
  - Policies (and maybe individual opermissions) can be applied to groups or directly to particular users.

### _What are IAM roles?_

_IAM roles are a secure way to grant permissions to entities that you trust. Examples of entities include the following:_

- IAM user in another account
- Application code running on an EC2 instance that needs to perform actions on AWS resources
- An AWS service that needs to act on resources in your account to provide its features
- Users from a corporate directory who use identity federation with SAML
IAM roles issue keys that are valid for short durations, making them a more secure way to grant access.

#### _Q: What is the difference between an IAM role and an IAM user?_
An IAM user has permanent long-term credentials and is used to directly interact with AWS services. An IAM role does not have any credentials and cannot make direct requests to AWS services. IAM roles are meant to be assumed by authorized entities, such as IAM users, applications, or an AWS service such as EC2.

#### _Q: When should I use an IAM user, IAM group, or IAM role?_
An IAM user has permanent long-term credentials and is used to directly interact with AWS services. An IAM group is primarily a management convenience to manage the same set of permissions for a set of IAM users. An IAM role is an AWS Identity and Access Management (IAM) entity with permissions to make AWS service requests. IAM roles cannot make direct requests to AWS services; they are meant to be assumed by authorized entities, such as IAM users, applications, or AWS services such as EC2. Use IAM roles to delegate access within or between AWS accounts.