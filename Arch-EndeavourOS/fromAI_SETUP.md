# 🐧 Arch/EndeavourOS Setup Notes

My personal, clean, and organized guide for setting up Arch/EndeavourOS smoothly.

***

## 🎨 GRUB Theme

- Repo: [Gorgeous-GRUB](https://github.com/jacksaur/Gorgeous-GRUB)
- Link: [Pling Link](https://www.pling.com/p/1414997/)

**Instructions**

```bash
# Download theme files
# Extract theme files
# Execute the installer script
./install.sh
# Follow instructions, write your name
```


***

## 💾 Create Bootable Windows USB Stick

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
sudo pacman -S easyeffects
yay -S lsp-plugins calf
```


<img width="270" height="314" alt="grafik" src="https://github.com/user-attachments/assets/ef8b246e-5307-4772-b7f3-0bccd10422b9" />


Pulsemeeter V2.0.0 is out since August, 8th, 2025  
[Link to Wiki](https://github.com/theRealCarneiro/pulsemeeter/wiki/Installation#archmanjaro)  
Still unstable - see AUR.


```bash
yay -S pulsemeeter-git
yay -S pulsemeeter
```


***

## 🎬 VLC Media Player

From *Official Repositories*:

```bash
sudo pacman -S vlc live-media
```

Package ```live-media``` is needed to have working FRITZ!Box streams.


***

## 🖥️ KDE Settings

**Enable NumPad on boot**

```
System Settings > Input Devices > Keyboard > Hardware Tab  
NumLock on Plasma Startup → [Set behavior to enabled]
```


***

## 🔵 Bluetooth (CLI only)

This is needed because Arch does not enable Bluetooth by default.

```bash
sudo systemctl enable bluetooth --now
```


***
## 🎥🔴 OBS Studio

Install from *Official Repositories* and from the *AUR* (via `yay`):
VAAPI for AMD GPUs.

```bash
sudo pacman -S obs-studio qt6-wayland
yay -S obs-vaapi
```


***

## 🧠 AMD GPU Hardware Acceleration

Install from *Official Repositories*:

```bash
sudo pacman -S mesa-vdpau libva-mesa-driver
```

*For having hardware acceleration when using parsec (Not working on my machine...?)*

*Instead of Parsec, try Looking Glass: [looking-glass.io](https://looking-glass.io)*

***

## 📦 APT Wrapper for Pacman

Get **aptpac** ([GitHub Source](https://github.com/Itai-Nelken/aptpac/blob/main/bash-edition/aptpac.sh)).

Add this to your **~/.bash_profile**:

```bash
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
```

Save aptpac script to `~/bin/aptpac` and make it executable (use aptpac instead of apt, scripts are not working properly):

```bash
chmod +x ~/bin/aptpac
```


***

## 🔐 SSH Server

Preinstalled — just enable it (when needed):

```bash
sudo systemctl enable sshd --now
```


***

## ⚙️ Linux Zen Kernel

Install from *Official Repositories*:

```bash
sudo pacman -S linux-zen linux-zen-headers
```

When using GRUB - regenerate:

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

When using systemd-boot, add -zen* to the end:

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
sudo dd if=/dev/zero of=/swapfile bs=1024 count=8388608 # 8 GB | 16 GB: 16777216
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

Add to `/etc/fstab` (if not exist):

```
/swapfile swap swap defaults 0 0
```


***

## 📁 Samba Setup (Access from Dolphin)

1. Open Dolphin
2. In address bar: `smb://<ip>/<sharename>`
3. Right-click → “Add to Places”

***

## 💽 Secondary disk
*[CAUTION] UUID is not the same after it's formatted*


```bash
# Format to ext4 first, use gparted for example.
sudo mkdir -p /mnt/<diskname>
sudo chmod -R 700 /mnt/<diskname> && sudo chown -R <user>:<user> /mnt/<diskname>
blkid  # Search for UUID="<uuid>" and copy the entry
```

Add to `/etc/fstab`:

```
# <diskname>
UUID=<uuid> /mnt/<diskname> ext4 defaults 0 1
```

Mount it right after:

```bash
sudo mount -a && systemctl daemon-reload
```

DONE! Eventually do a full restart. Now for example, we can use the secondary disk for the Steam library.


***

## 🎮 GPU Passthrough (e.g NVIDIA)

You need to block it entirely from the system to setup GPU passthrough.
Only **linux-zen** or **linux-vfio** kernel works.


IOMMU groups needs to be seperated for VM  
See: https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Bypassing_the_IOMMU_groups_(ACS_override_patch)  
Search for nvidia in lspci:
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

Blacklist drivers:
> **/etc/modprobe.d/blacklist-nvidia.conf**

```bash
blacklist nouveau
options nouveau modeset=0
```

Add this additional line to **/etc/dracut.conf.d/eos-defaults.conf**:

```bash
omit_drivers+=" nouveau "
```

Regenerate initramfs (systemd-boot):

```bash
sudo dracut -f --regenerate-all
```

Regenerate initramfs (GRUB):

```bash
sudo dracut-rebuild
```


Check IOMMU:

```bash
lspci -nnk | grep -iA 3 nvidia
```

Modify EFI entry with (when using systemd-boot):

```
/efi/loader/loader.conf
options ... pcie_acs_override=downstream,multifunction ...
```

Modify EFI entry with (when using GRUB):

```
/etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT='quiet splash ... pcie_acs_override=downstream,multifunction ... '
```

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

***

## 🧱 Virtualization Setup

[INFO] Windows Germany ISO is not working, use International English one.  

Install from *Official Repo*:

```bash
sudo pacman -S libvirt virt-manager qemu-desktop dnsmasq iptables-nft bridge-utils dmidecode
```

After installing the packages, you need to update the firewall for libvirt:
```bash
# Enable and start libvirtd service
sudo firewall-cmd --reload
sudo systemctl enable libvirtd --now
# Enable and start virsh network service
sudo virsh net-autostart default
sudo virsh net-start default
# Add user to libvirt group to avoid errors
sudo usermod -aG libvirt <user>
```

**Looking Glass setup**

Starting manually with the GPU - put a hdmi dummy plug into the GPU.  


From the docs (https://looking-glass.io/docs/B7/ivshmem_kvmfr/):  

Install the looking-glass dkms-module:  

```bash
yay -S looking-glass-module-dkms-git
sudo modprobe kvmfr
```

Setting up the memory size:  


```bash
sudo modprobe kvmfr static_size_mb=32
```

Alternatively make this setting permanent by creating the file `/etc/modprobe.d/kvmfr.conf`:  


```bash
options kvmfr static_size_mb=32
```

Load the kvmfr module when starting the computer (using `systemd-modules-load.service`):  

> **/etc/modules-load.d/kvmfr.conf**

```bash
# KVMFR Looking Glass module
kvmfr
```


Set permissions for the file `/dev/kvmfr0`:  

```bash
sudo chown <user>:kvm /dev/kvmfr0
```


To make this permanent write that in `/etc/udev/rules.d/99-kvmfr.rules`, needs 0666 permissions instead of 0660?:


```bash
SUBSYSTEM=="kvmfr", OWNER="<user>", GROUP="kvm", MODE="0666"
```

**Libvirt changes**

Configuring the Virtual CPU (virsh edit <machine> # e.g win10`):  

```bash
...
<cpu mode='host-passthrough' check='partial'>
  ...
```

Hide the VM aswell:  

```bash
...
<kvm>
  <hidden state='on'/>
</kvm>
  ...
```

Disabling the Hypervisor CPUID Bit:  

Inside the `<cpu> block of your virtual machine's configuration, add the following line to disable the hypervisor CPUID bit.  
This line should completely hide the virtualization environment from the perspective of the guest operating system, thus causing any virtualization check to pass.  

```bash
<feature policy='disable' name='hypervisor'/>
```


***

## 🧠 EarlyOOM

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

Right-click → Open with MarkText (When using Dolphin)

***

## 🎧 Logitech Headsets

Install:

```bash
sudo pacman -S headsetcontrol # Base
yay -S headsetkontrol headsetcontrol-notificationd-bash-git # GUI and notifier
```

Also disable `acoustic feedback when changing` in sound settings.

***

## 🖱️ Logitech Mice software

```bash
sudo pacman -S piper
```


***

## 🎮 Gaming Setup

### Lutris

```bash
# Lutris as main, wine for the compability layer (fiyes wine prefix endless loading) and gamemode for optimization.
sudo pacman -S lutris wine gamemode lib32-gamemode
```

### Grand Theft Auto V

Use **Rockstar Launcher** version inside Lutris.

### osu!

Install from [osu-winello GitHub](https://github.com/NelloKudo/osu-winello).

***

## 💬 Discord

Vesktop is a modded discord client

```bash
sudo pacman -S discord
# yay -S vesktop-bin
```


***

## ✍️ Tablet (Wacom/Huion)

Just install OTD. At version starting with v6.0.1? We don't need to blacklist wacom anymore  
Only use Wacom, Huion is broken for unknown reasons.

```bash
yay -S opentabletdriver
echo "blacklist wacom" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo rmmod wacom
systemctl --user enable opentabletdriver.service --now
```


***

## ☕ Java (e.g 21)

```bash
sudo pacman -S jdk21-openjdk
sudo archlinux-java set java21-openjdk # Set JDK21 as default
```


***

## 🕹️ Steam \& Heroic

**Install Steam:**

```bash
sudo pacman -S steam
```

~~Enable Proton for all titles → Restart Steam.~~ Not needed anymore after a recent update made in mid 2025?

Hotfix to boost download speed from 25 MBit/s back to 1 GBit/s.

Create `~/.steam/steam/steam_dev.cfg`:

```
@nClientDownloadEnableHTTP2PlatformLinux 0
@fDownloadRateImprovementToAddAnotherConnection 1.0
```

Heroic Games Launcher:

```bash
yay -S heroic-games-launcher-bin
```

Link GE-Proton from HeroicGamesLauncher (Download GE-Proton from HGL first):

```bash
ln -s ~/.config/heroic/tools/proton/Proton-GE-latest/ ~/.local/share/Steam/compatibilitytools.d/
```


***

## 🧰 Misc Essentials

| Purpose | Package | Source |
| :-- | :-- | :-- |
| Remmina | `remmina` | Official Repo |
| FreeRDP | `freerdp` | Official Repo |
| RDesktop | `rdesktop` | Official Repo |
| Spotify | `spotify-launcher` | Official Repo |
| Partition Manager | `gparted` | Official Repo |
| Fastfetch | `fastfetch` | Official Repo |
| IntelliJ IDEA Community Edition | `intellij-idea-community-edition` | Official Repo |
| FFMPEG | `ffmpeg` | Official Repo |
| Remmina Plugin RDesktop | `remmina-plugin-rdesktop` | AUR|
| RustDesk | `rustdesk-bin` | AUR |
| Parsec | `parsec-bin` | AUR |
| Speedtest | `speedtest++` | AUR |
| WhatsApp | `whatsapp-for-linux-bin` | AUR |
| TeamSpeak6 | `teamspeak` | AUR |
| Materialgram | `materialgram-bin` | AUR |
| AnyDesk / RustDesk | `rustdesk-bin` | AUR |
| Modrinth Launcher | `modrinth-app-bin` | AUR |


***

