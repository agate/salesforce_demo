require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'yaml'

require File.expand_path('../lib/salesforce_demo', __FILE__)

SalesforceDemo.process
