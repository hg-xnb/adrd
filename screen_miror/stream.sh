#!/bin/bash

# ==== Cài đặt ====
PORT=8082 # Cổng cố định, bạn có thể chỉnh sửa
HOST=0.0.0.0
RESOLUTION="1280x720"
FPS=20
TMP_PIPE="/tmp/flutter_ready.pipe"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# ==== Kiểm tra cổng ====
echo -e "${GREEN}[+] Kiểm tra cổng $PORT...${NC}"
if ss -tuln | grep -q ":$PORT"; then
    echo -e "${RED}[!] Cổng $PORT đang được dùng! Hãy chọn cổng khác.${NC}"
    exit 1
fi

# ==== Dọn dẹp ====
echo -e "${GREEN}[+] Dọn dẹp tiến trình cũ...${NC}"
pkill -9 wf-recorder 2>/dev/null
pkill -9 ffmpeg 2>/dev/null
adb reverse --remove-all 2>/dev/null
rm -f "$TMP_PIPE"
adb shell am force-stop com.example.app 2>/dev/null

# ==== Thiết lập ADB reverse ====
adb reverse tcp:$PORT tcp:$PORT || {
    echo -e "${RED}[!] adb reverse thất bại.${NC}"
    exit 1
}

# ==== Khởi động sway nếu chưa có ====
if ! pgrep -x sway >/dev/null; then
    echo -e "${GREEN}[+] sway chưa chạy, khởi động...${NC}"
    sway >sway.log 2>&1 &
    SWAY_PID=$!
    sleep 3
    if ! ps -p $SWAY_PID >/dev/null; then
        echo -e "${RED}[!] sway không khởi động được.${NC}"
        cat sway.log
        exit 1
    fi
else
    echo -e "${GREEN}[+] sway đã chạy.${NC}"
fi

# ==== Kiểm tra wf-recorder & ffmpeg ====
command -v wf-recorder >/dev/null || {
    echo -e "${RED}[!] Cài wf-recorder${NC}"
    exit 1
}
command -v ffmpeg >/dev/null || {
    echo -e "${RED}[!] Cài ffmpeg${NC}"
    exit 1
}

# ==== Tạo pipe và chờ Flutter kết nối ====
echo -e "${GREEN}[+] Chờ Flutter kết nối tới $PORT bằng netcat...${NC}"
mkfifo "$TMP_PIPE"
(cat "$TMP_PIPE" | nc -l -p $PORT >/dev/null) &

# ==== Khi có kết nối, bắt đầu stream ====
have_req=0
sleep 1
echo -e "${GREEN}[+] Đang chờ kết nối...${NC}"

while [ 1 ]; do
    # ==== Kiểm tra cổng ====
    echo -e "${GREEN}    [+] Kiểm tra cổng $PORT...${NC}"
    ss -tuln | grep ":$PORT" >/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}    [+] Cổng $PORT đang lắng nghe.${NC}"
    else
        echo -e "${RED}    [!] Không có dịch vụ nào đang lắng nghe trên cổng $PORT.${NC}"
        exit 1
    fi

    # ==== Kiểm tra requests ====
    echo -e "${GREEN}    [+] Kiểm tra kết nối đến cổng $PORT...${NC}"
    # Sử dụng ss để kiểm tra các kết nối đến cổng và gán `have_req=1` nếu tìm thấy kết nối
    ss -tn | grep ":$PORT" >/dev/null
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}    [+] Có request kết nối tới cổng $PORT.${NC}"
        have_req=1  # Cập nhật giá trị của biến `have_req`
    fi

    echo -e "${GREEN}    [+] have_req = $have_req ${NC}"

    if [ $have_req -eq 1 ]; then
        echo -e "${GREEN}    [+] Đã nhận yêu cầu từ Flutter.${NC}"
        break
    fi
    
    sleep 1
    echo -e "${GREEN}...${NC}"
done

echo -e "${GREEN}[+] Flutter đã kết nối tới $PORT. Bắt đầu stream...${NC}"

# ==== Stream wf-recorder => MJPEG ====
wf-recorder --no-dmabuf --pixel-format=yuv420p --codec=rawvideo --file=- |
    ffmpeg -hide_banner -loglevel error \
        -f rawvideo -pixel_format yuv420p -video_size $RESOLUTION -framerate $FPS \
        -i - -f mjpeg tcp://$HOST:$PORT

# ==== Dọn dẹp sau khi kết thúc ====
rm -f "$TMP_PIPE"
