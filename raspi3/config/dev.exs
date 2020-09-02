use Mix.Config

config :picam, camera: Picam.FakeCamera
config :pi3, uart: Raspi3.UART.Fake

config :pi3, uploader: Raspi3.LocalStorage

config :arc,
  storage_dir: "uploads"
