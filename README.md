# nginx-docker

This simply takes the official Nginx docker image and turns on autoindex.

This way you can do a simple mount to easily serve files from your local
file system with nginx.  I put this function in my bashrc:

```bash
declare -rx color_cyan='\033[0;36m'
# ...
declare -rx color_restore='\033[0m'

nginx-serve ()
{
    local port=${1:-8080}
    local root_dir=$(pwd)
    echo -e "${color_cyan}Starting nginx docker container serving $root_dir on port ${port}${color_restore}"
    docker run -it --rm --name nginx-file-server -p "$port:80" -v $root_dir:/usr/share/nginx/html:ro freedomben/nginx
}
```

Then just `cd` to whatever directory you want to serve, then run the command `nginx-serve`.

Then hit `http://<yourip>:8080/` and see the nice index page.  This is especially useful
for transferring files across a local network where SSH access is not available (like
to smart phones and such).

## Building

You can just pull it down from [Docker Hub](https://hub.docker.com/r/freedomben/nginx/)
if you want:  

```bash
docker pull docker.io/freedomben/nginx`
```

If you want to build it locally:

```bash
docker build -t docker.io/freedomben/nginx:latest docker.io/freedomben/nginx:1.13-alpine -f Dockerfile .
```

Then push (if you have push rights, which you probably don't, but this is useful for me
or for you if pushing to <registry>/<yourusername>/nginx

```bash
docker push docker.io/freedomben/nginx:latest && \
docker push docker.io/freedomben/nginx:1.13-alpine
```
