# Media frame plugin

Simple desktop widget plugin to display an image on your desktop

Features:

- [x] Display an image
- [ ] Display multiple images
  - [ ] Select multiple image file and/or directory
  - [ ] Control buttons to cycle through images
  - [ ] Automatically cycle through image with a time interval
- [ ] GIF/video suport (?)
- [x] Use DMS file picker

![screenshot example](./screenshot.png)

### Refresh and Click Actions

Media Frame can run a command when it is clicked. By default, it runs `xdg-open $MEDIA_FRAME_IMAGE` to open the currently displayed image with the default image viewer. To disable this behavior, set the `Click Action` to `/bin/true` or clear it. Alternatively, you can set it to any command you want. The `MEDIA_FRAME_IMAGE` environment variable will be set to the path of the currently displayed image.

Media Frame can also optionally run a command to fetch new images. By default this does nothing, but you can set the `Refresh Action` to a command to run when the refresh button is clicked. As with the `Click Action`, the `MEDIA_FRAME_IMAGE` environment variable will be set to the path of the currently displayed image. The command should write the image to this same path, and after the command completes, Media Frame will load the new image.

### IPC

Media Frame exposes IPC commands that can be run through the `hype ipc` command. You can copy the IPC name in the widget settings.

- `refresh`: Calls the `Refresh Action` and then loads the new image.
- `reload`: Reloads the displayed image from the filesystem (including an optional fade-in transition).
- `getImagePath`: Returns the path of the displayed image.

You can use this to regularly change the displayed image by calling

```sh
hype ipc call mediaFrame_replaceMe refresh
```

from a cron job or systemd timer.

### Refresh Action example: cat pictures

To use [Cat as a Service](https://cataas.com/) to fetch cat pictures, set the `Refresh Action` to

```sh
curl https://cataas.com/cat?type=square -o $MEDIA_FRAME_IMAGE
```

Then, set the refresh button position to a corner to display it, and optionally create a systemd (user) service and timer (replacing the IPC name with your widget's IPC name):

```ini
# cat-picture.service
[Unit]
Description=fetch and display random cat picture

[Service]
Type=oneshot
ExecStart=hype ipc call mediaFrame_replaceMe refresh
```

```ini
# cat-picture.timer
[Unit]
Description=fetch and display a new cat picture every 10 minutes

[Timer]
OnCalendar=*:0/10:00
AccuracySec=1s

[Install]
WantedBy=hype.service

```
