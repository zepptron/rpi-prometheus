# rpi-prometheus
Prometheus 2.0 for Raspberry Pi 2+3

<h1>Prometheus 2.0</h1>
If you have no idea what prometheus is you better start reading:
https://prometheus.io
https://github.com/prometheus/prometheus/releases

<h2>Using this Image</h2>
Using Prometheus is actually pretty simple because I have done all the basics for you. Running it in a container on a Raspberry Pi is pretty comfortable because it's actually pretty fast and also gives you the ability to mount external storage for your TSDB. You DON'T want to have that stuff inside your container. Imagine what happens when it dies...

<h5>Run it on a Single Host</h5>
Running it on a single node is straight forward. Assuming you have a local storage providing the necessary space for storing your Timeseries and providing the configfile for Prometheus.

```
docker run -dt -p 9090:9090 \
    -v /STORAGE/prometheus.yml:/etc/prometheus/prometheus.yml \
    -v /STORAGE/data:/nfs/prometheus/data \
    zepp/rpi-prometheus
```

<h5>Creating a service for Docker Swarm</h5>
Assuming you already have a Docker Swarm running you might want to use some NFS storage or similar to provide the different nodes with the same storage. Check this guide for further reference on how to setup NFS: http://nfs.sourceforge.net/nfs-howto/ar01s03.html

Afterwards you can configure the following codesnippet to your needs and just run it. Don't change the destinations, it's always the source unless you build it yourself!

```
docker service create \
    --name prometheus \
    --constraint 'node.role==worker' \
    --publish 9090:9090 \
    --mount type=bind,source=/NFS/prometheus.yml,destination=/etc/prometheus/prometheus.yml \
    --mount type=bind,source=/NFS/data,destination=/nfs/prometheus/data \
    zepp/rpi-prometheus
```

<h2>Configfile</h2>
This is a sample Configfile for running Prometheus and scraping the Metrics from Prometheus. 

**prometheus.yml:**
```
global:
  scrape_interval:     15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['0.0.0.0:9090']
```

<h2>Access Prometheus</h2>
It's up to you if you run it on a multinode docker environment or on a single host. In terms you use a single host its easy to access your Prometheus Instance: http://**IP-OF-YOUR-HOST**:9090

If you're running a multinode setup you should configure your loadbalancer accordingly if it isn't dynamically configured. 

<h2>Dockerfile Details</h2>

This Image is build on top of Alpine, provided by the Hypriot Guys: https://github.com/hypriot/rpi-alpine
If you're not aware of the Hypriot stuff you should really check out their stuff: https://blog.hypriot.com/

Alpine is used to make the Prometheusimage as small as possible. If you want to add/remove something, feel free to contribute!

You might also have noticed this command in the Dockerfile:

```
CMD ["--config.file=/etc/prometheus/prometheus.yml", \
     "--storage.tsdb.path=/nfs/prometheus/data", \
     "--storage.tsdb.retention=30d", \
     "--web.enable-lifecycle", \
     "--web.console.libraries=/usr/share/prometheus/console_libraries", \
     "--web.console.templates=/usr/share/prometheus/consoles" ]
```

For a full reference, check out the Prometheus docs: https://prometheus.io/docs/prometheus/latest/configuration/configuration/



```
REPOSITORY                   TAG                 IMAGE ID            CREATED             SIZE
zepp/rpi-prometheus          latest              b5d4fa3753f7        41 minutes ago      145MB
```

