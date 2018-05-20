use Mix.Config

config :raspi3, uploader: Raspi3.S3
config :raspi3, uart: Nerves.UART

config :arc,
  storage: Arc.Storage.S3, # or Arc.Storage.Local
  bucket: {:system, "AWS_S3_BUCKET"} # if using Amazon S3

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

config :logger,
  backends: [{LoggerFileBackend, :prod_log}]

config :logger, :prod_log,
  path: "./luna.log",
  level: :error
