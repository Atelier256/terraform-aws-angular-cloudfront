# terraform-module-angular-cloudfront

This module is provided under MIT License by [Atelier256](https://a256.eu).

[Atelier256](https://a256.eu) is an IT Company based in France which already accomplished with success many end customers projects within France and Belgium. 
 
![A256 Terraform Logo](https://cdn.a256.eu/logos/A256_terraform.png)

## What is this module for ?

This module is a module widely used by [Atelier256](https://a256.eu) within our projects.

This module perform the following:

* Create a S3 bucket for histing the content you want to upload
    * The Bucket is secured with (see policies/bucket-policy.json):
        * Server Side Encryption (AES256)
        * Block every public access
        * Block any unencrypted request
* Create a CloudFront Distribution with the S3 Bucket as Origin
    * Create an access identity and allow accessing to the S3 bucket only by passing over the CloudFront Distribution  
* (Optional) Create IAM access key fo deploying to the S3 Bucket and create CloudFront Distribution using aws cll or SDK for example 


## How to use the module ?

