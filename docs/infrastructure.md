# Homelab Infrastructure

## Network

| Component | Address | Role |
|---|---|---|
| TP-Link Archer BE3500 | `192.168.1.1` | Router / DHCP |
| BeagleBone Black | `192.168.1.2` | Pi-hole / primary DNS |
| OptiPlex 7050 | `192.168.1.232` | TrueNAS / storage |

The LAN uses `192.168.1.0/24`.

The DHCP range configured on the TP-Link router is `192.168.1.2` through `192.168.1.253`. The BeagleBone Black and OptiPlex have reserved addresses in the router.

The Cox modem operates in bridge mode and is outside the homelab automation scope.

## BeagleBone Black

- Hostname: `BeagleBone`
- Address: `192.168.1.2`
- OS: Debian 12 (Bookworm)
- Architecture: ARMv7 (`armv7l`)
- Memory: 512 MiB
- Swap: 753 MiB
- Primary service: Pi-hole
- Pi-hole FTL: `6.6.2`
- Pi-hole Core: `6.4.2`
- Pi-hole Web: `6.5`

Pi-hole is the primary DNS server for the LAN.

Pi-hole currently uses Google DNS (`8.8.8.8` and `8.8.4.4`) as its upstream DNS servers.

Local DNS records currently include:

- `pihole.home.arpa` → `192.168.1.2`
- `truenas.home.arpa` → `192.168.1.232`
- `jellyfin.home.arpa` → `192.168.1.232`
- `homelab.home.arpa` → `192.168.1.232`

## OptiPlex 7050

- Hostname: `truenas`
- Address: `192.168.1.232`
- OS: TrueNAS `25.10.6`
- CPU: Intel Core i7-7700
- CPU: 4 cores / 8 threads
- Virtualization: Intel VT-x
- Memory: 16 GiB
- Network: Intel I219-LM, 1 GbE
- Integrated GPU: Intel HD Graphics 630
- Additional GPU: AMD Radeon
- SATA SSD: WDC 250 GB
- NVMe: Samsung PM961 256 GB

TrueNAS is currently running directly on the OptiPlex.

## Storage

The main ZFS pool is `MyPool`.

Current usage:

- Used: approximately 33 GiB
- Available: approximately 196 GiB

The pool currently contains media and application-related datasets, including:

- `MyPool/MyMedia`
- `MyPool/Jellyfin`
- `MyPool/AnkiSyncServer`
- `MyPool/Homepage`
- `MyPool/ix-apps`

The existing TrueNAS application storage will be treated as transitional infrastructure while the homelab is moved toward the target architecture.

## Current Applications

TrueNAS currently runs:

- Jellyfin
- Anki Sync Server
- Homepage

Jellyfin will remain on TrueNAS for the foreseeable future because it benefits from access to the host's GPU hardware for media transcoding.

Homepage is planned for removal.

Anki Sync Server is planned to be rebuilt as a Kubernetes workload.

## Target Architecture

TrueNAS will remain installed directly on the OptiPlex and will remain responsible for storage.

K3s will run in a virtual machine provided by TrueNAS.

The intended separation is:

```text
OptiPlex
└── TrueNAS
    ├── ZFS / storage
    ├── Jellyfin
    └── K3s VM
        └── Kubernetes workloads
```

## K3s VM

K3s will run in a virtual machine hosted by TrueNAS on the OptiPlex 7050.

The initial VM specification is:

- OS: Debian 13 (Trixie)
- Architecture: x86_64
- vCPU: 4
- Memory: 6 GiB
- Disk: 40 GiB
- IP address: `192.168.1.233`
- DNS name: `k3s.home.arpa`

The VM will use the LAN through the TrueNAS virtual networking configuration.

The VM disk will be stored on a dedicated location within `MyPool`, separate from the media dataset.

### K3s VM Resource Rationale

The VM is intentionally sized conservatively because the OptiPlex has 16 GiB of physical memory and also runs TrueNAS and Jellyfin.

The initial allocation of 4 vCPUs and 6 GiB of RAM leaves resources available for TrueNAS and its existing services.

The 40 GiB VM disk is intended for the operating system and Kubernetes infrastructure only. Media will remain on TrueNAS storage and will not be stored inside the VM disk.

The VM resources can be increased later if required.
