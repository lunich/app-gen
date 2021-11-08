# frozen_string_literal: true

require 'fileutils'

require 'active_support/core_ext/string'
require 'erubi'
require 'thor'

module AppGen
  class App < Thor
    desc 'generate APP_NAME PATH', 'generate a ruby application skeleton'
    option :force, type: :boolean
    option :database, type: :boolean, default: true
    def generate(app_name, path)
      @app_name = app_name
      @app_root = File.join(path, app_name)
      @root = File.expand_path('../..', __dir__)

      create_directories
      create_files
      puts 'Complete!'
    end

    private

    attr_reader :app_name, :app_root, :root

    def terminate!(error_code: 1, error_message: nil)
      puts error_message if error_message
      exit error_code
    end

    def app_filename
      @app_filename ||= app_name.underscore
    end

    def app_classname
      @app_classname ||= app_filename.camelize
    end

    def templates_path
      File.join(root, 'lib/templates')
    end

    def ask_yes_no(prompt)
      %w[Y y yes Yes YES].include?(ask("#{prompt} [Y/n]:"))
    end

    def check_directories
      return unless Dir.exists?(app_root)
      return if options.force?
      return if ask_yes_no("Directory #{app_root} already exists. Do you want to continue?")

      terminate!(error_message: 'Skipped!')
    end

    def db_directories
      return [] unless options.database?

      [
        File.join(app_root, 'db/config'),
        File.join(app_root, 'db/migrate')
      ]
    end

    def app_directories
      [
        app_root,
        File.join(app_root, 'bin'),
        File.join(app_root, "lib/#{app_filename}")
      ]
    end

    def create_directories
      check_directories

      (app_directories + db_directories).each do |dir|
        FileUtils.mkdir_p(dir)
      end
    end

    def create_files
      files = {
        'Gemfile' => 'Gemfile',
        'Rakefile' => 'Rakefile',
        'bin/console' => 'bin/console',
        'lib/app.rb' => "lib/#{app_filename}.rb",
        'lib/app/app.rb' => "lib/#{app_filename}/app.rb"
      }
      files['db/config/database.yml'] = 'db/config/database.yml' if options.database?

      files.each do |template, file|
        create_app_file(template, file)
      end

      FileUtils.chmod 0755, app_file_path('bin/console')
    end

    def read_template(template_filename)
      File.read(File.join(templates_path, template_filename))
    rescue Errno::ENOENT => e
      terminate!(error_message: "Can't read #{template_filename} template")
    end

    def template_data_to_src(template_data)
      template_src = Erubi::Engine.new(template_data).src
      eval(template_src)
    end

    def app_file_path(file)
      File.join(app_root, file)
    end

    def create_app_file(template, file)
      app_file_path = app_file_path(file)
      if !File.exists?(app_file_path) ||
         options.force? ||
         ask_yes_no("#{file} already exists, do you want to override it?")
        src = template_data_to_src(read_template("#{template}.erb"))
        File.open(app_file_path, 'wb') { |file| file << src }
      else
        puts "Skipping #{file}"
      end
    end
  end
end
