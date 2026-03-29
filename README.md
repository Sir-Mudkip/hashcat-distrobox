## Purpose

This is a Container made for distrobox and designed to run hashcat. It supports GPU passthrough and has the appropriate dependencies to use hashcat. Before I say anything, this container does not include any wordlists out the box, Those you will need to add yourself. I'd suggest using Seclists, then mounting it to the container at the point of creation.

## Pre-requisites

You must have either Podman or Docker for this to work, and have them configured for GPU passthrough. If you don't then go to google and work it out. Claude will likely do most of it for you.

## Install

You can do this via a CLI, or you can do it easier way with DistroShelf which provides a nice GUI to use:
https://flathub.org/en-GB/apps/com.ranfdev.DistroShelf

```shell
distrobox create --image ghcr.io/sir-mudkip/hashcat-distrobox:latest --name hashcat-cuda --additional-flags "--gpus all -v /path/to/wordlist:/path/to/wordlist"
```
```shell
distrobox enter hashcat-cuda
```
```shell
distrobox-export --bin /usr/bin/hashcat
```

Hashcat should now be exported to your host, you will now need to export `~/.local/bin` to your `PATH` environment variable to ensure it runs. Once it's done, then you should be off to the races.
```shell
export PATH="~/.local/bin:$PATH"
```
```shell
hashcat -I
```
