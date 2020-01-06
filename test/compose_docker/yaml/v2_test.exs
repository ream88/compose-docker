defmodule ComposeDocker.Yaml.V2Test do
  use ExUnit.Case, async: true
  alias ComposeDocker.Yaml.V2

  @docker_compose_file File.read!("test/fixtures/docker-compose.yml")

  test "parse parses the string" do
    assert V2.parse(@docker_compose_file)
  end

  test "to_docker returns a docker run command" do
    command = @docker_compose_file |> V2.parse() |> Enum.at(0) |> V2.to_docker()

    assert command =~ ~r/^docker run/
    assert command =~ ~r/--name unifi-controller/

    assert command =~ ~r/-e PUID=1000/
    assert command =~ ~r/-e PGID=1000/

    assert command =~ ~r{-v \$\(pwd\)/data:/config}
    assert command =~ ~r{-v \$\(pwd\)/certs:/home/certs}

    assert command =~ ~r/-p 8080:8080/
    assert command =~ ~r/-p 8443:8443/

    assert command =~ ~r/--restart unless-stopped/
    assert command =~ ~r{linuxserver/unifi-controller$}
  end
end
