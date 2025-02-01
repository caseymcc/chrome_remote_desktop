# chrome_remote_desktop
This patch provides a simple way to alter chrome remote desktop on ubuntu to use the existing session instead of starting a new one.

The main change is that it alters the `launch_session` to read the current display from the `who` and uses that instead of generating a new one.

simply clone the repo and run
```
sudo apply_patch.sh
```

the bash script just patches the fix_displat.patch to `/opt/google/chrome-remote-desktop/chrome-remote-desktop` then restarts the service. If the service is masked (mine seems to be after updates) it will delete the symlink and update systemctl then restart the service.