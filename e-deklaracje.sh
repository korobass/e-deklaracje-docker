docker build -t e-deklaracje .
xhost +local:docker
docker run --rm -ti \
  -v "$XSOCK":"$XSOCK" \
  -v "$HOME/.appdata":"$HOME/edeklaracje/.appdata" \
  -v "$HOME/tmp":"$HOME/tmp" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY="$DISPLAY" \
  e-deklaracje

