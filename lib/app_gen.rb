# frozen_string_literal: true

ENV['APP_ENV'] ||= 'development'
ENV['RACK_ENV'] = ENV['APP_ENV']

require 'rubygems'
require 'bundler/setup'

Bundler.require('default', ENV['APP_ENV'])

loader = Zeitwerk::Loader.new
loader.push_dir(__dir__)
loader.enable_reloading if ENV['APP_ENV'] == 'development'
loader.setup

loader.eager_load unless %w[test development].include?(ENV['APP_ENV'])

class AppGen < Thor
  map '-D' => :database

  desc 'generate APP_NAME PATH', 'generate a ruby application skeleton'
  option :force, type: :boolean
  option :database, type: :boolean, default: true
  def generate(app_name, path)
    @app_name = app_name
    @path = File.join(path, app_name)

    exit 1 unless check_app_dir

    create_files
  end

  private

  attr_reader :app_name, :path

  def ask_yes_no(prompt)
    %w[Y y yes Yes YES].include?(ask("#{prompt} [Y/n]:"))
  end

  def check_app_dir
    if Dir.exists?(path)
      continue = options.force? ||
                 ask_yes_no("Directory #{path} already exists. Do you want to continue?")
    else
      Dir.mkdir_p(path)
    end
  end

  def create_files
  end
end
