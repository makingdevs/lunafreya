defmodule Pi3.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Pi3.Supervisor]

    children =
      [
        Supervisor.child_spec({Raspi3.Supervisor, []}, id: Raspi3.Supervisor),
        Raspi3.Luna,
        Raspi3.Luna.EyesServer
      ] ++ children(target())

    Supervisor.start_link(children, opts)
  end

  def children(:host) do
    []
  end

  def children(_target) do
    []
  end

  def target() do
    Application.get_env(:pi3, :target)
  end
end
