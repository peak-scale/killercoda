The first thing we now need to do is to think about what we want to achieve and how we can abstract this into a configuration.

# Vision

We have a dedicated S3 Instance in the Cluster. We would like to provide our consumers the possibility to request buckets in this S3 Instance. The consumers should be able to request a bucket by providing a name and a quota into a YAML file.

## Making a concept

Think about what abstractions we can make:

  * `Bucket`: Is the highest logical abstraction in our scenario. It does not translate to a resource, however should hold relevant information:
  
    * `Metdata`:
      * `Serviceaccounts`: Define ServiceAccounts having access to this bucket
      * `Quota`: Storeage Quota for the bucket
  
    * `Policy`: To grant access to the bucket we need Policies which will be mapped to the ServiceAccounts

## Thinking in modules

We should think about where we can make modules and reuse code. 

  * `Bucket`: We can create a module for the bucket, which will create all the necessary resources for a bucket. This module should be reusable.

  * `ServiceAccounts`: We can create a module for the Serviceaccount. A Serviceaccount might have access to multiple Buckets therefor we are creating a dedicated module for this.


## User-facing API/Data

I always like to start with the data structure, which the users I am building the solution for are consuming. You probably can't make the perfect abstraction from the start. Therefor keep in mind that it's always good to iterate on the abstraction. 

Based on the above concept we have made above I would envision a following yaml structure:

**buckets.yaml**
```yaml
serviceaccounts:
  - name: "account-name"
buckets:
- name: "bucket-name"
  quota: "10GB"
  serviceaccounts:
    - name: "account-name"
      policy: "readonly/full"
```

## Verify Provider Capabilities

Before getting your hands dirty, let's look if there's providers which can achieve what we need. In our case we mainly need to take a look at the [MinIO Terraform Provider](https://registry.terraform.io/providers/aminueza/minio/latest/docs).

  * To Create a bucket we need to use the `[minio_s3_bucket](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/s3_bucket)` resource.
  * To create policies we need to use the `[minio_iam_policy](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/s3_bucket_policy)` resource.
  * To create ServiceAccounts we need to use the `[minio_iam_user](https://registry.terraform.io/providers/aminueza/minio/latest/docs/resources/iam_user)` resource.


## Analyse the environment

We have two minio instances for two stages `test` and `prod`. We want to align the configuration for both stages exactly the same. To access the MinIO instances:

  * `test`: This is the instance where we want to create the buckets
  * `minio2`: This is the instance where we want to create the ServiceAccounts




