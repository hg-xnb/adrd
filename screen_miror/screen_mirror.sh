#!/bin/bash

DEFAULT_RESOLUTION="1280x720"
DEFAULT_FRAMERATE=20
PORT=8081
PROBESIZE="128M"

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}[+] Kiểm tra kết nối thiết bị ADB...${NC}"
adb get-state 1>/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}[!] Không tìm thấy thiết bị Android. Hãy kiểm tra lại USB hoặc bật gỡ lỗi USB.${NC}"
    exit 1
fi

echo -e "${GREEN}[+] Đảo ngược cổng $PORT từ PC sang tablet...${NC}"
adb reverse tcp:$PORT tcp:$PORT

echo -e "${GREEN}[+] Sẵn sàng phát MJPEG stream trên cổng $PORT.${NC}"
echo -e "${GREEN}[!] Nhấn Ctrl+C để thoát.${NC}"

while true; do
  echo -e "${GREEN}🔌 Đang chờ kết nối từ client Flutter...${NC}"

  REQUEST=$(mktemp)
  nc -l -p "$PORT" > "$REQUEST" < /dev/null &
  NC_PID=$!
  sleep 1
  kill "$NC_PID" 2>/dev/null
  wait "$NC_PID" 2>/dev/null

  FIRST_LINE=$(head -n 1 "$REQUEST")
  rm "$REQUEST"

  echo -e "${GREEN}➡ Yêu cầu: $FIRST_LINE${NC}"

  QUERY=$(echo "$FIRST_LINE" | grep -oP '\?.+HTTP' | sed 's/HTTP//; s/^\?//; s/ //g')
  RESOLUTION=$(echo "$QUERY" | grep -oP 'resolution=\K[^&]*')
  FRAMERATE=$(echo "$QUERY" | grep -oP 'fps=\K[^&]*')
  RESOLUTION=${RESOLUTION:-$DEFAULT_RESOLUTION}
  FRAMERATE=${FRAMERATE:-$DEFAULT_FRAMERATE}

  echo -e "${GREEN}📺 Resolution: $RESOLUTION | 🎞️ FPS: $FRAMERATE${NC}"
  echo -e "${GREEN}▶ Khởi động ffmpeg...${NC}"

  {
    echo -ne "HTTP/1.1 200 OK\r\n"
    echo -ne "Content-Type: multipart/x-mixed-replace; boundary=frame\r\n\r\n"

    ffmpeg -probesize $PROBESIZE \
      -f x11grab -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i :0.0 \
      -vf "scale=$RESOLUTION" \
      -update 1 -q:v 5 \
      -f image2pipe -vcodec mjpeg - 2>/dev/null | \
    while IFS= read -r -d '' -n 1 frame; do
      read -r -d '' -n 1 byte
      frame="$frame$byte"
      while IFS= read -r -d '' -n 1 byte; do
        frame="$frame$byte"
        [[ "$frame" == *"\xff\xd9" ]] && break
      done
      LEN=$(printf "%s" "$frame" | wc -c)
      echo -ne "--frame\r\n"
      echo -ne "Content-Type: image/jpeg\r\n"
      echo -ne "Content-Length: $LEN\r\n\r\n"
      printf "%s" "$frame"
      echo -ne "\r\n"
    done
  } | nc -l -p "$PORT" -q 1

  echo -e "${RED}⚠️ Stream kết thúc. Quay lại trạng thái chờ client khác...${NC}"
done
