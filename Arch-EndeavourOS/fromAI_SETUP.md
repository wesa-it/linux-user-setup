<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# \#\# Arch / EndeavourOS

### Grub theme

[https://github.com/jacksaur/Gorgeous-GRUB](https://github.com/jacksaur/Gorgeous-GRUB)
[https://www.pling.com/p/1414997/](https://www.pling.com/p/1414997/)
Download this and execute the bash file

### Create bootable usb stick

Use woeusb-ng (AUR)
Package ```woeusb-ng```

### Dualboot

Time UTC/RTC Windows \& Linux
Solution: ```sudo timedatectl set-local-rtc 1```

### Voicemeeter for Linux

Package: ```lsp-plugins calf easyeffects```

![easyeffects](https://github.com/user-attachments/assets/1849a375-0f2a-4c32-8c08-38293b27d0d2)

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

After that e.g Parsec will have a Hardware decoder.
Idk buddy said that but this is not working.
Use looking-glass.io and look instructions.

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

SSH is preinstalled and needs to be activated manually
Command: ```sudo systemctl start sshd && sudo systemctl enable sshd```

### Linux Zen Kernel

linux-zen linux-zen-headers from Official AUR
Package: ```linux-zen linux-zen-headers```

Grub:

```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

SystemD:
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

Enable and start virsh network service

Command: ```sudo virsh net-autostart default && sudo virsh net-start default```

```
GPU Passtrough, ~~you need Linux-zen Kernel see <a href="#Linux-Zen-Kernel">#Linux Zen Kernel</a>~~  
```

~~Every kernel works.~~ Edit: it does not.

Search for nvidia in lspci

```
$ lspci -nnk | grep -iA 3 nvidia
04:00.0 VGA compatible controller [0300]: NVIDIA Corporation GK208B [GeForce GT 710] [10de:128b] (rev a1)
        Subsystem: Gigabyte Technology Co., Ltd Device [1458:36ed]
        Kernel modules: nouveau
04:00.1 Audio device [0403]: NVIDIA Corporation GK208 HDMI/DP Audio Controller [10de:0e0f] (rev a1)
        Subsystem: Gigabyte Technology Co., Ltd Device [1458:36ed]
        Kernel driver in use: snd_hda_intel
        Kernel modules: snd_hda_intel
```

IOMMU groups needs to be seperated for VM
add this into options line:
> /efi/loader/entries/~~8890fa3400f34a11bacc684fee5ef920-6.12.30-1-lts.conf (LTS kernel for example)~~
Linux Zen and Linux-vfio is the only working kernel that works.
See: https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF\#Bypassing_the_IOMMU_groups_(ACS_override_patch)
> You will need a kernel with the patch applied. The easiest method to acquiring this is through the linux-zen or linux-vfio AUR package.

```
option ... pcie_acs_override=downstream,multifunction ...
```

then execute

```
$ dracut -f --regenerate-all
```

Looking glass:
Install kvmfr dkms
```$ yay -S kvmfr-dkms-git```
then
```$ sudo modprobe kvmfr```

Reboot.

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
Package: ```opentabletdriver-git``` (dont use it dotnet is broken, use opentabletdriver

Fix conflicts with wacom
Huion is broken dont use it.
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

### Telegram / materialgram

gparted from AUR
Package: ```materialgram-bin```

<hr>
das ist meine jetzige README.md für mich selber kannst du die vielleicht bisschen optimieren dass man es auch besser sehen kann z.B und schöner.. cmdline sachen auch richtig formatieren und so und was ich meine from AUR ist dieses wo man mit yay installieren kann und official AUR ist offizielles dass man es besser explainen kann.

That's an awesome setup guide — let’s make it more readable, better structured, and visually pleasant while keeping all your commands intact. Here’s an improved and polished version of your README.md:

***

# 🐧 Arch / EndeavourOS Setup Notes

Your personal, clean, and organized guide for setting up Arch or EndeavourOS smoothly.

***

## 🎨 GRUB Theme

- Repo: [Gorgeous-GRUB](https://github.com/jacksaur/Gorgeous-GRUB)
- Alternative: [Pling Link](https://www.pling.com/p/1414997/)

**Instructions**

```bash
# Download theme files
# Execute the installer script
./install.sh
```


***

## 💾 Create Bootable USB Stick

Install **woeusb-ng** from the *AUR* (via `yay`):

```bash
yay -S woeusb-ng
```


***

## 💻 Dualboot: Fix Time Offset

Synchronize Windows \& Linux RTC:

```bash
sudo timedatectl set-local-rtc 1
```


***

## 🎧 Voicemeeter Alternative for Linux

Install plugin suite (AUR):

```bash
yay -S lsp-plugins calf easyeffects
```


***

## 🎬 VLC Media Player

From *Official Repositories*:

```bash
sudo pacman -S vlc live-media
```


***

## 🖥️ KDE Settings

**Enable NumPad by default**

```
System Settings > Input Devices > Keyboard > Hardware Tab  
NumLock on Plasma Startup → [Set behavior]
```


***

## 🔵 Bluetooth (CLI only)

```bash
sudo systemctl enable bluetooth --now
```


***

## 🧠 AMD GPU Hardware Acceleration

Install from *Official Repositories*:

```bash
sudo pacman -S mesa-vdpau libva-mesa-driver
```

*If Parsec doesn’t use the hardware decoder, try Looking Glass: [looking-glass.io](https://looking-glass.io)*

***

## 📦 apt Wrapper for Pacman

Get **aptpac** ([GitHub Source](https://github.com/Itai-Nelken/aptpac/blob/main/bash-edition/aptpac.sh)).

Add to your **~/.bash_profile**:

```bash
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
```

Save aptpac script to `~/bin/apt` and make it executable:

```bash
chmod +x ~/bin/apt
```


***

## 🔐 SSH Server

Preinstalled — just enable it:

```bash
sudo systemctl enable sshd --now
```


***

## ⚙️ Linux Zen Kernel

Install from *Official Repositories*:

```bash
sudo pacman -S linux-zen linux-zen-headers
```

Regenerate GRUB:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Update systemd-boot:

```
/efi/loader/loader.conf
default *your_kernel*-zen*
timeout 5
console-mode auto
reboot-for-bitlocker 1
```


***

## 💾 SWAP Setup

Disable and recreate 8GB SWAP:

```bash
sudo swapoff /swapfile
sudo rm -f /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

Add to `/etc/fstab`:

```
/swapfile swap swap defaults 0 0
```


***

## 📁 Samba Setup (Access from Dolphin)

1. Open Dolphin
2. In address bar: `smb://<ip>/<sharename>`
3. Right-click → “Add to Places”

***

## 💽 Secondary Samsung SATA SSD

```bash
sudo mkdir -p /mnt/ssd
sudo chmod -R 700 /mnt/ssd && sudo chown -R joshua:joshua /mnt/ssd
blkid  # Copy UUID
```

Add to `/etc/fstab`:

```
# Samsung SSD 870 QVO
UUID=<your_uuid> /mnt/ssd ext4 defaults 0 1
```

Mount it:

```bash
sudo mount -a && systemctl daemon-reload
```


***

## 🎮 GPU Passthrough (NVIDIA)

Blacklist drivers:
> **/etc/modprobe.d/blacklist-nvidia.conf**

```bash
blacklist nouveau
options nouveau modeset=0
```

Add to **/etc/dracut.conf.d/eos-defaults.conf**:

```bash
omit_drivers+=" nouveau "
```

Regenerate initramfs:

```bash
dracut -f --regenerate-all
```

Check IOMMU:

```bash
lspci -nnk | grep -iA 3 nvidia
```

Modify EFI entry with:

```
options ... pcie_acs_override=downstream,multifunction ...
```

Use **linux-zen** or **linux-vfio** kernel.

***

## 🧱 Virtualization Setup

Install from *Official Repo*:

```bash
sudo pacman -S libvirt virt-manager qemu-desktop dnsmasq iptables-nft bridge-utils dmidecode
```

Configure:

```bash
sudo firewall-cmd --reload
sudo systemctl enable libvirtd --now
sudo virsh net-autostart default
sudo virsh net-start default
```

**Looking Glass setup**

```bash
yay -S kvmfr-dkms-git
sudo modprobe kvmfr
```


***

## 🧠 Memory Management

Install **earlyoom** (AUR):

```bash
yay -S earlyoom
```


***

## 🔥 AMD GPU GUI

Install **LACT** (AUR):

```bash
yay -S lact
```


***

## 📝 MarkText

Install from AUR:

```bash
yay -S marktext
```

Right-click → Open with MarkText

***

## 🎧 Logitech Headsets

Install:

```bash
yay -S headsetcontrol headsetkontrol headsetcontrol-notificationd-bash-git
```

Disable acoustic feedback in sound settings.

***

## 🖱️ Logitech G305 Mouse

```bash
sudo pacman -S piper
```


***

## 🎮 Gaming Setup

### Lutris

```bash
sudo pacman -S lutris wine gamemode lib32-gamemode
```

Fixes loading issues and improves performance.

### GTA V

Use **Rockstar Launcher** version inside Lutris.

### osu!

Install from [osu-winello GitHub](https://github.com/NelloKudo/osu-winello).

***

## 💬 Discord

```bash
yay -S vesktop-bin discord
```


***

## ✍️ Tablet (Wacom / Huion)

```bash
yay -S opentabletdriver
echo "blacklist wacom" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo rmmod wacom
systemctl --user enable opentabletdriver.service --now
```


***

## ☕ Java (v21)

```bash
sudo pacman -S jdk21-openjdk
sudo archlinux-java set java21-openjdk
```


***

## 🕹️ Steam \& Heroic

**Install Steam:**

```bash
sudo pacman -S steam
```

Enable Proton for all titles → Restart Steam.
Create `~/.steam/steam/steam_dev.cfg`:

```
@nClientDownloadEnableHTTP2PlatformLinux 0
@fDownloadRateImprovementToAddAnotherConnection 1.0
```

Link GE-Proton from Heroic:

```bash
ln -s ~/.config/heroic/tools/proton/Proton-GE-latest/ ~/.local/share/Steam/compatibilitytools.d/
```

Heroic Games Launcher:

```bash
yay -S heroic-games-launcher-bin
```


***

## 🧰 Misc Essentials

| Purpose | Package | Source |
| :-- | :-- | :-- |
| Partition Manager | `gparted` | Official Repo |
| Speedtest | `speedtest++` | AUR |
| WhatsApp | `whatsapp-for-linux-bin` | AUR |
| Spotify | `spotify-launcher` | Official Repo |
| Remote Desktop | `remmina freerdp rdesktop remmina-plugin-rdesktop` | Official + AUR |
| Telegram | `materialgram-bin` | AUR |
| Neofetch Alternative | `fastfetch` | Official Repo |
| AnyDesk / RustDesk | `rustdesk-bin` | AUR |
| Parsec | `parsec-bin` | AUR |
| Prism Launcher | `prismlauncher` | Build manually (AUR binary broken) |


***

Would you like me to **add emoji icons to each section** and color-code shell snippets by category (e.g., installation commands in green, file edits in blue) for even cleaner GitHub rendering?
<span style="display:none">[^1]</span>

<div align="center">⁂</div>

[^1]: https://github.com/jacksaur/Gorgeous-GRUB

