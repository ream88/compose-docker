defmodule ComposeDocker.Yaml.V2 do
  defstruct name: nil,
            image: nil,
            container_name: nil,
            environment: [],
            volumes: [],
            ports: [],
            restart: nil

  def parse(string) when is_binary(string) do
    {:ok, yml} = YamlElixir.read_from_string(string)
    %{"services" => services, "version" => "2"} = yml

    Enum.map(services, &parse/1)
  end

  def parse(
        {name,
         %{
           "image" => image,
           "container_name" => container_name,
           "environment" => environment,
           "volumes" => volumes,
           "ports" => ports,
           "restart" => restart
         }}
      ) do
    volumes = replace_relative_paths(volumes)

    %__MODULE__{
      name: name,
      image: image,
      container_name: container_name,
      environment: environment,
      volumes: volumes,
      ports: ports,
      restart: restart
    }
  end

  def to_docker(%__MODULE__{} = config) do
    [
      "docker run",
      "--name #{config.container_name || config.name}",
      Enum.map(config.environment, &("-e " <> &1)),
      Enum.map(config.volumes, &("-v " <> &1)),
      Enum.map(config.ports, &("-p " <> &1)),
      "--restart #{config.restart}",
      config.image
    ]
    |> List.flatten()
    |> Enum.join(" ")
  end

  defp replace_relative_paths(volumes) do
    Enum.map(volumes, fn volume ->
      String.replace(volume, ~r{^.}, "$(pwd)")
    end)
  end
end
