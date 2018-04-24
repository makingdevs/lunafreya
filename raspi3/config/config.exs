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

config :arc,
  storage: Arc.Storage.S3, # or Arc.Storage.Local
  bucket: {:system, "AWS_S3_BUCKET"} # if using Amazon S3

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

import_config "#{Mix.env}.exs"
