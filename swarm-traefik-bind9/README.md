# swarm-traefik-bind9 demo

In this folder you will find an example of how one would:

1. Listen for Docker **Swarm** events; and
2. Update a **Bind9** DNS Server instance with hostnames defined with **Traefik** service deployment labels.

# Try it yourself

First, bring up all the DNS Bind9 server and Bindman-DNS stuff:

`docker stack deploy -c docker-compose.yml sandman-dns-agent`

Then, bring a **hello** service up:

`docker stack deploy -c hello.yml hello`

If everything goes right, you should execute 

`nslookup hello.test.com <host ip>` and check that the *hello.test.com* points now to 0.0.0.0

If you are running on your local machine, `<host ip>` usually is `localhost`, so it would be `nslookup hello.test.com localhost`

# docker-compose.yml

The given docker compose lays out which services should be available to each other over a network.

The ultimate purpose here is to make it possible for dynamic DNS updates from new services being added to the Swarm with traefik deployment labels. 

Keep in mind this is for demonstration purpose only and you'll probably not find a setup like this in production.

To take a look at this sample, you **must** execute this command in a Docker Swarm, the following way:

```
docker stack deploy -c docker-compose.yml bindman-dns-agent
```

# Context

The following services need to coexist and be able to talk to each other over a network:

1. [**Bindman-DNS Listener**](https://github.com/labbsr0x/bindman-dns-listener): this service sits on a Swarm cluster listening for Swarm events. 
In this demo, we expect Swarm Services to be annotated with traefik-specific labels that defines which hostname should be given to that service instance.

2. [**Bindman-DNS Manager**](https://github.com/labbsr0x/bindman-dns-manager): this service can sit literally anywhere, but must be reachable to the listener and must be able to reach the Bind9 Server over a network. When the listener identifies new services and their respective hostnames, it sends the information to the manager via a proper [Webhook](https://github.com/labbsr0x/bindman-dns-webhook). The manager then updates its DNS Server with the given hostname. Keep in mind that a Bindman-DNS Manager instance can manage only **one** zone.

3. **Bind9 Server**: this service defines a DNS Server responsible for resolving DNS queries. Which DNS queries this service can solve or not are managed by theBindman-DNS Manager.
For this demo, the Bind9 Server owns the zone `test.com` and every DNS update needs to be in regards to domains within that zone, i.e., `<domain>.test.com`. 

# Secure communication

On the `keys` folder, you will find the keys that enable secure communication between the manager and the Bind9 Server for the `test.com` zone.

If you want to define your own zones you will need to create a key on the bind9 server and mount them to the `/data` volume of the manager. For now, we support only `dnssec-keygen` generated keys. We used the following commands for the `test.com` zone:

```
dnssec-keygen -a HMAC-MD5 -b 512 -n HOST test.com
```

[Go here](http://www.firewall.cx/linux-knowledgebase-tutorials/system-and-network-services/831-linux-bind-ipadd-data-file.html) to understand a bit more about how to properly configure your BIND DNS server.