# compose-docker

Convert docker-compose.yml back to docker commands.

> :warning: **This project does only support a very small subset of docker-compose.yml.** I just finished my personal requirements, but feel free to fork/expand it. **PRs are welcome!**

## Installation

```
mix do deps.get, escript.build
```

## Usage

```
./compose_docker test/fixtures/docker-compose.yml
```

## Why?

Installing docker-compose and all its python devs brought my Raspberry Pi Zero to a crawl.

## License

[MIT](./LICENSE.md)
