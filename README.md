# Bài Tập Môn Dự Báo Kinh Tế (Economic Forecasting)

Tổng hợp các bài tập, thực hành phân tích và dự báo chuỗi thời gian cho môn học **Dự báo Kinh tế**. Dự án được cấu trúc theo từng chương bài tập với hỗ trợ cả Python và R.

---

## Cấu trúc dự án

```text
Economic-forecasting/
├── data/                         # Thư mục chứa dữ liệu theo từng chương
│   └── chapter1/
│       ├── chapter1.csv          # Kết quả dự báo Chương 1 (Python)
│       ├── chapter1_r.csv        # Kết quả dự báo Chương 1 (R)
│       ├── chapter1predict.csv   # Bảng 7 tiêu chí đánh giá độ chính xác (Python)
│       ├── chapter1predict_r.csv # Bảng 7 tiêu chí đánh giá độ chính xác (R)
│       ├── chapter1_chart.png    # Biểu đồ dự báo Chương 1 (Python)
│       └── chapter1_chart_r.png  # Biểu đồ dự báo Chương 1 (R)
├── final/                        # Thư mục chứa bài tập & tài liệu báo cáo
│   ├── chapter1.pdf              # File PDF bài tập báo cáo hoàn chỉnh
│   └── chapter1.zip              # File ZIP chứa các hình ảnh trích xuất từ PDF bài tập
├── scr/                          # Thư mục chứa mã nguồn theo từng chương
│   ├── chapter1.py               # Bài tập Chương 1 (Python)
│   └── chapter1.R                # Bài tập Chương 1 (R)
├── .gitignore                    # Bỏ qua các tệp rác / môi trường ảo
├── README.md                     # Hướng dẫn chạy dự án
└── requirements.txt              # Danh sách thư viện phụ thuộc Python
```

---

## Danh mục bài tập các chương

### 📌 Chương 1: TỔNG QUAN VỀ DỰ BÁO VÀ CHUỖI THỜI GIAN
- **Báo cáo & Tài liệu**:
  - File PDF bài tập: [`final/chapter1.pdf`](file:///f:/Economic-forecasting/final/chapter1.pdf) (File PDF bài tập báo cáo hoàn chỉnh)
  - File ZIP hình ảnh: [`final/chapter1.zip`](file:///f:/Economic-forecasting/final/chapter1.zip) (Tập hợp ảnh trích xuất từ file PDF bài tập)
- **Mã nguồn**:
  - Python: [`scr/chapter1.py`](file:///f:/Economic-forecasting/scr/chapter1.py)
  - R: [`scr/chapter1.R`](file:///f:/Economic-forecasting/scr/chapter1.R)
- **Dữ liệu & Kết quả**:
  - Tập dữ liệu: [`data/chapter1/chapter1.csv`](file:///f:/Economic-forecasting/data/chapter1/chapter1.csv) (Python) | [`data/chapter1/chapter1_r.csv`](file:///f:/Economic-forecasting/data/chapter1/chapter1_r.csv) (R)
  - Bảng 7 tiêu chí đánh giá: [`data/chapter1/chapter1predict.csv`](file:///f:/Economic-forecasting/data/chapter1/chapter1predict.csv) (Python) | [`data/chapter1/chapter1predict_r.csv`](file:///f:/Economic-forecasting/data/chapter1/chapter1predict_r.csv) (R)
- **Biểu đồ**:
  - Python: [`data/chapter1/chapter1_chart.png`](file:///f:/Economic-forecasting/data/chapter1/chapter1_chart.png)
  - R: [`data/chapter1/chapter1_chart_r.png`](file:///f:/Economic-forecasting/data/chapter1/chapter1_chart_r.png)
- **Nội dung thực hiện**:
  - Tải dữ liệu giá dầu Brent (`POILBREUSDQ`) từ FRED theo quý (1980 - nay).
  - Lọc dữ liệu từ quý **2019Q1** trở đi.
  - Xây dựng 3 mô hình dự báo:
    1. **Mô hình Thô (Naive)**: Điều chỉnh mùa vụ & xu thế ($yhat_1 = poil_{t-4} + \frac{poil_{t-1} - poil_{t-5}}{4}$).
    2. **Mô hình Trung bình trượt (Moving Average)**: MA(4).
    3. **Mô hình San bằng mũ đơn (Simple Exponential Smoothing)**: SES.
  - Xuất file dữ liệu kết quả, tính toán 7 tiêu chí đánh giá độ chính xác dự báo (ME, MPE, MAE, MAPE, MSE, RMSE, Theil's U) và vẽ biểu đồ so sánh các mô hình trên cùng hệ trục tọa độ.

---

## Hướng dẫn cài đặt & Chạy bài tập

### 1. Chạy bài tập bằng Python

```bash
pip install -r requirements.txt
python scr/chapter1.py
```

### 2. Chạy bài tập bằng R

```bash
Rscript scr/chapter1.R
```
