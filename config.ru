#!/usr/bin/env ruby

require "bundler/setup"
require "s3/photos"

run S3::Photos::Application
