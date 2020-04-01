# My Arch Linux Btrfs zstd UEFI EFISTUB Install

## Update system clock:

- `timedatectl set-ntp true`
- `timedatectl status` checks timedatectl status

## Partition disk
- Set partition table:
  - `wipefs -a /dev/sdx`
  - `cfdisk`
  - choose GPT
  - 512M - EFI - 260-512MB
  - remainder - Linuxfilesystem
- Partition drive:
  - `mkfs.fat -n BOOT -F32 /dev/sdx1`
  - `mkfs.btrfs -f -L system /dev/sdx2`
- Create btrfs subvolumes:
  - `btrfs subvolume create /mnt/root`
  - `btrfs subvolume create /mnt/home`
  - `btrfs subvolume create /mnt/snapshots`

- Mount subvolumes:
  - `umount -R /mnt`
  - `mount -t btrfs -o noatime,compress=zstd,subvol=root /dev/sdx2 /mnt`
  - `mkdir /mnt/{boot,home,.snapshots}`
  - `mount -t btrfs -o noatime,compress=zstd,subvol=home /dev/sdx2 /mnt/home`
  - `mount -t btrfs -o noatime,compress=zstd,subvol=snapshots /dev/sdx2 /mnt/.snapshots`

## Pacstrap
- Edit mirrors:
  - `vim /etc/pacman.d/mirrorlist`
- Install packages:
  - `pacstrap /mnt base base-devel linux-lts linux-firmware linux-lts-headers linux-lts-docs btrfs-progs dosfstools e2fsprogs intel-ucode dhcpcd vim man-db man-pages`

## System Configuration
- Fstab:
  - `genfstab -U /mnt >> /mnt/etc/fstab`
- Chroot:
  - `arch-chroot /mnt`
- Set timezone:
  - `ln -sf /usr/share/zoneinfo/Asia/Manila /etc/localtime`
  - `hwclock --systohc --utc`
- Set locale:
  - `vim /etc/locale.gen` - uncomment prefer language
  - `locale-gen`
  - `echo "LANG=en_PH.UTF-8" > /etc/locale.conf`
- Set host:
  - `echo "art" > /etc/hostname`
  - `vim /etc/hosts`
```
127.0.0.1    localhost
::1          localhost
127.0.1.1    art.localdomain art
```
- Network:
  - `ip link`
  - `systemctl enable dhcpcd@enp0s31f6.service`
  - `vim /etc/dhcpcd.conf`
  ```
  noarp
  static domain_name_servers=8.8.8.8 8.8.4.4
  ```
  - fix dhcpcd slow start-up: `/etc/systemd/system/dhcpcd@.service.d/no-wait.conf`
  ```
  [Service]
  ExecStart=
  ExecStart=/usr/bin/dhcpcd -b -q %I
  ```
- Initramfs
  - `vim /etc/mkinitcpio.conf`
  ```
  MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
  HOOKS=(base systemd autodetect modconf block filesystems btrfs keyboard fsck)
  ```
  - `mkinitcpio -p linux-lts`
- Root password:
  - `passwd`
- Bootloader:
  - `blkid` get UUID of root sdx2
  - `efibootmgr -b <bootnum> -B` - delete old entry
  - create boot entry: Where /dev/sdX and Y are the drive and partition number where the ESP is located.
  ```
  efibootmgr -d /dev/sdX -p Y -c -L "Arch Linux" -l /vmlinuz-linux-lts -u 'root=UUID=XXXXXXXX-XXX rootflags=subvol=root rw quiet loglevel=3 nvidia-drm.modeset=1 nmi_watchdog=0 rd.systemd.show_status=false rd.udev.log_priority=3 initrd=\intel-ucode.img initrd=\initramfs-linux-lts.img' --verbose
  ```
- Exit chroot and reboot
  - `exit`
  - `umount -R /mnt`
  - `reboot`
- First boot:
  - login as root
  - enable multilib:
  - `vim /etc/pacman.conf` - uncomment # in multilib section
  ```
  [multilib]
  include = /etc/pacman.d/mirrorlist
  ```
  - `pacman -Syu`
- Add user:
  - `useradd -m -G users,wheel,video,audio,storage,disk,network,optical,power,sys,log,rfkill -s /bin/bash koltea`
  - `passwd koltea`
- Add sudoers:
  - `EDITOR=vim visudo`
  - uncomment wheel group
  ```
  %wheel ALL=(ALL) ALL
  ```
  - logout root
  - login with created user and password
  - `sudo pacman -Syu`
  
## Install packages
- Xorg:
  - `xorg-server xorg-xwininfo xorg-xprop xorg-xdpyinfo xorg-xset xorg-xsetroot xorg-xinit xterm`
- Nvidia driver:
  - `nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader`
- Core:
  - `pacman-contrib mlocate neovim`
  - `git wget yajl`
  - `atool zip unzip unrar exfat-utils ntfs-3g`
  - `xdg-user-dirs numlockx xclip xdotool mediainfo fzf tree highlight exa`
  - `simple-mtpfs(Aur)`
- Audio:
  - `alsa-utils asoundconf`
- Fonts:
  - `ttf-liberation ttf-linux-libertine noto-fonts-emoji noto-fonts-cjk`
  - `ttf-symbola(Aur)`
- Misc:
  - `youtube-dl ffmpeg ffmpegthumbnailer`
  - `maim sxiv xwallpaper imagemagick`
  - `vifm newsboat picom lynx calcurse`
  - `mpd mpc mpv ncmpcpp`
  - `zathura zathura-pdf-mupdf poppler`
  - `dunst libnotify`
  - `qutebrowser`
  - `gimp`
  - `gparted gucharmap`
  - `zsh zsh-autosuggestions zsh-syntax-highlighting`
- Window manager:
  - `mkdir ~/codework`
  - `cd ~/codework`
  - `git clone https://git.suckless.org/dwm`
  - `git clone https://git.suckless.org/st`
  - `git clone https://git.suckless.org/dmenu`
  - `sudo systemctl reboot`
  - `make && sudo make install` - cd in each directory and install
- Xorg:
  - `cp /etc/X11/xinit/xinitrc ~/.xinitrc`
  - `vim ~/.xinitrc`
  ```
  xset r rate 300 50 &
  xset s off -dpms &
  numlockx &
  picom -b &
  
  while true; do
    dwm >/dev/null 2>&1
  done
  ```
  - `startx`
- Setup git bare:
  - `git config --global user.email "YourEmailAddressHere"`
  - `git config --global user.name "YourNameHere"`
  - `git config --global credential.helper cache`
  - `git config --global credential.helper 'cache --timeout=86400'`
  - `git config --global pager.branch 'false'`
  - further instructions above
- Zsh:
  - chsh -l
  - chsh -s /usr/bin/zsh
  - reboot
- Alsa:
  - `asoundconf list`
  - `asoundconf set-default-card PCH`
  - `reboot`
  - `sudo alsactl store`
  - test microphone:
  ```
  arecord --duration=5 --format=dat test-mic.wav
  aplay test-mic.wav
  ```
## Silent boot
- Watchdog:
  - `sudo -E nvim /etc/modprobe.d/watchdog.conf`
  ```
  blacklist iTCO_wdt
  blacklist iTCO_vendor_support
  ```
- Nvidia:
  - `cd /etc/pacman.d`
  - `mkdir hooks`
  - `cd hooks`
  - `sudo -E nvim nvidia.hook`
  ```
  [Trigger]
  Operation=Install
  Operation=Upgrade
  Operation=Remove
  Type=Package
  Target=nvidia-dkms
  Target=linux-lts
  # Change the linux part above and in the Exec line if a different kernel is used
  
  [Action]
  Description=Update Nvidia module in initcpio
  Depends=mkinitcpio
  When=PostTransaction
  NeedsTargets
  Exec=/bin/sh -c 'while read -r trg; do case $trg in linux) exit 0; esac; done; /usr/bin/mkinitcpio -P'
  ```
  - `sudo -E nvim /etc/sysctl.d/20-quiet-printk.conf`
  ```
  kernel.printk = 3 3 3 3
  ```
  - edit systemd-fsck-root.service and systemd-fsck@.service:
  ```
  sudo systemctl edit --full systemd-fsck-root.service
  sudo systemctl edit --full systemd-fsck@.service
  ```
  ```
  [Service]
  Type=oneshot
  RemainAfterExit=yes
  ExecStart=/usr/lib/systemd/systemd-fsck
  StandardOutput=null
  StandardError=journal+console
  TimeoutSec=0
  ```
  - reboot
  
## Add drives
- Fstab
  - `sudo blkid` - get UUID
  - `sudo -E nvim /etc/fstab`
  ```
  # /dev/sdxY
  UUID=xxxxx-xxxxx-xxxx-xxxx-xxxx /media/core ext4  rw,user,exec 0 0
  ```
  - `mkdir /media`
  - `cd /media`
  - `mkdir core`
  - `chown koltea:koltea /media/core/`
  - `ls -al`
  - `exit`
  - `sudo mount -a`
  - reboot

## Snaphots
- Create snapshot
  ```
  btrfs subvolume snapshot -r / /.snapshots/@root-`date +%F-%R`
  ```
- Restore snapshot
  - `mount /dev/sdx2 /mnt`
  - `btrfs subvolume delete /mnt/root`
  - `brtfs subvolume snapshot /mnt/@snapshots/@root-2015-08-10-20:19 /mnt/root`
  - reboot

  # END

