#!/usr/bin/ruby

require 'json'

USAGE="
USAGE: #{File.basename($0)} PRODUCT JOB USER [PROXY_JOB]

"

if ARGV.count < 4
  abort USAGE
end

file_name = ARGV[0]
product_name = ARGV[1]
job_name = ARGV[2]
user_name = ARGV[3]
proxy_name = ARGV[4]

@installation_settings = JSON.parse(File.read(file_name))

#products: Array with all products/tiles installed
#  jobs: Array with jobs of the current product
#    properties: Array with all credentials for the current job

def product(products, product_name)
  products.detect {|product| product["identifier"] == product_name}
end

def job(jobs,job_name)
  jobs.detect {|job| job["identifier"] == job_name}
end

def credentials(properties, user_name)
  property = properties.detect {|property| property["value"]["identity"] == user_name}
  return if !property
  property["value"]
end

def find_vm_credentials(product_name,job_name)
  the_product = product(@installation_settings["products"],product_name)
  return if !the_product
  jobs = the_product["jobs"]
  the_job = job(jobs,job_name)
  return if !the_job
  the_job["vm_credentials"]
end

def find_credentials(product_name,job_name,user_name)
  the_product = product(@installation_settings["products"],product_name)
  return if !the_product
  jobs = the_product["jobs"]
  the_job = job(jobs,job_name)
  return if !the_job
  properties = the_job["properties"]
  credentials(properties,user_name)
end

def ips(assignments)
  # keys is the array with the AZs
  the_ips = Array.new
  assignments.keys.each do |az|
    the_ips = the_ips+assignments[az]
  end
  the_ips
end

def find_ips(product_name,job_name)
  the_product = product(@installation_settings["products"],product_name)
  return if !the_product
  the_job = job(the_product["jobs"],job_name)
  return if !the_job
  ips(@installation_settings["ip_assignments"]["assignments"][the_product["guid"]][the_job["guid"]])
end

# if user is vcap, it means we want VM credentials
if user_name == "vcap"
  cred = find_vm_credentials(product_name,job_name)
else
  cred = find_credentials(product_name,job_name,user_name)
end
ips = find_ips(product_name, proxy_name || job_name)
abort("No credentials found for: #{product_name} #{job_name} #{user_name}") if !cred
abort("No IPs found for proxy: #{proxy_name}") if !ips
puts "#{cred["identity"]}|#{cred["password"]}|#{ips.join(",")}"
