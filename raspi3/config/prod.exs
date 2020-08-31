use Mix.Config

config :raspi3, uploader: Raspi3.S3
config :raspi3, uart: Nerves.UART

config :arc,
  # or Arc.Storage.Local
  storage: Arc.Storage.S3,
  # if using Amazon S3
  bucket: {:system, "AWS_S3_BUCKET"}

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]
