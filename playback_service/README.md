# Playback service

A simple service to playback a stream

## Prerequisites

* Ubuntu 16.04 LTS or greater
* mplayer, install as follows

```
$ sudo apt update
$ sudo apt install mplayer
```

## Setting up the service

Copy the service configuration file `playback.service` to `/etc/systemd/system/`.

Update the Stream URL placeholder `<STREAM_URL>`in service configuration file.

In Ubuntu Settings, ensure the right output (Soundcard) is selected.
Check that the output gain is set to 0db - you may do this with `alsamixer` from the terminal.

## Controlling the Service

Manual start and stop

```
$ systemctl start playback
$ systemctl stop playback
```

Control whether service loads on boot

```
$ systemctl enable playback
$ systemctl disable playback
```

Restarting/reloading

```
$ systemctl daemon-reload
$ systemctl restart playback
```

## View Status/Logs

See status of all services

```
$ systemctl status playback
```

Tail logs for playback service

```
$ journalctl -f -u playback.service
```
