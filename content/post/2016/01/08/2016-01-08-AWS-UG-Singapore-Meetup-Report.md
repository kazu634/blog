+++
categories = [ "AWS" ]
author = "kazu634"
description = "6th Jan 2016に行われたAWS User Group Singaporeのレポートです。ただし英語。。。"
tags = [ "Singapore" ]
date = "2016-01-08T22:23:32+08:00"
title = "AWS UG Singapore Meetup Report (6th Jan 2016)"

+++

AWS UG Singapore Meetup Report (6th Jan 2016)のメモです。For the event details, see: [AWSUG January Meet Up - AWS User Group Singapore (Singapore) - Meetup](http://www.meetup.com/AWS-SG/events/226964694/).

## Architecture Highlight: serv.sg
Presentation agenda:

> Nicolas Mas: CTO, [SERV - Retail Services Simplified](http://serv.sg/#!home)
>
> How serv.sg deliver features using AWS infrastructure: programatically building and provisioning a stack before destroying it. This talk will explain what they do, why they do it and the tools they use (packer.io, terraform.io, ansible etc.). Includes a live demo of the whole cycle.

### Problem to solve
When the developers is coding new features, they need the testing envrionment. But to get the testing environment they need to ask the operation / infrastructure guys. It takes time for the operation / infrastructure guys to create a testing environment for the developers.

### Solution
Use the following tools / Web Services to fully automate the testing environment building process on AWS. This builing process takes only 10 mins or so to finish:

- [Packer by HashiCorp](https://www.packer.io/)
- [GitHub](https://github.com/)
- [Slack: Be less busy](https://slack.com/)
- [Jenkins](https://jenkins-ci.org/)
- [Ansible is Simple IT Automation](http://www.ansible.com/)
- [Terraform by HashiCorp](https://terraform.io/)

### keywords for further reserarch

- DevOps
- ChatOps
- Infrastructure as a Code

## Supervising Services from Scripts
Presentation agenda:

> Chris Forno
>
> Did you know that you can use the AWS API via JavaScript in a web application? Why would you want to do so? We'll work through a couple examples of applications you can build that interact with AWS from the browser and explain how they can be useful. We'll also see how to build these apps securely (without exposing your credentials).

### Problems to solve
When engineers do 24/7 support, it is quite difficult to SSH the servers, using mobile phones.

### Solution
Use the following tools / Web Services to create a hand-made Web console to access to the servers:

- [AWS SDK for JavaScript](https://aws.amazon.com/sdk-for-browser/)
- [AWS Lambda](https://aws.amazon.com/lambda/)
- [Web Cryptography API](http://www.w3.org/TR/WebCryptoAPI/)
- EC2 User Data
- Web Server

### keywords for further reserarch

- DevOps
- PagerDuty
- Let's Encrypt


##  Improving CloudFront for Better Video Delivery
Presentation agenda:

> Daniel Muller:System Administrator, [Spuul](https://spuul.com/)
>
> Cloudfront's pitfalls and missing features: building tools around Cloudfront to boost content delivery

### Problems to solve
On some special conditions, Cloudfront cannot cache the files.

### Solution
Create the `Nginx` cache servers on each region to control the cache behaviour and avoid the Cloudfront's pitfalls.

### keywords for further reserarch

- [Amazon CloudFront CDN](https://aws.amazon.com/cloudfront/)
- [Amazon Route 53](https://aws.amazon.com/route53/)
- [nginx](http://nginx.org/en/)
