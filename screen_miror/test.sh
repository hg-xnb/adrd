#!/bin/bash

PORT=8082
HOST=0.0.0.0
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# ==== Kiểm tra cổng ====
echo -e "${GREEN}[+] Kiểm tra cổng $PORT...${NC}"
ss -tuln | grep ":$PORT" > /dev/null
if [ $? -eq 0 ]; then
  echo -e "${GREEN}[+] Cổng $PORT đang lắng nghe.${NC}"
else
  echo -e "${RED}[!] Không có dịch vụ nào đang lắng nghe trên cổng $PORT.${NC}"
  exit 1
fi

# ==== Kiểm tra requests ====
echo -e "${GREEN}[+] Kiểm tra kết nối đến cổng $PORT...${NC}"
ss -tn | grep ":$PORT" | while read -r line; do
  echo -e "${GREEN}[+] Có request kết nối tới cổng $PORT: $line${NC}"
done

# ==== Khởi động server để nhận yêu cầu từ Flutter ====
echo -e "${GREEN}[+] Đang chờ yêu cầu từ Flutter...${NC}"
# Thiết lập lắng nghe cổng, ví dụ bằng việc khởi động MJPEG server hoặc tương tự
# Thêm các lệnh khởi động server tại đây
