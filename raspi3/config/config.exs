use Mix.Config

# You can configure your application as:
#
#     config :raspi3, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:raspi3, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :slack, api_token: System.get_env("SLACK_TOKEN")

import_config "#{Mix.env}.exs"
