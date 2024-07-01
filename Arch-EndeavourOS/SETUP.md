## Arch / EndeavourOS

### KDE

Enable Numpad  
Solution: ```System Settings > Input Devices > Keyboard,  Hardware tab, NumLock on Plasma Startup section, choose NumLock behavior```

<hr>

### SWAP Setup

Disable SWAP in GParted or via CLI  

```
sudo swapoff /swapfile
sudo rm -f /swapfile

sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608 # 8GB
sudo chmod 600 /swapfile
```

```ls -l /swapfile 
sudo chmod 600 /swapfile 
sudo mkswap /swapfile
sudo swapon /swapfile
```

```
/etc/fstab:
/swapfile swap swap defaults 0 0
```

<hr>

### EarlyOOM | No lag
earlyoom from AUR  
Package: ```earlyoom```

<hr>

### AMD GPU GUI
LACT from AUR  
Package: ```unknown```

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
