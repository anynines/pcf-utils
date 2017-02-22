#!/usr/bin/ruby
require 'json'

USAGE="
USAGE: #{File.basename($0)} /path/to/installation.yml COMMAND PARAMETERS

#{File.basename($0)} /path/to/installation.yml credentials PRODUCT JOB USER [PROXY_JOB]
#{File.basename($0)} /path/to/installation.yml properties PRODUCT JOB PROPERTY

Command Aliase:
  credentials, c
  properties, p

"

file_name = ARGV[0]
@installation_settings = JSON.parse(File.read(file_name))

#products: Array with all products/tiles installed
#  jobs: Array with jobs of the current product
#    properties: Array with all credentials for the current job
def extract(hash, key, value)
  abort "ERROR: is not a hash: '#{hash}'" if hash.class != Array
  hash.detect {|e| e[key] == value}
end

def job_credentials(properties, user_name)
  property = properties.detect {|property| property['value']['identity'] == user_name}
  return if !property
  property['value']
end

def find_vm_credentials(product_name,job_name)
  the_product = extract(@installation_settings['products'],'identifier',product_name)
  return if !the_product
  jobs = the_product['jobs']
  the_job = extract(jobs,'identifier',job_name)
  return if !the_job
  the_job['vm_credentials']
end

def find_job_credentials(product_name,job_name,user_name)
  the_product = extract(@installation_settings['products'],'identifier',product_name)
  return if !the_product
  jobs = the_product['jobs']
  the_job = extract(jobs,'identifier',job_name)
  return if !the_job
  properties = the_job['properties']
  job_credentials(properties,user_name)
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
  the_product = extract(@installation_settings['products'],'identifier',product_name)
  return if !the_product
  the_job = extract(the_product['jobs'],'identifier',job_name)
  return if !the_job
  ips(@installation_settings['ip_assignments']['assignments'][the_product['guid']][the_job['guid']])
end

def find_property(product_name, job_name, prop_name)
  the_product = extract(@installation_settings['products'],'identifier',product_name)
  abort "Product not found: #{product_name}" if !the_product || !the_product['jobs']
  the_job = extract(the_product['jobs'],'identifier',job_name)
  extract(the_job['properties'],'identifier',prop_name)['value']
end

cmd = ARGV[1]
case cmd
when 'credentials', 'c' then
  abort USAGE if ARGV.count < 4

  product_name = ARGV[2]
  job_name = ARGV[3]
  user_name = ARGV[4]
  proxy_name = ARGV[5]

  # if user is vcap, it means we want VM credentials
  if user_name == 'vcap'
    cred = find_vm_credentials(product_name,job_name)
  else
    cred = find_job_credentials(product_name,job_name,user_name)
  end
  ips = find_ips(product_name, proxy_name || job_name)
  abort("No credentials found for: #{product_name} #{job_name} #{user_name}") if !cred
  abort("No IPs found for proxy: #{proxy_name}") if !ips
  puts "#{cred['identity']}|#{cred['password']}|#{ips.join(',')}"
when 'properties', 'p' then
  product_name = ARGV[2]
  job_name = ARGV[3]
  prop_name = ARGV[4]
  abort USAGE if !prop_name
  puts find_property(product_name, job_name, prop_name)
else
  puts ARGV
  abort USAGE
end
