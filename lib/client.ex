defmodule BugElixirTortoiseSchedulers.Client do
  use GenServer

  require Logger

  alias BugElixirTortoiseSchedulers.Naming
  alias BugElixirTortoiseSchedulers.Asset

  def start_link(options) do
    serial = Keyword.fetch!(options, :serial)
    GenServer.start_link(__MODULE__, options, name: Naming.name(__MODULE__, serial))
  end

  def init(options) do
    serial = Keyword.fetch!(options, :serial)
    gateway = Keyword.fetch!(options, :gateway)
    start_client_env(serial)
    {:ok, %{serial: serial, gateway: gateway}}
  end

  defp start_client_env(serial) do
    priv_dir = :code.priv_dir(:bug_elixir_tortoise_schedulers) |> to_string()
    path = priv_dir <> "/start-client-env.sh"
    {_, 0} = System.cmd(path, ["#{serial}"])
  end

end
