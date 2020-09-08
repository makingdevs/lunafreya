use Mix.Config

config :pi3, uart: Nerves.UART

config :pi3, uploader: Raspi3.S3

config :arc,
  storage: Arc.Storage.S3,
  bucket: System.get_env("AWS_S3_BUCKET"),
  storage_dir: "luna_freya"

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")
