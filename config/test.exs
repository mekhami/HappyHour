import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :happy_hour, HappyHour.Repo,
  username: "postgres",
  password: "mysecretpassword",
  database: "happy_hour_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "172.17.0.2",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :happy_hour, HappyHourWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "4M+PwsRTsu8P9XENyxQpU4X89so6srPwlqQhR5+AZy3ElSyMtNkVw7J98/AKNF45",
  server: false

# In test we don't send emails.
config :happy_hour, HappyHour.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
