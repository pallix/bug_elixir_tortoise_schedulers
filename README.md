# BugElixirTortoiseSchedulers

Illustrate how the Erlang VM can become stucked when a lot of Tortoise connection
are created, even though system resources are still available.

## Reproduction of the problem

- Install the MQTT `mosquitto` server package.

- Starts iex and type:

```
for i <- 0..55, do: BugElixirTortoiseSchedulers.Cluster.start_slice(i)
```

This will starts a bunch of MQTT mosquitto servers, each running in its own
network namespace. At the same time, it starts one Tortoise connection per
server. Every second, a value is published on each of the servers.

## Observation

After several minutes, when the number of connections is high (>300) the BEAM VM becomes stucked.
On AWS, on a `m5.2xlarge` instance, it takes around 512 connections.
