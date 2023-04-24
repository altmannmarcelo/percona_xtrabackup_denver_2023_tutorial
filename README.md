# Percona Xtrabackup: From Zero to Hero
Percona Live Denver 2023 Tutorial - Percona Xtrabackup: From Zero to Hero
By @altmannmarcelo & @vgrippa


# Starting container
To start the tutorial container, type:

```
docker run -d -t -i --privileged --name percona_live altmannmarcelo/pxb_pl:latest
```

Validate you see `Everything is up and running.` on docker logs:

```
docker logs -n 1 percona_live
Everything is up and running.
```

