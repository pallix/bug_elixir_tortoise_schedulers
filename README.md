# BugElixirTortoiseSchedulers

Illustrate how the Erlang VM can become stucked when a lot of Tortoise connection
are created, even though system resources are still available.

## Reproduction of the problem

    - Check your system limits are high (`ulimit -a`), specially the maximum number of open files.

- Install the MQTT `mosquitto` server package.

- Starts iex and run the observer:

```
:observer.start()
```

- Then start the mosquitto servers:

```
for i <- 0..55, do: BugElixirTortoiseSchedulers.Cluster.start_slice(i)
```

This will starts a bunch of MQTT mosquitto servers, each running in its own
network namespace. At the same time, it starts one Tortoise connection per
server. Every second, a value is published on each of the servers.

## Observation

After several minutes, when the number of connections is high the BEAM VM
becomes stucked. The observer does not refresh anymore. On AWS, on a
`m5.2xlarge` instance, it takes between 300 and 600 connections. This happens
even if the machine resources are not exhausted. It is unexpected as the loads
of the scheduler shows a usage inferior to 50% befor the BEAM VM is too stucked
to refresh them.
