# e-deklaracje-docker

This is a docker version of e-deklaracje, application for submitting tax return in Poland. 

## Installation
Clone the github repository:
   `git clone https://github.com/eproxy/e-deklaracje-docker.git`

Enter a directory with downloaded Dockerfile and build an image:
  `docker build -t e-deklaracje .`

### Before you run it:
- Create a backup of existing e-deklaracje settings
- If e-deklaracje isn't installed on your local computer create .appdata directory in your home directory: `mkdir $HOME/.appdata`
- Enable local X server connectivity to a container: `xhost +local:docker`
   
 #### Start the docker:  

`docker run -ti --rm \`  
`-e DISPLAY=$DISPLAY \`  
`-v /tmp/.X11-unix:/tmp/.X11-unix \`  
`-v $HOME/.appdata/:/home/uzytkownik/.appdata:rw \`  
`e-deklaracje`
