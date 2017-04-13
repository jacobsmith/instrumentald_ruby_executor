require "minitest/autorun"
require_relative "../write_config_to_file"

class TestWriteConfig < Minitest::Test
  def test_redis_url_with_redis_protocol_raises_error
    env = {
      "INSTRUMENTALD_REDIS_URLS" => "redis://hello"
    }

    assert_raises RuntimeError do
      WriteConfig.new(env).perform
    end
  end

  def test_transforms_keys_from_heroku
    env = {
      "DATABASE_URL" => "postgres.com"
    }

    config = WriteConfig.new(env)
    config.convert_heroku_env_vars!
    assert_equal env["INSTRUMENTALD_POSTGRESQL_URLS"], "postgres.com?sslmode=require"
  end

  def test_appends_heroku_key
    env = {
      "INSTRUMENTALD_POSTGRESQL_URLS" => "hello.com",
      "DATABASE_URL" => "postgres.com"
    }

    config = WriteConfig.new(env)
    config.convert_heroku_env_vars!
    assert_equal env["INSTRUMENTALD_POSTGRESQL_URLS"], "hello.com,postgres.com?sslmode=require"
  end
end
