
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

## EC2
_Elastic Cloud Compute_ : Virtual Servers / Instances of Virtual Servers

- Can be scaled up or down as demand dictates
- Different families for different compute needs

#### Pricing Options (4)
- On Demand
  - Least commitment
  - Pay by hour or second
  - No up front payment required
  - good for unpredictable / spiky workloads
  - good for testnig (this is what's used in the course)
- Reserved
  - Enter into a 1 year / 3 year contract for resource
  - Pay up front for significant discount
  - _Convertible_ Reserved Instances can be _converted_ from one family to another (if trading up to more expensive)
  - You can _reserve_ a short time window (...?)
- Spot
  - Your instance is only available when the spot price is at or below the value you set.
  - You control the price, not the timew of availability
  - for applications that are only possible at low compute pricing (e.g. genomics - massive data)
  - good for asynchronous tasks
  - If the service is terminated by AWS (becuase the spot price goes above your max bid) then you don't have to pay for the unused portion of time
  - If the service is terminated by you, you do have to pay for any unused time.
- Dedicated
  - Your own server in AWS data centre. Your own hardware. _Not_ a Virtual Server
  - suits regulatory environment which doesn't allow multi-tenancy on hardware
  - suits porting of licensed software that does not permit cloud / virtual server deployment
  - can be on-demand or reserved.

  ### Instance Families
  Different types are optimized for such things as 
  - Storage
  - CPU
  - GPU
  - Disk Throughput
  - Memory

  _F.I.G.H.T.D.R.M.A.C.P.X._

  We will use T2 for the course. (The numeral signifies the generation). This is Low Cost General Purpose server


### EBS
_Elastic Block Storage_ : Virtual Disk

- Create an EBS volume and attach it to an EC2 instance
- Create a filesystem and mount it to the volume
- Is placed in a specific availability zone and replicated by AWS
  - GP2 : General Purpose SSD **bootable**
  - IO1 : Provisioned IOPS SSD _for > 10k IOPS_ **bootable**
  - ST1 : Throughput Optimized HDD. **not bootable**
  - SC1 : Cold Storage HDD. **not bootable**
  - Magnetic Standard : Legacy. Lowest Cost. **not bootable**


#### Create and start a web server 
To create / provision an EC2 instance (as per lab)
- Choose EC2 from the console
- Launch Instance
- Choose an AMI _(Amazon Machine Image)_ - various flavours of Linux of Windows servers
- Choose the family _(F.I.G.H.T.D.R.M.A.C.P.X.)_
- Set some options
- Add storage. Must be bootable.
- Generate, download and `chmod 400` a key pair
- allow access to
  - `port 22` for SSH
  - `port 80` for HTTP
- port 80 access typically allowed from anywhere, port 22 could be restricted by IP or similar

```
ssh ec2-user@3.90.69.193
sudo su # do following commands as root
yum update -y
yum install httpd -y # appache
service httpd start
chkconfig httpd on
service httpd status
```


### Load Balancers
_A load balancer is a device that distributes network or application traffic across a cluster of servers. ... A load balancer sits between the client and the server farm accepting incoming network and application traffic and distributing the traffic across multiple backend servers using various methods._

There are three kinds of Load Balancers
- Application Load Balancer
  - works on the HTTP/HTTPS protocol
  - Layer 7
  - sends specific requests to specific servers
- Network Load Balancers
  - Works on the TCP protocol
  - layer 4
  - Fast. Can handle millions of requests per second
  - Expensive
- Classic
  - more of a legacy thing
  - layer 4 or layer 7
  - a 504 error _Gateway Timeout Error_ means there's an error at the web server or the database and that the gateway has timed out during the idle timeout period

**NB** As the Load Balancer will act to mask the address of the original request, if you need the original callers IP address, look in the headers for _X-Forwaded-For_
