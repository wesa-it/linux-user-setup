# BOOT/LOG:
## Fehler:
```iwlwifi 0000:25:00.0: firmware: failed to load iwlwifi-ty-a0-gf-a0-76.ucode (-2)```

## Forum link
https://community.frame.work/t/solved-wifi-stopped-working-on-debian-11-bullseye-failed-to-load-iwlwifi-ty-a0-gf-a0-67-ucode/27547

## solution
```
sudo apt install rfkill
sudo rfkill unblock wlan
```
<hr>

# BOOT/LOG:
## Fehler:
```
[ 5166.417874] usb 1-2: reset high-speed USB device number 2 using xhci_hcd
[ 5166.620302] usb 1-2: device descriptor read/64, error -71
```

## Forum link
XXX

## solution
```
gibt keine
```
<hr>

## sources.list
https://linuxnews.de/debian-firmware-erfordert-aenderung-der-quellen/
non-free-firmware
  
## osu
Herunterladen auf lutris -> Stable

## 144hz fix für wayland
binary holen für normales, nicht unstable

## Link
https://software.opensuse.org/download.html?project=home%3Ahwsnemo%3Axwayland&package=xwayland

<hr>

## Discord

## URL
https://discord.com -> .tar.gz

## Für Wayland BÜ (Man muss 2x BÜ machen dass es klappt)

## URL
https://github.com/SpacingBat3/WebCord

## OpenTabletDriver fix / KDE Wacom entfernen
echo "blacklist wacom" | sudo tee -a /etc/modprobe.d/blacklist.conf
```sudo rmmod wacom```

<hr>

## WhatsApp für Linux

## URL
https://github.com/eneshecan/whatsapp-for-linux

<hr>

## KDE Numpad aktivieren beim starten // Dolphin doppelklick raus (dass man nicht sofort in ordner geht)

## Lösung
KDE Plasma Go to System Settings > Input Devices > Keyboard, 
in the Hardware tab, in the NumLock on Plasma Startup section, choose the desired NumLock behavior

## Ordner:

https://www.reddit.com/r/kde/comments/oesvog/is_there_a_way_to_enable_doubleclick_to_open/?rdt=45998
System settings > Workspace Behavior > General Behavior

Set "Clicking files or folders" to "Selects them"

## Spotify OSS
https://github.com/KRTirtho/spotube/releases/download/v3.1.1/Spotube-linux-x86_64.deb

## AMD gpu gui
https://github.com/ilya-zlobintsev/LACT/releases/download/v0.4.3/lact-0.4.3-0.amd64.debian-12.deb

## Rustdesk
https://github.com/rustdesk/rustdesk/releases/tag/1.2.2

## android AIK
https://forum.xda-developers.com/attachments/aik-linux-v3-8-all-tar-gz.5300923/

## logitech g533 Headset
https://github.com/Sapd/HeadsetControl
https://gitlab.com/Razuuu/headsetcontrol-notificationd

## Rockstar Games Launcher / GTA5
Wenn Rockstar Games nicht startet, alle Ordner suchen mit Rockstar Games Launcher
Wine zu Proton, irgentwie wechseln dass es klappt
Kein Autologin

## Android / LineageOS Builden
```libncurses5-dev``` auf debian trixie gibt es nicht mehr
```
sudo ln -s /lib/x86_64-linux-gnu/libncurses.so.6 /lib/x86_64-linux-gnu/libncurses.so.5
sudo ln -s /lib/x86_64-linux-gnu/libtinfo.so.6 /lib/x86_64-linux-gnu/libtinfo.so.5
```

## SWAP erhöhen
## Forum
https://discovery.endeavouros.com/storage-and-partitions/adding-swap-after-installation/2021/03/

SWAP ausschalten bei GParted / oder CLI
```
sudo swapoff /swapfile
sudo rm -f /swapfile

sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608
sudo chmod 600 /swapfile
```

```ls -l /swapfile 
sudo chmod 600 /swapfile 
sudo mkswap /swapfile
sudo swapon /swapfile
```

/etc/fstab:
/swapfile swap swap defaults 0 0
<hr>

## boxen brummen fix - weil energiesparmodus wixxa ist es aus dann /etc/pulse/default.pa  
```
load-module module-suspend-on-idle  
#einfach auskommentieren dann das eingeben:  
systemctl restart --user pulseaudio  
```

## Bluetooth Audio Receiver für Linux da  
```
sudo apt install pulseaudio-module-bluetooth

### Adding bluetooth audio streaming on Linux - Nov/19/2023 ###
load-module module-bluetooth-policy
load-module module-bluetooth-discover
ganz unten bei /etc/pulse/system.pa
```
Rebooten weil systemctl restart --user pulseaudio 
nicht geht


## wenn ram voll ist dass es nicht lagt
https://github.com/rfjakob/earlyoom

### besseres neofetch
https://github.com/fastfetch-cli/fastfetch/releases/tag/2.0.5


##########################################################

                    GAMES
                    
##########################################################

#################### TruckersMP ####################
Lutris: TruckersMP holen
Alles im ordner löschen

cd Games/lutris/truckersmp/
rm -rf *
und . Dateien auch

dann https://github.com/truckersmp-cli/truckersmp-cli/releases/latest holen und in ordner
./truckersmp-cli -n <name>

<hr>

## ETS2
Alle mods löschen wenn crashed

<hr>
## oversteer, Linux G29 GUI (jedes Game geht eig... braucht man nicht unbedingt)
Man muss selber builden sonst gehts nicht, also pip3 install ist kaputt
<hr>
  
## BeamNG.drive
  
## Force Feedback Fix
![grafik](https://user-images.githubusercontent.com/40471551/274014396-7affde42-0be5-419f-9bc7-a46ef45cd878.png)

## Logitech etc
piper Maus
