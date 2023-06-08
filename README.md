# Volume Control
Pluse audio volume control/notification scripts based on [i3-volume](https://github.com/hastinbe/i3-volume) & [Pulseaudio-ctl](https://github.com/graysky2/pulseaudio-ctl)

## volctl
Volume controller with following commands
* `up`      - increase volume
* `down`    - decrease volume
* `mute`    - toggle mute 

## volntfy
Volume level notifcation tool (`volntfy`) that shows notification using [FreeDesktop Desktop Notification](https://specifications.freedesktop.org/notification-spec/notification-spec-latest.html) and plays notification sound when applicable

## Installation
Clone the repository
```shell
git clone https://gitlab.com/webyfy/iot/e-gurukul/volctl.git
cd volctl
```
Install it by using either of the below methods:
### by `install` command
```shell
sudo make install
# You can uninstall it by running `sudo make unistall` from this direcotry
```
### debian package
> this requires `checkinstall` to be installed in your system
```shell
make deb
sudo apt install ./build/volctl*.deb
```

### Usage
```shell 
volntfy [-h] [-m] [-id REPLACE_ID] [-t TIMEOUT] volume
```
* **positional arguments**
  * volume - Volume level to notify

* **options**
  * -m, --mute : Audio muted
  * -id REPLACE_ID, --replace-id REPLACE_ID : An optional ID of an existing notification that this notification is intended to replace
  * -t TIMEOUT, --timeout TIMEOUT : The timeout time in milliseconds since the display of the notification at which the notification should automatically close (default=2000)


## volntfy-d
Daemon that listens for volume change events and runs `volntfy`

Notification Freedesktop Desktop Notification client for volume notification with icon and sound ()
Volume notifcation daemon that uses [volnoti](https://github.com/davidbrazdil/volnoti) for notifcation

## Configuration
A config file resides in `~/.config/volctl/config` and allows for some options:
- **UPPER_THRESHOLD** - The maximum allowed volume level in percentage (defaults is 100)
- **VOLUME_STEP_SIZE** - The percentage by which volume changes when using volctl (default is 5)

## Dependencies
- **pulseaudio-utils** - provides `pactl`
- **coreutils** - provides `stdbuf`
- **sound-theme-freedesktop** - provides `/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga`
- **util-linux** - provides `flock`
- **python3-dbus** - for `volntfy`
- **bash**
- **notification server**
  - `notify-osd` **OR**
  - `xfce4-notifyd` **OR**
  - `dunst` **OR**
  - `lxqt-notificationd` **OR**
  - `notification-daemon` **OR**
  - `mate-notification-daemon` **OR**
  - Desktop environment with builtin notification server (like Cinnamon, Deepin, Enlightenment, GNOME, GNOME Flashback and KDE Plasma)
