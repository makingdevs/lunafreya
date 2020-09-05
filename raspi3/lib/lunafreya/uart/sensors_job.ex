defmodule Raspi3.Sensors.Job do
  use GenServer

  @uart Application.get_env(:pi3, :uart)

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    @uart.open(Raspi3.Arduino.Serial, "ttyACM0", speed: 9600, active: false)
    @uart.configure(Raspi3.Arduino.Serial, framing: {@uart.Framing.Line, separator: "\r\n"})
    {:ok, state, 1000}
  end

  def handle_info(:timeout, state) do
    get_data = fn -> @uart.read(Raspi3.Arduino.Serial, 1000) end
    Raspi3.SensorData.write_info(get_data)
    {:noreply, state, 1000}
  end
end
