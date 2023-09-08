# Ubuntu 20.04 LTS in einer VirtualBox

Wer kein Linux zur Verfügung hat, kann das Lab auch mit einer VM in VirtualBox durchführen.

Dazu muss in einer VM Ubuntu 20.04 LTS oder neuer installiert werden.

## Installation Guest Additions

1. Abhängigkeiten im System installieren
    ```shell
    sudo apt-get
    sudo apt-get upgrade
    sudo apt install build-essential dkms linux-headers-$(uname -r)
    ```
1. Im Menü _Devices -> Insert Guest Additions CD Image_ ... wählen
1. Ein Dialogfenster öffnet sich, dieses mit _Run_ bestätigen
1. Passwort eingeben
1. Die Guest Additions werden installiert
1. Nach der Installation mit _Enter_ im Terminal das Fenster schliessen lassen
1. Neustart der VM durchführen
