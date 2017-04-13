#!/usr/bin/env ruby

require 'erb'

class WriteConfig
  attr_reader :env

  def initialize(env = ENV)
    @env = env
  end

  def perform(env = ENV)
    renderer = ERB.new(File.read("instrumentald_config.toml.erb"))

    convert_heroku_env_vars!
    verify_env_vars!

    File.open("instrumentald_config.toml", "w") do |file|
      file.puts renderer.result
    end
  end

  def verify_env_vars!
    raise "Redis urls must *not* have 'redis://' prepended to them" if env["INSTRUMENTALD_REDIS_URLS"]&.split(",")&.any? { |url| url.start_with?("redis://") }

    if env["INSTRUMENTALD_POSTGRESQL_URLS"]&.split(",")&.none? { |url| url.end_with?("?sslmode=require") }
      puts <<~WARN
        IF YOU ARE ON HEROKU:

        You need to append `?sslmode=require` to your INSTRUMENTALD_POSTGRESQL_URLS to connect to Heroku managed Postgres instances.

        If You're not on Heroku:
        You still probably should for security's sake.
      WARN
    end
  end

  def convert_heroku_env_vars!
    if !env["DATABASE_URL"].nil?
      existing_entries = get_existing_entries(env["INSTRUMENTALD_POSTGRESQL_URLS"])
      existing_and_database_url = existing_entries << "#{env["DATABASE_URL"]}?sslmode=require"
      env["INSTRUMENTALD_POSTGRESQL_URLS"] = existing_and_database_url.join(",")
    end
  end

  private

  def get_existing_entries(arg)
    (arg || "").split(",")
  end
end

if __FILE__==$0
  WriteConfig.new(ENV).perform
end
