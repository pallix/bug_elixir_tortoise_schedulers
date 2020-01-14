defmodule BugElixirTortoiseSchedulers.Naming do

  def name(module, serial) do
    module
    |> Atom.to_string()
    |> Kernel.<>("#{serial}")
    |> String.to_atom()
  end

end
