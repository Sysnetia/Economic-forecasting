# Bài Tập Môn Dự Báo Kinh Tế (Economic Forecasting)

Tổng hợp các bài tập, thực hành phân tích và dự báo chuỗi thời gian cho môn học **Dự báo Kinh tế**. Dự án được cấu trúc theo từng chương bài tập.

---

## Cấu trúc dự án

```text
Economic-forecasting/
├── data/                         # Thư mục chứa dữ liệu theo từng chương
│   └── chapter1/
│       ├── chapter1.csv          # Tập dữ liệu & kết quả dự báo Chương 1
│       └── chapter1_chart.png    # Biểu đồ so sánh các mô hình Chương 1
├── scr/                          # Thư mục chứa mã nguồn Python theo từng chương
│   └── chapter1.py               # Bài tập Chương 1
├── .gitignore                    # Bỏ qua các tệp rác / môi trường ảo
├── README.md                     # Hướng dẫn chạy dự án
└── requirements.txt              # Danh sách thư viện phụ thuộc
```

---

## Danh mục bài tập các chương

### 📌 Chương 1: Dự báo chuỗi thời gian đơn giản
- **Mã nguồn**: [`scr/chapter1.py`](file:///f:/Economic-forecasting/scr/chapter1.py)
- **Dữ liệu & Kết quả**: [`data/chapter1/chapter1.csv`](file:///f:/Economic-forecasting/data/chapter1/chapter1.csv)
- **Biểu đồ**: [`data/chapter1/chapter1_chart.png`](file:///f:/Economic-forecasting/data/chapter1/chapter1_chart.png)
- **Nội dung thực hiện**:
  - Tải dữ liệu giá dầu Brent (`POILBREUSDQ`) từ FRED theo quý (1980 - nay).
  - Lọc dữ liệu từ quý **2019Q1** trở đi.
  - Xây dựng 3 mô hình dự báo:
    1. **Mô hình Thô (Naive)**: Điều chỉnh mùa vụ & xu thế.
    2. **Mô hình Trung bình trượt (Moving Average)**: MA(4).
    3. **Mô hình San bằng mũ đơn (Simple Exponential Smoothing)**: SES.
  - Xuất file dữ liệu kết quả và vẽ biểu đồ so sánh các mô hình trên cùng hệ trục tọa độ.

---

### ⏳ Các chương tiếp theo (Đang tiếp tục cập nhật...)
Các bài tập chương tiếp theo sẽ được bổ sung vào thư mục `scr/` (mã nguồn) và `data/` (dữ liệu kết quả) theo tiến độ môn học.

---

## Hướng dẫn cài đặt & Chạy bài tập

### 1. Cài đặt các thư viện phụ thuộc

Mở terminal và chạy lệnh:

```bash
pip install -r requirements.txt
```

### 2. Chạy bài tập

Chạy script Python của chương tương ứng (ví dụ Chương 1):

```bash
python scr/chapter1.py
```
