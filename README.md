# Docker in Miget Container

Below example presents how to run Docker in ~~Docker~~ Miget (Kata) Container.

The following example demonstrates how to run Docker-in-~~Docker~~Miget (Kata) Container.

> [!NOTE]  
> Miget's PaaS utilizes Kata Containers with `virtfs` as a storage bridge between the host system and the container runtime.
> What does this mean?
>  Since `virtfs` doesn't work well with `overlayfs`, a workaround is needed. We use a sparse image file mounted as an ext4 file system under `/var/lib/docker`. Please refer to the entrypoint.sh file for more details.
> To ensure this setup works, mount a block device under `/data` with sufficient available disk space.

## Build

To build your app, simply create one, assign it to your Miget (compute resource), and push your changes using `git push miget`. That's it!

## Run

Once the app is deployed on Miget, you can enter your app's shell and check the Docker setup by running the following command:

```
/ # docker info
Client:
 Version:    27.2.0
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.16.2
    Path:     /usr/local/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v2.29.2
    Path:     /usr/local/libexec/docker/cli-plugins/docker-compose

Server:
 Containers: 1
  Running: 0
  Paused: 0
  Stopped: 1
 Images: 1
 Server Version: 27.2.0
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Using metacopy: true
  Native Overlay Diff: false
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 472731909fa34bd7bc9c087e4c27943f9835f111
 runc version: v1.1.13-0-g58aa920
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
 Kernel Version: 6.1.62
 Operating System: Alpine Linux v3.20 (containerized)
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 742.1MiB
 ID: dee50a10-16e4-4051-955b-d02f56e38588
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
 Product License: Community Engine

WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```