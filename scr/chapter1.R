# ==============================================================================
# Bài Tập Chương 1 - Dự Báo Kinh Tế (Ngôn Ngữ R)
# Dự báo giá dầu Brent Crude (POILBREUSDQ) từ dữ liệu FRED
# ==============================================================================

# 1. Tải dữ liệu trực tiếp từ FRED
url <- "https://fred.stlouisfed.org/graph/fredgraph.csv?id=POILBREUSDQ"
df <- read.csv(url, na.strings = ".", stringsAsFactors = FALSE)

# Chuyển đổi định dạng ngày và đổi tên cột
df$DATE <- as.Date(df$DATE)
colnames(df)[colnames(df) == "POILBREUSDQ"] <- "poil"

# Tạo chuỗi quý (Năm + Quý)
df$year <- as.numeric(format(df$DATE, "%Y"))
df$month <- as.numeric(format(df$DATE, "%m"))
df$qtr_num <- ceiling(df$month / 3)
df$quarter <- paste0(df$year, "Q", df$qtr_num)

# Lọc dữ liệu từ Q1-2019 trở đi (các quý > 2018Q4)
df <- df[df$year > 2018 | (df$year == 2018 & df$qtr_num > 4), ]
df <- df[order(df$DATE), ]
rownames(df) <- NULL

n <- nrow(df)
poil <- df$poil

# 2. Mô hình 1: Dự báo bằng mô hình thô (điều chỉnh mùa vụ & xu thế)
# yhat1 = poil[t-4] + (poil[t-1] - poil[t-5]) / 4
yhat1 <- rep(NA, n)
for (t in 6:n) {
  yhat1[t] <- poil[t - 4] + (poil[t - 1] - poil[t - 5]) / 4
}
df$yhat1 <- yhat1

# 3. Mô hình 2: Trung bình trượt (Moving Average, window = 4)
yhat2 <- rep(NA, n)
for (t in 4:n) {
  yhat2[t] <- mean(poil[(t - 3):t])
}
df$yhat2 <- yhat2

# 4. Mô hình 3: San bằng mũ đơn (Simple Exponential Smoothing - SES)
# Sử dụng HoltWinters từ gói stats tích hợp sẵn trong R
fit_ses <- HoltWinters(poil, beta = FALSE, gamma = FALSE)
# fitted values của HoltWinters bắt đầu từ quan sát thứ 2
yhat3 <- c(poil[1], fit_ses$fitted[, "hat"])
df$yhat3 <- yhat3

# 5. Lưu dataset vào thư mục data/chapter1
if (!dir.exists("data/chapter1")) {
  dir.create("data/chapter1", recursive = TRUE)
}

output_csv <- "data/chapter1/chapter1_r.csv"
write.csv(df[, c("quarter", "poil", "yhat1", "yhat2", "yhat3")], 
          file = output_csv, 
          row.names = FALSE)

# 6. Vẽ biểu đồ dự báo trên cùng hệ trục tọa độ và lưu file PNG
chart_path <- "data/chapter1/chapter1_chart_r.png"
png(filename = chart_path, width = 1200, height = 600, res = 100)

plot(1:n, df$poil, type = "l", col = "black", lwd = 2, xaxt = "n",
     main = "So sánh giá dầu Brent thực tế và các mô hình dự báo (R)",
     xlab = "Quý (Quarter)", ylab = "Giá dầu Brent (USD/thùng)")

axis(1, at = 1:n, labels = df$quarter, las = 2, cex.axis = 0.8)
lines(1:n, df$yhat1, col = "blue", lty = 2, lwd = 1.5)
lines(1:n, df$yhat2, col = "darkgreen", lty = 4, lwd = 1.5)
lines(1:n, df$yhat3, col = "red", lty = 3, lwd = 2)

legend("topleft", 
       legend = c("Thực tế (poil)", "Mô hình Thô (yhat1)", "Trung bình trượt MA(4) (yhat2)", "San bằng mũ đơn SES (yhat3)"),
       col = c("black", "blue", "darkgreen", "red"),
       lty = c(1, 2, 4, 3), lwd = c(2, 1.5, 1.5, 2), bty = "n")

grid(col = "lightgray", lty = "dotted")
dev.off()

# In 10 dòng đầu kết quả ra màn hình
print(head(df[, c("quarter", "poil", "yhat1", "yhat2", "yhat3")], 10))
cat("Da luu ket qua vao:", output_csv, "va", chart_path, "\n")
