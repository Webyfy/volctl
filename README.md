# Volume Control
Pluse audio volume control/notification scripts based on [i3-volume](https://github.com/hastinbe/i3-volume) & [Pulseaudio-ctl](https://github.com/graysky2/pulseaudio-ctl)

## volctl
Volume controller with following commands
* `up`      - increase volume
* `down`    - decrease volume
* `mute`    - toggle mute 

## volnoti-d
Volume notifcation daemon that uses [volnoti](https://github.com/davidbrazdil/volnoti) for notifcation

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
  - `mate-notification-daemon`
