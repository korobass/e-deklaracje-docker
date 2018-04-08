FROM ubuntu:14.04.3

Maintainer ergo@ergoproxy.eu 

ENV uid 1000
ENV gid 1000
ENV HOME=/home/uzytkownik

RUN useradd -m uzytkownik; \
    dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install -y wget \
		       libgtk2.0-0:i386 \
		       libstdc++6:i386 \
		       libnss3-1d:i386 \
		       lib32nss-mdns \
 		       libxml2:i386 \
		       libxslt1.1:i386 \
		       libcanberra-gtk-module:i386 \
		       gtk2-engines-murrine:i386 \
		       libqt4-qt3support:i386 \
                       unzip \
		       libgnome-keyring0:i386; \
 rm -rf /var/lib/apt/lists/*

RUN wget ftp://ftp.adobe.com/pub/adobe/reader/unix/9.x/9.5.5/enu/AdbeRdr9.5.5-1_i386linux_enu.deb -P /tmp ; \ 
    dpkg -i /tmp/AdbeRdr9.5.5-1_i386linux_enu.deb; \
    rm /tmp/AdbeRdr9.5.5-1_i386linux_enu.deb


RUN ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0 /usr/lib/libgnome-keyring.so.0; \
    ln -s /usr/lib/i386-linux-gnu/libgnome-keyring.so.0.2.0 /usr/lib/libgnome-keyring.so.0.2.0

RUN wget http://airdownload.adobe.com/air/lin/download/2.6/AdobeAIRSDK.tbz2 -P /tmp; \ 
    mkdir -p $HOME/adobe-air-sdk; \
    tar jxf /tmp/AdobeAIRSDK.tbz2 -C $HOME/adobe-air-sdk


RUN wget https://aur.archlinux.org/cgit/aur.git/snapshot/adobe-air.tar.gz -P /tmp; \
    tar xvf /tmp/adobe-air.tar.gz -C $HOME/adobe-air-sdk; \
    sed -i -e 's/\/opt/$HOME/g' $HOME/adobe-air-sdk/adobe-air/adobe-air; \
    chmod +x $HOME/adobe-air-sdk/adobe-air/adobe-air


RUN mkdir -p $HOME/adobe-air-sdk/e-deklaracje; \
    wget http://www.finanse.mf.gov.pl/documents/766655/1196444/e-DeklaracjeDesktop.air -P /tmp; \
    cp /tmp/e-DeklaracjeDesktop.air $HOME/adobe-air-sdk/e-deklaracje/
         	

ENTRYPOINT su - uzytkownik -c '$HOME/adobe-air-sdk/adobe-air/adobe-air $HOME/adobe-air-sdk/e-deklaracje/e-DeklaracjeDesktop.air'
