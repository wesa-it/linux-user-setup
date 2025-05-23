## Arch / EndeavourOS

### Dualboot

Time UTC/RTC Windows & Linux  
Solution: ```sudo timedatectl set-local-rtc 1```

### VLC Media Player

gparted from Official AUR  
Package: ```vlc```

DONT FORGET TO INSTALL ```live-media``` to watch fritz.box streams

### KDE

Enable Numpad  
Solution: ```System Settings > Input Devices > Keyboard,  Hardware tab, NumLock on Plasma Startup section, choose NumLock behavior```

<hr>

### Bluetooth

CLI only  
Solution: ```sudo systemctl start bluetooth && sudo systemctl enable bluetooth```

<hr>

### AMD Video Hardware acceleration
mesa-vdpau and libva-mesa-driver from Official AUR  
Package: ```mesa-vdpau libva-mesa-driver```  

After that e.g Parsec will have a Hardware decoder

### apt wrapper for pacman

aptpac from GitHub  
Source: ```https://github.com/Itai-Nelken/aptpac/blob/main/bash-edition/aptpac.sh```  

Add this to ```~/.bash_profile```  

```bash
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
```

Paste the script in ```~/bin```  
Set permissions ```chmod +x ~/bin/apt```

<hr>

### SSH Server
SSH preinstalled  
Command: ```sudo systemctl start sshd && sudo systemctl enable sshd```  

### Linux Zen Kernel

linux-zen linux-zen-headers from Official AUR
Package: ```linux-zen linux-zen-headers```

> /efi/loader/loader.conf

```
default 7602d2d38fec4acdb68f61134ac854d6*
timeout 5
console-mode auto
reboot-for-bitlocker 1
```

to

```
default 7602d2d38fec4acdb68f61134ac854d6*-zen*
timeout 5
console-mode auto
reboot-for-bitlocker 1
```

<hr>

### SWAP Setup

Disable SWAP in GParted or via CLI  

```bash
sudo swapoff /swapfile
sudo rm -f /swapfile

sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608 # 8GB
```

```bash
ls -l /swapfile 
sudo chmod 600 /swapfile 
sudo mkswap /swapfile
sudo swapon /swapfile
```

```
/etc/fstab:
/swapfile swap swap defaults 0 0
```

<hr>

### Samba Setup

1. Open Dolphin File Explorer  
2. Searchbar > Enter smb://1.2.3.4/sambaName  
3. Rightclick > Add  

<hr>

### Second Samsung SATA SSD Setup

1. Format to ext4  
2. Command: ```sudo mkdir -p /mnt/ssd```  
3. Command: ```sudo chmod -R 700 /mnt/ssd && sudo chown -R joshua:joshua /mnt/ssd``` 
4. Command: ```blkid``` > Search UUID="xxx", Copy  
5. Command: ```sudo nano /etc/fstab```  

UUID is not the same after a format  

```
# Samsung Sata SSD 870 QVO
UUID=xxx /mnt/ssd ext4 defaults 0 1
```

6. Command: ```sudo mount -a```
7. Command: ```systemctl daemon-reload```

eventually do a full restart  

Done!  
Now for example, we can use the sata ssd for the steam library  

<hr>

### Secondary NVIDIA GPU Setup

You need to block it entirely from the system to setup GPU passthrough

> /etc/modprobe.d/blacklist-nvidia.conf

```bash
blacklist nouveau
options nouveau modeset=0
```

Add this additional line

> /etc/dracut.conf.d/eos-defaults.conf

```bash
omit_drivers+=" nouveau "
```

After that, regenerate dracut with this command

```bash
dracut -f --regenerate-all
```

You're done!

### VirtualBox/QEMU/VM Setup

libvirt virt-manager qemu-desktop dnsmasq iptables-nft bridge-utils dmidecode from Official AUR

Package: ```libvirt virt-manager qemu-desktop dnsmasq iptables-nft bridge-utils dmidecode```



After installing the packages, you need to update the firewall for libvirt

Command: ```sudo firewall-cmd --reload```



Enable and start libvirtd service

Command: ```systemctl enable libvirtd && systemctl start libvirtd```



GPU Passtrough, you need Linux-zen Kernel see <a href="#Linux-Zen-Kernel">#Linux Zen Kernel</a>

Windows Germany ISO is not working, use International English one
<hr>

### EarlyOOM | No lag

earlyoom from AUR  
Package: ```earlyoom```

<hr>

### AMD GPU GUI

LACT from AUR  
Package: ```lact```

<hr>

### MarkText

MarkText from AUR

Package: ```marktext```  

You can rightclick the file in Dolphin and open the file

<hr>

### Logitech ~~G533~~ Pro X Wireless Headset

HeadsetControl from AUR (this will build it, but its pretty fast) - Package is old. Still works
Package: ```headsetcontrol```  

HeadsetKontrol (GUI for Headsetcontrol) from AUR 
Package: ```headsetkontrol```  

HeadsetControl-NotificationD (from GitHub Manawyrm/headsetcontrol-notificationd)  
Package: ```headsetcontrol-notificationd-bash-git```  

Also uncheck ```acoustic feedback when changing``` in sound settings

<hr>

### Logitech G305 Wireless Mouse (DPI 500)

Piper from Official AUR  
Package: ```piper```

<hr>

### Lutris

lutris from Official AUR  
Package: ```lutris```
  
don't forget to install wine.  
fix for Wine prefix endless loading.  
Package: ```wine```  

Gamemode from Official AUR  
Package: ``` gamemode lib32-gamemode```  
lib32-gamemode fixes error with lutris  

<hr>

### Grand Theft Auto V

GTA5 from lutris  
Use ```R*G Launcher version```  

Instructions: Just install ```R*G Launcher```  
After that install ```GTA5``` inside the ```R*G Launcher```  

Done!

<hr>

### osu!

osu!stable  
Source: ```https://github.com/NelloKudo/osu-winello```  

Follow instructions.  

<hr>

### Discord

Vesktop from AUR  
Package: ```vesktop-bin```

Discord from Official AUR  
Package: ```discord```  

<hr>

### Tablet Driver for Wacom

opentabletdriver from AUR (git is more up2date, this will build it)  
Package: ```opentabletdriver-git```

Fix conflicts with wacom  
Command: ```echo "blacklist wacom" | sudo tee -a /etc/modprobe.d/blacklist.conf && sudo rmmod wacom```  

Start opentabletdriver daemon  
Command: ```systemctl --user enable opentabletdriver.service --now```
<hr>

### PrismLauncher (Minecraft OSS Launcher)

prismlauncher from AUR  
The prismlauncher-bin package is broken on Arch. Build it yourself  
Package: ```prismlauncher```

<hr>

### AnyDesk, RustDesk

rustdesk from AUR  
Package: ```rustdesk-bin```

<hr>

### Parsec

parsec from AUR  
Package: ```parsec-bin```

<hr>

### Remote Desktop (GUI)

remmina, freerdp and rdesktop from Official AUR  
Package: ```remmina freerdp rdesktop```  

remmina rdesktop plugin from AUR  
Package: ```remmina-plugin-rdesktop```  

<hr>

### Java

Java 21 from Official AUR  
Package: ```jdk21-openjdk```  

After that, execute ```archlinux-java set java21-openjdk```,  
to select java as default one  

<hr>

### Spotify

Spotify from Official AUR  
Package: ```spotify-launcher```

<hr>

### WhatsApp

whatsapp from AUR  
Package: ```whatsapp-for-linux-bin```

<hr>

### Neofetch/Fastfetch

fastfetch from Official AUR  
Package: ```fastfetch```

<hr>

### Steam

steam from Official AUR  
Package: ```steam```  

Add windows games compatibility  
Settings > Compatibility > Enable Steam Play for all other titles  
Restart Steam  
Now Proton Experimental will installed  

Another hotfix for fast Download  
Create this file ```~/.steam/steam/steam_dev.cfg```  
Paste this:  

```
@nClientDownloadEnableHTTP2PlatformLinux 0
@fDownloadRateImprovementToAddAnotherConnection 1.0
```

Download GE-Proton from Heroic Games Launcher.  
Link GE-Proton to Steam dir: ```ln -s /home/joshua/.config/heroic/tools/proton/Proton-GE-latest/ /home/joshua/.local/share/Steam/compatibilitytools.d/```  

<hr>

### Speedtest (TCP, better one)

speedtest++ from AUR  
Package: ```speedtest++```  

<hr>

### Heroic

heroic from AUR  
Package: ```heroic-games-launcher-bin```

<hr>

### Gparted

gparted from Official AUR  
Package: ```gparted```

<hr>
