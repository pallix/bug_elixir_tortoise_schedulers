defmodule BugElixirTortoiseSchedulers.Asset do
  use GenServer

  alias BugElixirTortoiseSchedulers.Naming

  def start_link(options) do
    serial = Keyword.fetch!(options, :serial)
    GenServer.start_link(__MODULE__, options, name: Naming.name(__MODULE__, serial))
  end

  def init(options) do
    serial = Keyword.fetch!(options, :serial)

    {:ok, %{serial: serial,
           }}
  end

  def handle_cast(:run, state) do
    publish(state)
    {:noreply, state, 1_000}
  end

  def handle_info(:timeout, state) do
    publish(state)
    {:noreply, state, 1_000}
  end

  @doc "Returns the IP of the network namespace where the simulation run"
  def ip(serial) do
    # keep in sync with the algorithm in create-net-ns.sh
    "10.11.#{div(serial, 253)}.#{rem(serial, 253) + 2}"
  end

  defp publish(state) do
    Tortoise.publish("sim#{state.serial}", "topicBla", "valueBlu", qos: 0)
  end

end
