#!/bin/bash

# command
# yum install s3cmd -y
# s3cmd --version
# radosgw-admin user info --uid=admin
# s3cmd --configure


# example
# [root@bigdata-1 ceph]# s3cmd --configure

# Enter new values or accept defaults in brackets with Enter.
# Refer to user manual for detailed description of all options.

# Access key and Secret key are your identifiers for Amazon S3. Leave them empty for using the env variables.
# Access Key: BDRPFT6TC0K9H6Z9Y0H4
# Secret Key: 8zIdg5iOdRA8R4GjXnsVzvpQ3jIkJM2oCPs6VkeL
# Default Region [US]: 

# Use "s3.amazonaws.com" for S3 Endpoint and not modify it to the target Amazon S3.
# S3 Endpoint [s3.amazonaws.com]: bigdata-1:8899

# Use "%(bucket)s.s3.amazonaws.com" to the target Amazon S3. "%(bucket)s" and "%(location)s" vars can be used
# if the target S3 system supports dns based buckets.
# DNS-style bucket+hostname:port template for accessing a bucket [%(bucket)s.s3.amazonaws.com]: bigdata-1:8899

# Encryption password is used to protect your files from reading
# by unauthorized persons while in transfer to S3
# Encryption password: 
# Path to GPG program [/usr/bin/gpg]: 

# When using secure HTTPS protocol all communication with Amazon S3
# servers is protected from 3rd party eavesdropping. This method is
# slower than plain HTTP, and can only be proxied with Python 2.7 or newer
# Use HTTPS protocol [Yes]: False        

# On some networks all internet access must go through a HTTP proxy.
# Try setting it here if you can't connect to S3 directly
# HTTP Proxy server name: 

# New settings:
#   Access Key: BDRPFT6TC0K9H6Z9Y0H4
#   Secret Key: 8zIdg5iOdRA8R4GjXnsVzvpQ3jIkJM2oCPs6VkeL
#   Default Region: US
#   S3 Endpoint: bigdata-1:8899
#   DNS-style bucket+hostname:port template for accessing a bucket: bigdata-1:8899
#   Encryption password: 
#   Path to GPG program: /usr/bin/gpg
#   Use HTTPS protocol: False
#   HTTP Proxy server name: 
#   HTTP Proxy server port: 0

# Test access with supplied credentials? [Y/n] y
# Please wait, attempting to list all buckets...
# Success. Your access key and secret key worked fine :-)

# Now verifying that encryption works...
# Not configured. Never mind.

# Save settings? [y/N] y
# Configuration saved to '/root/.s3cfg'


s3cmd mb s3://ntc-oss-large-file-html
s3cmd mb s3://ntc-oss-large-file-eml
s3cmd mb s3://ntc-oss-large-file-bda
s3cmd mb s3://ntc-oss-large-file
