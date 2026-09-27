---
layout: post
title:  "Krocení Samby"
author: "Jarda"
description: Rozchození Samby v Proxmoxu, aby se mountovala až po naběhnutí sítě.
categories: 
    - Homelab
    - Proxmox
tags: 
    - SMB
---

Serve se v 23:55 vypíná abych šetřil proud. Ráno manuálně stolák zapnu. Proxmox naběhně, roztočí virtuálky, kontejnery se spustí... 

Ale Samba se nepřipojí...

Kontejnery nemají namapovanou paměť -> vše jde do háje...

```bash
===== BOOT TIMING: NETWORK + MOUNT =====
The time when unit became active or started is printed after the "@" character.
The time the unit took to start is printed after the "+" character.

mnt-data.mount +656ms
└─network-online.target @2.138s
  └─network.target @2.115s
    └─networking.service @1.756s +357ms
      └─network-pre.target @1.739s
        └─netfilter-persistent.service @1.611s +128ms
          └─local-fs.target @1.601s
            └─run-docker-netns-08c858701f72.mount @4.755s
              └─local-fs-pre.target @662ms
                └─systemd-tmpfiles-setup-dev.service @627ms +30ms
                  └─systemd-tmpfiles-setup-dev-early.service @540ms +77ms
                    └─kmod-static-nodes.service @488ms +46ms
                      └─systemd-journald.socket @463ms
                        └─-.mount @431ms
                          └─-.slice @431ms
```

Nejdůležitější je ten sudo journalctl. Z předchozího výstupu už víme:

```txt
networking.service @1.756s +357ms
network-online.target @2.138s
mnt-data.mount +656ms
```

Takže `network-online.target je zde prakticky` jen „networking.service skončila“, nikoliv „ens18 má funkční konektivitu“. To přesně vysvětluje Network is unreachable.

Současný critical-chain už ukazuje, že pokus s `After=networking.service` skutečně funguje z pohledu pořadí — SMB mount je až po networking.service. Jenže to pořadí samo o sobě nestačí.

Nastavíme tedy `ifupdown-wait-online.service` a necháme ho čekat na konkrétní interface, který má být online. V mém případě je to `ens18`.

```bash
systemctl cat ifupdown-wait-online.service
```

```conf
# /usr/lib/systemd/system/ifupdown-wait-online.service
[Unit]
Description=Wait for network to be configured by ifupdown
DefaultDependencies=no
Before=network-online.target
ConditionFileIsExecutable=/usr/sbin/ifup

[Service]
Type=oneshot
ExecStart=/usr/lib/ifupdown/wait-online.sh
RemainAfterExit=yes

[Install]
WantedBy=network-online.target
```

`sudo vim /etc/default/networking`

```conf
# Configuration for networking init script being run during
# the boot sequence

# Set to 'no' to skip interfaces configuration on boot
#CONFIGURE_INTERFACES=yes

# Don't configure these interfaces. Shell wildcards supported/
#EXCLUDE_INTERFACES=

# Set to 'yes' to enable additional verbosity
#VERBOSE=no

# Method to wait for the network to become online,
# for services that depend on a working network:
# - ifup: wait for ifup to have configured an interface.
# - route: wait for a route to a given address to appear.
# - ping/ping6: wait for a host to respond to ping packets.
# - none: don't wait.
WAIT_ONLINE_METHOD=route

# Which interface to wait for.
# If none given, wait for all auto interfaces, or if there are none,
# wait for at least one hotplug interface.
WAIT_ONLINE_IFACE=ens18

# Which address to wait for for route, ping and ping6 methods.
# If none is given for route, it waits for a default gateway.
#WAIT_ONLINE_ADDRESS=

# Timeout in seconds for waiting for the network to come online.
WAIT_ONLINE_TIMEOUT=300
```

```bash
sudo systemctl enable ifupdown-wait-online.service
sudo systemctl daemon-reload
```

Restartujte stroj:
`sudo reboot`

Konečně se Samba mountuje a kontejnery nabíhají.