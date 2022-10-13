defmodule Tools do
  @spec read_file(String.t()) :: [String.t()]
  def read_file(name) do
    data = ("data/" <> name)
    |> File.read!()
    |> String.split("\n", trim: true)

    IO.inspect(length(data), label: "Lines loaded from file")

    data
  end
end
