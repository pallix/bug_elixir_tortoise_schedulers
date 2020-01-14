defmodule BugElixirTortoiseSchedulers.AssetSupervisor do
  use Supervisor

  alias BugElixirTortoiseSchedulers.Asset
  alias BugElixirTortoiseSchedulers.Client
  alias BugElixirTortoiseSchedulers.Naming

  def start_link(options) do
    serial = Keyword.fetch!(options, :serial)
    Supervisor.start_link(__MODULE__, options, name: Naming.name(__MODULE__, serial))
  end

  @impl true
  def init(options) do
    serial = Keyword.fetch!(options, :serial)
    # hardcoded in create-net-ns.sh
    gateway = "10.11.1.1"
    mqtt_host = Asset.ip(serial)

    children = [
      {Client, [serial: serial, gateway: gateway]},
      %{
        start:
        {Tortoise.Supervisor, :start_child,
         [[
           client_id: "sim#{serial}",
           handler: {Tortoise.Handler.Logger, []},
           server: {Tortoise.Transport.Tcp, host: mqtt_host, port: 1883},
           keep_alive: 65_535,
           subscriptions: []
         ]]},
        id: Tortoise.Supervisor
      },
      {Asset, [serial: serial]},
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

end
