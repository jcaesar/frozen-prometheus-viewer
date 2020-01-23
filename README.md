# Frozen Prometheus Viewer

Bring your own dashboard.

Run as
```
podman run --rm -p 3000:3000 -v $PWD/blubbs.tgz:/mnt/arc.tgz -v $PWD/own-grafana-dash.json:/dash/board.json liftm/frozen-prometheus-viewer
```

`blubbs.tgz` is expected to contain files like
```
blubbs/prometheus/lock
blubbs/prometheus/wal/00000000
blubbs/prometheus/wal/00000001
```

Note that the provided dashboards will have their time windows overwritten.

