#!/usr/bin/env ruby

# Look at group of URLs and see if the last job was successful
require 'rubygems'
require 'sinatra'
require 'erb'
require 'sinatra/reloader'
require 'json'
require 'yaml'
require 'haml'
require 'erubis'
require 'sinatra/simple_auth'
require 'rufus-scheduler'

require_relative 'lib/serializer'

enable :sessions
# sinatra settings
# set :bind, '0.0.0.0'
# set :port, 9000
set :username, ENV['CI_USER']
set :password, ENV['CI_PASS']
set :hello, '/' # user redirected here post auth

# scheduler = Rufus::Scheduler.new
# scheduler.cron '*/10 * * * *' do
versions = %w(.0 .1 .2)
versions.each do |version|
  puts "gathering deploy and review reports for version #{version}"
  my_create         = Serializer.new
  my_create.version = version
  my_create.create_record
  puts "deploy and review reports for version #{version} complete!"
end
# end

get '/favicon.ico' do
  puts 'chrome sends favicon. Silly Google.'
end
get '/' do
  session['user'] = nil
  if authorized? # helper method
    'Hello, %username%'
  else
    'Not authorized'
  end
  haml :hello
end
get '/login/?' do
  session['user'] ||= nil
  haml :login
end
get '/logout' do
  session['user'] = nil
  haml :logout
end
get '/joburls' do
  protected! # protected route, requires auth
  jobsfile  = File.open(File.dirname(__FILE__) + '/urls/jobs.yaml')
  yaml_hash = YAML.load_file(jobsfile)
  job_urls  = yaml_hash.to_yaml
  haml :joburls, locals: { job_urls: job_urls }
end
# Handle GET-request (Show the upload form)
get '/upload' do
  protected! # protected route, requires auth
  haml :upload
end
# Handle POST-request (Receive and save the uploaded file)
post '/upload' do
  protected! # protected route, requires auth
  File.open('urls/' + params['myfile'][:filename], 'w') do |f|
    f.write(params['myfile'][:tempfile].read)
  end
  return 'The file was successfully uploaded!'
end
# all in onen reporting
get '/all' do
  haml :all_in_one_reports, layout: false
end
# Core Application functionality
get '/:version' do
  # pull serialized deploy and review data
  result_deploy = \
    Marshal.load(File.read("public/result_deploy-#{params['version']}.bin"))
  result_review = \
    Marshal.load(File.read("public/result_review-#{params['version']}.bin"))
  @result_deploy_status   = {}
  @result_deploy_buildid  = {}
  @result_deploy_uri      = {}
  @result_deploy_ver      = {}
  result_deploy.each do |key, value|
    @result_deploy_status["#{key}"]   = value['status']
    @result_deploy_buildid["#{key}"]  = value['build_id']
    @result_deploy_uri["#{key}"]      = value['uri']
    @result_deploy_ver["#{key}"]      = value['ver']
  end

  @result_review_status   = {}
  @result_review_buildid  = {}
  @result_review_uri      = {}
  result_review.each do |key, value|
    @result_review_status["#{key}"]   = value['status']
    @result_review_buildid["#{key}"]  = value['build_id']
    @result_review_uri["#{key}"]      = value['uri']
  end
  # render with locals variables
  haml :report, layout: false, locals: {
    result_deploy_status:   @result_deploy_status,
    result_deploy_buildid:  @result_deploy_buildid,
    result_deploy_uri:      @result_deploy_uri,
    result_deploy_ver:  @result_deploy_ver,
    result_review_status:   @result_review_status,
    result_review_buildid:  @result_review_buildid,
    result_review_uri:      @result_review_uri,
    version:                params['version'] 
  }
end
