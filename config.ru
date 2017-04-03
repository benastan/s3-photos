#!/usr/bin/env ruby

require "bundler/setup"
require "thin"
require "s3/photos"
require 'dragonfly'

Dragonfly.app.configure do
  plugin :imagemagick
  secret ENV['APP_SECRET']
  url_format '/media/:job'
  
  if ENV['STORAGE'] == 'filesystem'
    datastore :file,
      root_path: ENV['DIRECTORY']

    fetch_file_whitelist [
      Regexp.new(ENV['DIRECTORY'])
    ]
  else
    datastore :memory
    
    fetch_url_whitelist [
      Regexp.new("#{ENV['AWS_BUCKET']}.s3.amazonaws.com")
    ]
  end
  
  response_header 'Cache-Control' do |job, request, headers|
    job.image? ? "public, max-age=10000000" : "private"
  end
end

use Dragonfly::Middleware

run S3::Photos::Application
