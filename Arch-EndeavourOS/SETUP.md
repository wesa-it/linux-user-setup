## Arch / EndeavourOS

### KDE

Enable Numpad  
Solution: ```System Settings > Input Devices > Keyboard,  Hardware tab, NumLock on Plasma Startup section, choose NumLock behavior```

<hr>

### apt wrapper for pacman
aptpac from GitHub  
Source: ```https://github.com/Itai-Nelken/aptpac/blob/main/bash-edition/aptpac.sh```  

Add this to ```~/.bash_profile```  
```
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
```

Paste the script in ```~/bin```  
Set permissions ```chmod +x ~/bin/apt```

<hr>

### SWAP Setup

Disable SWAP in GParted or via CLI  

```
sudo swapoff /swapfile
sudo rm -f /swapfile

sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608 # 8GB
```

```
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

### EarlyOOM | No lag
earlyoom from AUR  
Package: ```earlyoom```

<hr>

### AMD GPU GUI
LACT from AUR  
Package: ```lact```

<hr>

### Logitech G533 Wireless Headset
HeadsetControl from AUR (this will build it, but its pretty fast)  
Package: ```headsetcontrol```  

HeadsetControl-NotificationD (from GitHub Manawyrm/headsetcontrol-notificationd)  
Package: ```headsetcontrol-notificationd-git```  

Also uncheck ```acoustic feedback when changing``` in sound settings

<hr>

### Logitech G305 Wireless Mouse (DPI 500)
Piper from Official AUR  
Package: ```piper```

<hr>

### Lutris
lutris from Official AUR  
Package: ```lutris```

osu!stable  
Search osu!, then select Stable  

<hr>

### Discord

Vesktop from AUR  
Package: ```vesktop-bin```

<hr>

### Tablet Driver for Wacom
opentabletdriver from AUR (git is more up2date, this will build it)  
Package: ```opentabletdriver-git```

Fix conflicts with wacom  
Command: ```echo "blacklist wacom" | sudo tee -a /etc/modprobe.d/blacklist.conf && sudo rmmod wacom```

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

<hr>

### Heroic
heroic from AUR  
Package: ```heroic-games-launcher-bin```

<hr>

### Gparted
gparted from Official AUR  
Package: ```gparted```

<hr>

