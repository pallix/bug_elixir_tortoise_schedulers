defmodule BugElixirTortoiseSchedulers.Cluster do
  alias BugElixirTortoiseSchedulers.AssetSupervisor

  @slice_size 10

  def start_slice(slice_number) do
    {min_serial, max_serial} = slice(slice_number)

    for serial <- min_serial..max_serial do
      {:ok, _} =
        AssetSupervisor.start_link(
          serial: serial,
        )
      IO.puts "#{serial}"
      GenServer.cast(BugElixirTortoiseSchedulers.Naming.name(
            BugElixirTortoiseSchedulers.Asset, serial), :run)
    end
  end

  defp slice(slice_number) do
    {slice_number * @slice_size + 1, slice_number * @slice_size + @slice_size}
  end

end
