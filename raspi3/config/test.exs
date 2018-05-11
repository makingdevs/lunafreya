use Mix.Config

config :picam, camera: Picam.FakeCamera
config :raspi3, uart: Raspi3.UART.Fake

config :raspi3, uploader: Raspi3.LocalStorage

config :arc,
  storage_dir: "uploads"