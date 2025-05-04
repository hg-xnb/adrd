### Cài đặt pipewire và gstreamer và adb

``` Shell
sudo apt update
sudo apt install pipewire gstreamer1.0-pipewire gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
sudo apt install android-tools-adb
```

### Kiểm tra Wayland

``` Shell
echo $XDG_SESSION_TYPE
```

### Tạo virtual-screen

#### Kiểm tra sway

```Shell
sudo apt install sway
```

### Tạo thêm Virtual-Screen

Mở `~/.config/sway/config`
```Shell
    output HEADLESS-1 mode 1280x720@60Hz
```
#### Dùng Weston thay cho Sway
```Shell
sudo apt install weston
```

#### Chạy Weston
```Shell
weston --backend=headless-backend.so --width=1280 --height=720 --no-config
```