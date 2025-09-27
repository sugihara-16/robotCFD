#!/usr/bin/env bash
set -euo pipefail
docker run --rm -it \
       --shm-size=2g \
  --user $(id -u):$(id -g) \
  -v "$PWD":/case \
  -w /case \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  openfoam/openfoam11-graphical-apps:latest\
  bash -lc 'source /opt/openfoam11/etc/bashrc; exec bash -i'

# #!/usr/bin/env bash
# set -euo pipefail

# xhost +local: >/dev/null 2>&1

# docker run --rm -it \
#   --user $(id -u):$(id -g) \
#   -v "$PWD":/case -w /case \
#   -e DISPLAY=$DISPLAY \
#   -e QT_QPA_PLATFORM=xcb \
#   -e QT_X11_NO_MITSHM=1 \
#   -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
#   --shm-size=1g \
#   openfoam/openfoam11-paraview510:latest \
#   bash -lc 'source /opt/openfoam11/etc/bashrc; exec bash -i'
