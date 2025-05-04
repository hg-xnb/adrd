# Tổng quan giải pháp

## Mục tiêu

Sử dụng Weston để tạo một màn hình ảo trên Ubuntu 24.04 (Wayland).
Capture nội dung màn hình ảo bằng gstreamer và stream MJPEG qua TCP.
Kết nối qua USB OTG sử dụng ADB reverse tunneling để tablet truy cập stream.
Ứng dụng Flutter trên tablet hiển thị stream MJPEG.

## Yêu cầu

Ubuntu 24.04 với Wayland.
Tablet Android hỗ trợ USB Debugging và ADB.
Cáp USB OTG hoặc USB thông thường.
Các công cụ: weston, gstreamer, adb.

## Cách hoạt động

Weston tạo một màn hình ảo (headless backend).
gstreamer capture màn hình từ Weston và stream qua cổng 8081.
ADB reverse cho phép tablet truy cập stream qua <http://localhost:8081>.
Ứng dụng Flutter hiển thị stream MJPEG.

# Thực hiện

## Cài phụ thuộc

```Shell
sudo apt update
sudo apt install weston gstreamer1.0-pipewire gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly android-tools-adb
```

## Tạo file cấu hình

Mở `~/.config/weston.ini`
Nội dung:

```ini
[core]
backend=headless-backend.so
modules=desktop-shell.so

[output]
name=HEADLESS-1
mode=1280x720@60

[shell]
background-color=0xff000000
```

**Giải thích:**

- backend=headless-backend.so: Chạy Weston mà không cần màn hình vật lý.
- name=HEADLESS-1: Đặt tên cho màn hình ảo.
- mode=1280x720@60: Độ phân giải 1280x720, tần số 60Hz.
- background-color=0xff000000: Màu nền đen (ARGB).

## Kiểm tra Weston

```Shell
weston --config=~/.config/weston.ini
```

## Tạo script Bash để stream MJPEG

```Shell
#!/bin/bash

# Cấu hình
PORT=8081
RESOLUTION="1280x720"
FPS=20
WESTON_CONFIG="$HOME/.config/weston.ini"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Kiểm tra kết nối ADB
echo -e "${GREEN}[+] Kiểm tra kết nối thiết bị ADB...${NC}"
adb get-state 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Không tìm thấy thiết bị Android. Hãy kiểm tra USB hoặc bật gỡ lỗi USB.${NC}"
    exit 1
fi

# Đảo ngược cổng ADB
echo -e "${GREEN}[+] Đảo ngược cổng $PORT từ PC sang tablet...${NC}"
adb reverse tcp:$PORT tcp:$PORT
if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Lỗi khi thiết lập ADB reverse.${NC}"
    exit 1
fi

# Kiểm tra Weston
echo -e "${GREEN}[+] Kiểm tra Weston...${NC}"
if ! command -v weston &> /dev/null; then
    echo -e "${RED}[!] Weston không được cài đặt. Hãy cài đặt bằng: sudo apt install weston${NC}"
    exit 1
fi

# Chạy Weston ở background
echo -e "${GREEN}[+] Khởi động Weston với màn hình ảo...${NC}"
weston --config="$WESTON_CONFIG" &
WESTON_PID=$!
sleep 2
if ! ps -p $WESTON_PID > /dev/null; then
    echo -e "${RED}[!] Lỗi khi khởi động Weston.${NC}"
    exit 1
fi

# Chạy gstreamer để stream MJPEG
echo -e "${GREEN}[+] Khởi động MJPEG stream trên cổng $PORT...${NC}"
gst-launch-1.0 pipewiresrc ! videoconvert ! videoscale ! video/x-raw,width=1280,height=720 ! jpegenc quality=85 ! multipartmux ! tcpserversink host=0.0.0.0 port=$PORT

# Dọn dẹp khi thoát
echo -e "${RED}[+] Dừng Weston...${NC}"
kill $WESTON_PID 2>/dev/null
```
