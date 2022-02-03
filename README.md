# nginx-docker

This simply takes the official nginx docker image and turns on `autoindex`.

This way you can do a simple mount to easily serve files from your local
file system with nginx.  To serve the current working directory on port 8080, use
this command:

```bash
docker run --rm -it --name nginx-file-server -p '8080:80' \
    -v $(pwd):/usr/share/nginx/html:ro docker.io/freedomben/nginx
```

Or to serve `/home/bryan/www` daemonized:

```bash
docker run --rm -d --name nginx-file-server -p '8080:80' \
    -v /home/bryan/www:/usr/share/nginx/html:ro docker.io/freedomben/nginx
```

For convenience I added this function to my `.bashrc` that defaults to the current
directory and port 8080:

```bash
declare -rx color_cyan='\033[0;36m'
# ...
declare -rx color_restore='\033[0m'

nginx-serve ()
{
    local port=${1:-8080}
    local root_dir=$(pwd)
    echo -e "${color_cyan}Starting nginx docker container serving $root_dir on port ${port}...${color_restore}"
    echo -e "${color_cyan}Stop the server with Ctrl+C when finished${color_restore}"
    docker run                                      \
        --interactive                               \
        --tty                                       \
        --rm                                        \
        --name nginx-file-server                    \
        --publish "$port:80"                        \
        --volume $root_dir:/usr/share/nginx/html:ro \
        docker.io/freedomben/nginx

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

Or if you want to build it locally:

```bash
docker build -t docker.io/freedomben/nginx:latest -t docker.io/freedomben/nginx:1.21-alpine -f Dockerfile .
```

Then push (if you have push rights, which you probably don't, but this is useful for me
or for you if pushing to <registry>/<yourusername>/nginx

```bash
docker push docker.io/freedomben/nginx:latest && \
docker push docker.io/freedomben/nginx:1.21-alpine
```

## FAQ

*Is this secure?  Is it safe?*

There may be open CVEs since upstream gets them occasionally.   I try to update this image
often but it's not a prod image for me so it can fall behind sometimes.

As far as safety, be careful not to serve up some directory with potentially sensitive
things in it.  For example you probably don't want to serve your home directory since
basically all of your files are exposed unsecured over your network.  Stick the stuff you
want to be available into a directory with no subdirectories in it, then expose that.

Also make sure to stop the server when you're done with it.  If you ran it in the foreground
just hit `Ctrl+C` or `docker stop nginx-file-server`.  If you daemonized it, use `docker stop nginx-file-server` (or whatever name you gave the container).

*Can I use this in prod to serve my static website?*

Sure I suppose.  It is nginx after all.  However you probably want to fine-tune the
nginx config file for your app targeting security and performance.  No effort has been done
on this image by me here toward those goals.

Also,  I try to keep up with the current version but that's not a high priority since
this is a simple convenience tool that I use to move files over my local network.  As such,
the version being run might be outdated and have security vulnerabilities in it.  For this
reason I wouldn't use this in prod.

