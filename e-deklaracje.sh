# nazwa obrazu dockera
IMAGE_NAME="e-deklaracje"

# nazwa kontenera
CONTAINER_NAME="$IMAGE_NAME"

# mamy dockera?
if ! docker --version >/dev/null; then
  echo -ne '\nNie znalazłem dockera -- czy jest zainstalowany?\n\n'
  exit 1
fi

# czy istnieje już obraz o nazwie $IMAGE_NAME?
if docker inspect edeklaracje_lts >/dev/null; then
  # używamy go, czy budujemy od nowa?
  echo -n "Istnieje zbudowany obraz $IMAGE_NAME. Budować mimo to? (T/n) "
  read BUILD
  if [[ $BUILD != 'n' ]]; then
    echo -ne '\nBuduję obraz...\n\n'
    docker build -t $IMAGE_NAME ./
    echo -ne '\nObraz zbudowany.\n\n'
  else
    echo -ne '\nUżywam istniejącego obrazu.\n\n'
  fi

# nope
else
  # budujemy!
  echo -ne '\nBuduję obraz...\n\n'
  docker build -t e-deklaracje .
  echo -ne '\nObraz zbudowany.\n\n'
fi


# czy przypadkiem nie ma uruchomionego innego dockera z tą samą nazwą?
if [[ `docker inspect -f '{{.State}}' "$CONTAINER_NAME"` != '<no value>' ]]; then
  echo -ne "Wygląda na to, że kontener $CONTAINER_NAME istnieje; zatrzymuję/niszczę, by móc uruchomić na nowo.\n\n"
  docker stop "$CONTAINER_NAME"
  docker rm -v "$CONTAINER_NAME"
fi


# define where your backup .appdata are
E_DIR_B=$HOME/Documents-sync/e-deklaracje/.appdata
E_DIR=$HOME/.appdata
# Get the dir name where Backups lays
E=$(find "$E_DIR_B" -maxdepth 1 -type d  -name "e-Deklaracje*" | awk -F/ '{ print $NF }')
# if there is a copy and there is no .appdata dir in home directory
if [[ -d $E_DIR_B ]] && [[ ! -d $E_DIR/$E ]]; then
        echo "Backup dir of e-deklracje existis, $E"
        if [ ! -d $E_DIR ]; then
                mkdir $E_DIR
        fi
        echo "copying all files from backup $E_DIR_B to $E_DIR"
        rsync -a --progress $E_DIR_B/ $E_DIR/
fi

BACKUP=$HOME/Documents-sync/e-deklaracje

# na wszelki wypadek pytamy juzera
if [ -e "$HOME"/.appdata/e-Deklaracje* ]; then
  EDEKLARACJE_DIR=`echo $HOME/.appdata/e-Deklaracje* `
  # kopia zapasowa e-deklarcji na wypadek gdyby user jej nie zrobił
  cp -pr $HOME/.appdata $BACKUP/.appdata-`date "+%m.%d.%Y-%H:%M:%S"`
  echo -ne "\n\nUWAGA UWAGA UWAGA UWAGA UWAGA UWAGA UWAGA UWAGA UWAGA\nUżyty zostanie istniejący profil e-Deklaracji.\n\nMOCNO ZALECANE JEST ZROBIENIE KOPII ZAPASOWEJ PRZED KONTYNUOWANIEM!\n\nProfil znajduje się w katalogu:\n$EDEKLARACJE_DIR\n\nCzy zrobiłeś kopię zapasową i chcesz kontynuować? (T/n) "
  read BUILD
  if [[ $BUILD == 'n' ]]; then
    echo -ne 'Anulowano.\n\n'
    exit 0
  fi
fi

# if tmp directory doesn't exist on host create it before
if [ ! -d $HOME/tmp ]; then
        mkdir $HOME/tmp
fi
# jedziemy
echo -ne "\nUruchamiam kontener $CONTAINER_NAME...\n"

rm -rf $HOME/.appdata
mkdir $HOME/.appdata

xhost +local:docker
docker run --rm -ti \
  -v "$XSOCK":"$XSOCK" \
  -v "$HOME/.appdata":"/home/edeklaracje/.appdata" \
  -v "$HOME/tmp":"/home/edeklaracje/tmp" \
  -v "$HOME/Documents-sync/e-deklaracje":"/home/edeklaracje/Backup" \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY="$DISPLAY" \
  --name $CONTAINER_NAME $IMAGE_NAME e-deklaracje

