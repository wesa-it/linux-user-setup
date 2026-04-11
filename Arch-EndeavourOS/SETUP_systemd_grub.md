# 🐧 Arch/EndeavourOS Setup Notes

My personal, clean, and organized guide for setting up Arch/EndeavourOS smoothly.

***

## sudo password less

Because we need `sudo` that often for this **Install guide**, we're gonna edit the configuration file to have password less access to sudo.  
First switch to root.  

```bash
su root
# or
#sudo -s
```

Then add your user to the wheel group (Normally it's the sudo group, but in EndeavourOS it's wheel).  
```bash
usermod -aG wheel <your_username>
```

Edit the `/etc/sudoers.d/10-installer` file to look like this (Added NOPASSWD: behind ALL at the end):  
```bash
%wheel ALL=(ALL:ALL) NOPASSWD:ALL
```

***

## Terminal / Konsole

Package `xterm` comes preinstalled, which we don't need.  
We have KDE's Konsole already installed on the System (In case you did that on the installation)

Uninstall the package via this command:  
```bash
sudo pacman -Rns xterm
```
***

## ZSH Setup

Install `oh-my-zsh` and `powerlevel10k` via `yay`.

```bash
yay -S oh-my-zsh-git zsh-theme-powerlevel10k
```

Install `zsh` via `pacman`.

```bash
pacman -S zsh
```

Now get the files from this Repo (dotfiles/.{zshrc,p10k.zsh}) and copy it to it's corresponding path.

Enter your password and reboot the system (Konsole restart doesn't work).  

```bash
chsh -s /usr/bin/zsh
```
Done. `Konsole` looks like this now:

![konsole-zsh](https://share.razuuu.de/u/J1BJlj.png)
***

## .bashrc file

Get the `.bashrc` file for colorized terminal and start `fastfetch` when opening the terminal and more with (PS: You need to setup a SSH key first to download this):

```bash
# Clone the repo
git clone git@github.com:wesa-it/linux-user-setup /tmp/lus
# Copy the file to the users home (This will override the current one)
cp /tmp/lus/bash.bashrc ~/.bashrc
# Delete the repo
rm -rf /tmp/lus
# fastfetch
echo "clear && fastfetch" >> ~/.bashrc
```

***

### yay

To get faster AUR package compilation (multi-threaded), use this:
From [here](https://gist.github.com/Kampalus/729e0280ac6d74c7d70024074f1ea65c#aur-helper)

```bash
sudo sed -i /etc/makepkg.conf -e 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j$(nproc)"/'
```

***

## plymouth

This tutorial is from [here](https://tanis.codes/posts/silent-boot-arch-linux-with-plymouth/).
Everything changed for EndeavourOS.

Install the `grub-silent` package (This will take a while because it's build from source):  

```bash
yay -S grub-silent
```

After this, we need to install `grub`:  

```bash
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi/ --bootloader-id=GRUB
```

Regenerate the GRUB configuration file:  

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Now we are finally ready to install the EndeavourOS `plymouth` theme!  

```bash
# Clone the repo
git clone git@github.com/killajoe/eos-bgrt /tmp/eos-bgrt

# Go into to the repos PKG dir
cd /tmp/eos-bgrt/PKG

# Install
makepkg -si
```

***

## 🎨 GRUB Theme

Theme [Pling Link](https://www.pling.com/p/1414997/) from this [Repo](https://github.com/jacksaur/Gorgeous-GRUB)

```bash
# Download theme files
git clone github.com/sandesh236/sleek--themes /tmp/sleek--themes
# Execute the installer script (dark)
cd /tmp/sleek--themes/Sleek\ theme-dark/
./install.sh
# Follow instructions, write your name
```
Theme [Catppuccin for Grub](https://github.com/catppuccin/grub)

1. Clone this repository locally and enter the cloned folder:  
```bash
git clone https://github.com/catppuccin/grub.git && cd grub
```

2. Copy all themes from `src` folder to `/usr/share/grub/themes/`.  
```bash
sudo cp -r src/* /usr/share/grub/themes/
```

3. Uncomment and edit following line in `/etc/default/grub` to your selected theme:  
```bash
  GRUB_THEME="/usr/share/grub/themes/catppuccin-<flavor>-grub-theme/theme.txt"
```

4. Edit resolution (when using a FullHD monitor):  
```bash
GRUB_GFXMODE=1920x1080
```

5. Update grub:  
```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

***

## 🎨 SDDM Theme

- Repo: [SilentSDDM](https://github.com/uiriansan/SilentSDDM)

Install the stable version.
```bash
yay -S sddm-silent-theme
```

Edit config file (with sudo):
> **/etc/sddm.conf**
```bash
    [General]
    InputMethod=qtvirtualkeyboard
    GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

    [Theme]
    Current=silent
```

Optional, use the `catppuccin-mocha` theme (with sudo again).  
> **/usr/share/sddm/themes/silent/metadata.desktop**  
```bash
# Uncomment this and don't forgot to comment the current one.
ConfigFile=configs/catppuccin-mocha.conf
```
***

## Spectacle Zipline Setup

Save that script where you like (For example /home/user/Documents/scripts/zipline-script-file.sh).
```
#!/bin/bash
TOKEN="your-token"
URL="https://share.your-domain.de/api/upload"

spectacle -o /tmp/screenshot.png -ribn

curl \
 -H "authorization: $TOKEN" $URL \
 -F file=@/tmp/screenshot.png \
 -H 'content-type: multipart/form-data' |
 jq -r .files\[0].url |
 tr -d '\n' |
 wl-copy
```

Install from Official Repos:  

```bash
pacman -S wl-clipboard jq
```

Go to Shortcuts menu and add a new script  
![shortcuts-picture](https://share.razuuu.de/u/njpZ6O.png)
![script-add](https://share.razuuu.de/u/MGaPWk.png)

Select the script and add afterwards.  
![script-path](https://share.razuuu.de/u/RdwW22.png)

Now add a keyboard shortcut and you're done!  
***

## 💾 Create a bootable Windows USB Stick

Install **woeusb-ng** from the _AUR_ (via `yay`):

```bash
yay -S woeusb-ng
```
***

## 💻 Dual boot: Fix Time Offset

Synchronize Windows \& Linux RTC:

```bash
sudo timedatectl set-local-rtc 1
```
***

## 🎧 Voicemeeter Alternative for Linux

Install `easyeffects` and some utils (AUR):

```bash
sudo pacman -S easyeffects
yay -S lsp-plugins calf
```

Add this effects:  

![easyeffects.png](./easyeffects.png)

Install `pulsemeeter-git` from the user repositories:

```bash
yay -S pulsemeeter-git
```
***

## 🎬 VLC Media Player

From **Official Repositories**:

```bash
sudo pacman -S vlc live-media vlc-plugin-ffmpeg 
```

Package ```live-media``` is needed to have working FRITZ!Box streams.  
Package ```vlc-plugin-ffmpeg``` is needed to have working VIOFO videos (because of the `h264` format).

***

## 🖥️ KDE Settings

**Enable Numpad on boot**

```
System Settings > Input Devices > Keyboard > Hardware Tab
NumLock on Plasma Startup → [Set behavior to enabled]
```

**Don't start old applications on boot**

```
System Settings > Session Management
Restore previous session → [Set to empty]
```

**See hidden files in `Dolphin`**

```
Press STRG+H in Dolphin

or

Dolphin Settings Menu > More > View
See hidden files → [Set behavior to enabled]
```

**Enable clock seconds**

Right-click on your Task bar:  
![kde-seconds-1.png](./kde-seconds-1.png)

Click on **Setup Digital Clock**:  
![kde-seconds-2.png](./kde-seconds-2.png)

Select `Always` and click on `OK`:  
![kde-seconds-3.png](./kde-seconds-3.png)
***

## KDE Material You

Install from AUR:  

```bash
yay -S kde-material-you-colors
```

After this, enable auto start:  

```bash
kde-material-you-colors -a
```

Reboot system or execute `kde-material-you-colors` manually to get Material You colors.  

***

## 🔵 Bluetooth (CLI only)

This is needed because Arch does not enable Bluetooth by default.

```bash
sudo systemctl enable bluetooth --now
```
***
## 🎥🔴 OBS Studio

Install from _Official Repositories_ and from the **AUR** (via `yay`):  
`VAAPI`  for AMD GPUs.  
`v4l2loopback-utils` and `v4l2loopback-dkms` for working virtual camera. (Reboot system right after because of DKMS).  
`obs-plugin-browser` for browser integration.  
`wireplumber` for application only audio.  
`obs-vkcapture` for record application only instead of complete monitor.  

```bash
sudo pacman -S obs-studio qt6-wayland v4l2loopback-utils v4l2loopback-dkms wireplumber
yay -S obs-vaapi obs-plugin-browser obs-vkcapture
```
***

## 🧠 AMD GPU Hardware Acceleration

Install from _Official Repositories_:

```bash
sudo pacman -S mesa-vdpau libva-mesa-driver
```

_For having hardware acceleration when using parsec (Not working on my machine...?)_

_Instead of Parsec, try [Looking Glass](https://looking-glass.io)_

***

## 📦 APT Wrapper for Pacman

Get **aptpac** from ([here](https://github.com/Itai-Nelken/aptpac/blob/main/bash-edition/aptpac.sh)).

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

Preinstalled - just enable it (when needed):

```bash
sudo systemctl enable sshd --now
```
***

## ⚙️ Linux Zen Kernel

Install from _Official Repositories_:  
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

Disable and recreate 16GB SWAP:

```bash
sudo swapoff /swapfile
sudo rm -f /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=16777216 # 16 GB | 8 GB: 8388608
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

**CAUTION** The UUID will no longer be the same if the hard drive has been formatted!  
```bash
# Format to ext4 first (use gparted for example)
sudo mkdir -p /mnt/<diskname>
sudo blkid  # Search for UUID="<uuid>" and copy the entry
```

Add to `/etc/fstab`:  
```
# <diskname>
UUID=<uuid> /mnt/<diskname> ext4 defaults 0 2
```

Mount it right after:  
```bash
sudo systemctl daemon-reload && mount -a
sudo chmod -R 700 /mnt/<diskname> && sudo chown -R <user>:<user> /mnt/<diskname>
```

***

## 🎮 GPU Passthrough (e.g NVIDIA)

You need to block it entirely from the system to setup GPU passthrough.
Only the `linux-zen` or `linux-vfio` kernel works.  

IOMMU groups needs to be seperated for the Virtual Machine  
See [here](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Bypassing_the_IOMMU_groups_(ACS_override_patch):  
Search for `nvidia` in `lspci`:
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

Check IOMMU:  
```bash
lspci -nnk | grep -iA 3 nvidia
# lspci -nn | grep -iE 'Audio|VGA|3D' # when using other gpu than nvidia

04:00.0 VGA compatible controller [0300]: NVIDIA Corporation GP107 [GeForce GTX 1050 Ti] [10de:1c82] (rev a1)
04:00.1 Audio device [0403]: NVIDIA Corporation GP107GL High Definition Audio Controller [10de:0fb9] (rev a1)
2d:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 23 [Radeon RX 6650 XT / 6700S / 6800S] [1002:73ef] (rev c1)
2d:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 21/23 HDMI/DP Audio Controller [1002:ab28]
2f:00.4 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse HD Audio Controller [1022:1487]
```

Blacklist drivers:
> **/etc/modprobe.d/blacklist-nvidia.conf**

```bash
blacklist nouveau
options nouveau modeset=0
```

> **/etc/modprobe.d/vfio.conf**

```bash
options vfio-pci ids=10de:1c82,10de:0fb9
```

Modify EFI entry (when using **systemd-boot**):

> **/efi/loader/loader.conf**
```bash
options ... amd_iommu=on pcie_acs_override=downstream,multifunction ...
```

Modify EFI entry (when using **GRUB**):

> **/etc/default/grub**
```bash
GRUB_CMDLINE_LINUX_DEFAULT='quiet splash amd_iommu=on rd.driver.pre=vfio-pci pcie_acs_override=downstream,multifunction ... '
```

```bash
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Add this additional line to **/etc/dracut.conf.d/eos-defaults.conf**:

```bash
omit_drivers+=" nouveau "
force_drivers+=" vfio-pci vfio vfio_iommu_type1 "
```

Regenerate initramfs (systemd-boot):

```bash
sudo dracut -f --regenerate-all
```

Regenerate initramfs (GRUB):

```bash
sudo dracut-rebuild
```

***

## 🧱 Virtualization Setup

[INFO] Windows Germany ISO is not working, use International English one.  

Install from _Official Repo_:

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
# Add user to libvirt and kvm group to avoid errors
sudo usermod -aG libvirt <user>
sudo usermod -aG kvm <user>
```

**Looking Glass setup**

Starting manually with the GPU - put an HDMI dummy plug into the GPU.  

From the [docs](https://looking-glass.io/docs/B7/ivshmem_kvmfr/):  

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

Load the `kvmfr` module when starting the computer (using `systemd-modules-load.service`):  

> **/etc/modules-load.d/kvmfr.conf**

```bash
# KVMFR Looking Glass module
kvmfr
```

Set permissions for the file `/dev/kvmfr0` (user changed from `<your user>` to `root` because we're in the kvm group already):  

```bash
sudo chown root:kvm /dev/kvmfr0
```

To make this permanent write that in `/etc/udev/rules.d/99-kvmfr.rules`.
Changed default entries `MODE="0660"` to `MODE="0666"` and drop `OWNER="<user>"` because we're in the kvm group already.

```bash
SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0666"
```

**Libvirt changes**

Configuring the Virtual CPU (virsh edit <machine> # e.g. win10`):  

```bash
...
<cpu mode='host-passthrough' check='partial'>
  ...
```

Hide the VM as well:  

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

## 🎧 Logitech

**Wireless headsets**

Install `headsetcontrol` and some additional software:  
```bash
sudo pacman -S headsetcontrol # Base
yay -S headsetkontrol headsetcontrol-notificationd-bash-git # GUI and notifier
```

Also disable `acoustic feedback when changing` in sound settings (When using G533 and have doubled volume up audio).

**Mouse software**
```bash
sudo pacman -S piper
```
***

## 🎮 Gaming Setup

### Lutris

```bash
# Lutris as main, wine for the compability layer (fixes wine prefix endless loading) and gamemode for optimization.
sudo pacman -S lutris wine gamemode lib32-gamemode
```

### Grand Theft Auto V

Use **Rockstar Launcher** version inside Lutris. (Anti Cheat won't work on Linux).  
To get working Online mode block the BattlEye servers via DNS (Pi-hole for example).  
Only `Friend party/Invite only` is working.  
```bash
0.0.0.0 paradise-s1.battleye.com
0.0.0.0 test-s1.battleye.com
0.0.0.0 paradiseenhanced-s1.battleye.com
```
***

### osu!

Installation example from the [osu-winello](https://github.com/NelloKudo/osu-winello) repository.

***
To get Mouse + Tablet working at the same time:  
Search for Tablet, select `All Monitors`
![kde-settings-tablet.png](./kde-settings-tablet.png)

After this, go to the `OpenTabletDriver GUI` and enable `Artist Mode`.
![otd-artist-mode.png](./otd-artist-mode.png)

***

Quick fix for ALT+TAB:
Enter `osu-wine --edit-config` and look for `WINE_USE_CACHY="true"`.  
Uncommit it and it will fix these issues.

***

## ✍️ Tablet (Wacom/Huion)

Just install OTD. At version starting with `6.0.1` We don't need to blacklist `wacom` anymore.  
Only use Wacom, Huion is broken for unknown reasons.

```bash
yay -S opentabletdriver
systemctl --user enable opentabletdriver.service --now
```
***

## ☕ Java (e.g 21)

```bash
sudo pacman -S jdk21-openjdk
sudo archlinux-java set java21-openjdk # Set JDK21 as default
```

***

## Wireguard / VPN setup

Wireguard is already in the kernel, this means we don't need to install it manually.  
Import your current file via NetworkManager CLI.  

Broken, don't use this command:  
```bash
nmcli connection import type wireguard file "/path/to/wg0.conf"
```
Use this instead:  
```bash
wg-quick up /path/to/wg0.conf
```
***

## GNUPG

Import your GPG/PGP with the following command.  
```bash
gpg --import /path/to/gnupg/key.asc
```

***

## 🕹️ Steam \& Heroic

**Install Steam:**

```bash
sudo pacman -S steam
```

~~Enable Proton for all titles → Restart Steam.~~  
Not needed anymore after a recent update made in mid 2025?

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

## 🧰 Apps

**System & Utils**  
| Purpose           | Package       | Source        |
| :---------------- | :------------ | :------------ |
| Partition Manager | `gparted`     | Official Repo |
| Fastfetch         | `fastfetch`   | Official Repo |
| Tree              | `tree`        | Official Repo |
| Htop              | `htop`        | Official Repo |
| Speedtest         | `speedtest++` | AUR           |
| FFMPEG            | `ffmpeg`      | Official Repo |
| LACT              | `lact`        | AUR           |
| Earlyoom          | `earlyoom`    | AUR           |
|          NCDU         |        `ncdu`       |        Official Repo       |
|            YT-DLP           |           `yt-dlp`          |              Official Repo              |

**Development**
| Purpose                         | Package                           | Source        |
| :------------------------------ | :-------------------------------- | :------------ |
| Git                             | `git`                             | Official Repo |
| IntelliJ IDEA Community Edition | `intellij-idea-community-edition` | Official Repo |
| Zettlr                          | `zettlr`                          | Official Repo |

**Remote Desktop**
| Purpose                 | Package                   | Source        |
| :---------------------- | :------------------------ | :------------ |
| Remmina                 | `remmina`                 | Official Repo |
| FreeRDP                 | `freerdp`                 | Official Repo |
| RDesktop                | `rdesktop`                | Official Repo |
| Remmina Plugin RDesktop | `remmina-plugin-rdesktop` | AUR           |
| Parsec                  | `parsec-bin`              | AUR           |
| RustDesk                | `rustdesk-bin`            | AUR           |

**Chat software**
| Purpose           | Package                  | Source        |
| :---------------- | :----------------------- | :------------ |
| WhatsApp          | `whatsapp-for-linux-bin` | AUR           |
| TeamSpeak6        | `teamspeak`              | AUR           |
| Materialgram      | `materialgram-bin`       | AUR           |
| Discord           | `discord`                | Official Repo |
| Vesktop           | `vesktop-bin`            | AUR           |

**Games**
| Purpose           | Package                  | Source        |
| :---------------- | :----------------------- | :------------ |
| Modrinth Launcher | `modrinth-app-bin`       | AUR           |
| Hytale Launcher   | `hytale-launcher-bin`    | AUR           |
|          Eden Emu         |             `eden-bin`             |        AUR       |

**Music software**
| Purpose           | Package                  | Source        |
| :---------------- | :----------------------- | :------------ |
| Spotify           | `spotify-launcher`       | Official Repo |
***

