use Mix.Config

config :picam, camera: Picam.FakeCamera
config :raspi3, uart: Raspi3.UART.Fake

config :raspi3, uploader: Raspi3.LocalStorage

config :arc,
  storage_dir: "uploads"

config :logger,
  backends: [{LoggerFileBackend, :devel_log}]

config :logger, :devel_log,
  path: "./luna.log",
  level: :debug
