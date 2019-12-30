defmodule ComposeDocker do
  alias ComposeDocker.Yaml.V2

  def main([path]) do
    {:ok, string} = File.read(path)

    string
    |> V2.parse()
    |> Enum.each(fn config ->
      IO.puts(IO.ANSI.green() <> config.name <> ":" <> IO.ANSI.reset())
      IO.puts("  " <> V2.to_docker(config))
    end)
  end
end
