# frozen_string_literal: true

ENV['APP_ENV'] ||= 'development'
ENV['RACK_ENV'] = ENV['APP_ENV']

require 'rubygems'
require 'bundler/setup'

require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir(__dir__)
loader.enable_reloading if ENV['APP_ENV'] == 'development'
loader.setup

loader.eager_load unless %w[test development].include?(ENV['APP_ENV'])

module AppGen
  # no op
end
