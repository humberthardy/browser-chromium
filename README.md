# PoC - Chromium with openGL support for [webrecorder](http://webrecorder.io)/[shepherd](https://github.com/oldweb-today/browsers) stack

Ubuntu 18.04 was used for this demonstration.

## Requirements
1. Ubuntu with X11 server
2. `nvidia` GPU
3. docker 
4. [nvidia runtime for docker engine](https://github.com/NVIDIA/nvidia-docker)
5. nvidia driver > 390 (tested with `nvidia-396`) 


## How to use it

1. Allow incoming connections to your X11 server (Run `xhost +` on your host OS)
2. Build the new `oldwebtoday/sphepherd` and `oldwebtoday/chromium:65` images by running `docker-compose build` from the terminal 
3. Restart your `shepherd`'s stack  

The modified version of `oldwebtoday/sphepherd` starts the browsers with:
   - `nvidia` runtime (equivalent to `docker run --runtime=nvidia`)
   - a bind of `/tmp/X11-unix:X0` between the host and browsers.
   
## How it works
- X11 socket is shared between host and the docker containers.
- vglrun from [VirtualGl](https://www.virtualgl.org/) wrap the `chromium-browser` process. it redirects GPU calls inside the container to the host through the previous socket
- The flag `--disable-gpu-sandbox` is passed to Chromium. The normal behaviour of Chromium use some forks, and is bypassing `vglrun`. This flag avoid this.
   
## How to check if openGL is working
open your browser to the following URL [chrome://:gpu](chrome://gpu)

## References
- [nvidia runtime for docker engine](https://github.com/NVIDIA/nvidia-docker)
- [glvnd-runtime](https://hub.docker.com/r/nvidia/opengl/)
- [TurboVNC](https://cdn.rawgit.com/TurboVNC/turbovnc/2.1.2/doc/index.html)
- [VirtualGl](https://www.virtualgl.org/)