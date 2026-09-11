# ==============================================================================
# Bài Tập Chương 1 - Dự Báo Kinh Tế (Ngôn Ngữ R)
# Dự báo giá dầu Brent Crude (POILBREUSDQ) và Đánh Giá Độ Chính Xác Dự Báo
# ==============================================================================

# 1. Tải dữ liệu trực tiếp từ FRED
url <- "https://fred.stlouisfed.org/graph/fredgraph.csv?id=POILBREUSDQ"
df <- read.csv(url, na.strings = ".", stringsAsFactors = FALSE)
df <- na.omit(df)

# Chuyển đổi định dạng ngày và đổi tên cột
colnames(df)[1] <- "DATE"
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
poil_ts <- ts(poil, frequency = 4)
fit_ses <- HoltWinters(poil_ts, beta = FALSE, gamma = FALSE)
yhat3 <- c(poil[1], fit_ses$fitted[, "xhat"])
df$yhat3 <- as.numeric(yhat3)

# 5. Lưu dataset vào thư mục data/chapter1
if (!dir.exists("data/chapter1")) {
  dir.create("data/chapter1", recursive = TRUE)
}

output_csv <- "data/chapter1/chapter1_r.csv"
write.csv(df[, c("quarter", "poil", "yhat1", "yhat2", "yhat3")], 
          file = output_csv, 
          row.names = FALSE)

# 6. Tính toán 7 tiêu chí đánh giá độ chính xác của dự báo
calc_metrics <- function(y, yhat, model_name) {
  y_diff <- c(NA, diff(y))
  valid <- !is.na(y) & !is.na(yhat) & !is.na(y_diff)
  
  y_v <- y[valid]
  yhat_v <- yhat[valid]
  e_v <- y_v - yhat_v
  diff_v <- y_diff[valid]
  
  me <- mean(e_v)
  mpe <- mean(e_v / y_v) * 100
  mae <- mean(abs(e_v))
  mape <- mean(abs(e_v) / y_v) * 100
  mse <- mean(e_v^2)
  rmse <- sqrt(mse)
  theil_u <- sqrt(sum(e_v^2)) / sqrt(sum(diff_v^2))
  
  return(data.frame(
    Model = model_name,
    ME = me,
    MPE = mpe,
    MAE = mae,
    MAPE = mape,
    MSE = mse,
    RMSE = rmse,
    Theil_U = theil_u,
    stringsAsFactors = FALSE
  ))
}

m1_eval <- calc_metrics(df$poil, df$yhat1, "Mo hinh Tho (Naive)")
m2_eval <- calc_metrics(df$poil, df$yhat2, "Trung binh truot MA(4)")
m3_eval <- calc_metrics(df$poil, df$yhat3, "San bang mu don SES")

eval_df_r <- rbind(m1_eval, m2_eval, m3_eval)

# Lưu bảng đánh giá vào data/chapter1/chapter1predict_r.csv
predict_csv_r <- "data/chapter1/chapter1predict_r.csv"
write.csv(eval_df_r, file = predict_csv_r, row.names = FALSE)

# 7. Vẽ biểu đồ dự báo trên cùng hệ trục tọa độ và lưu file PNG
chart_path <- "data/chapter1/chapter1_chart_r.png"
png(filename = chart_path, width = 1200, height = 600, res = 100)

plot(1:n, df$poil, type = "l", col = "black", lwd = 2, xaxt = "n",
     main = "So sanh gia dau Brent thuc te va cac mo hinh du bao (R)",
     xlab = "Quy (Quarter)", ylab = "Gia dau Brent (USD/thung)")

axis(1, at = 1:n, labels = df$quarter, las = 2, cex.axis = 0.8)
lines(1:n, df$yhat1, col = "blue", lty = 2, lwd = 1.5)
lines(1:n, df$yhat2, col = "darkgreen", lty = 4, lwd = 1.5)
lines(1:n, df$yhat3, col = "red", lty = 3, lwd = 2)

legend("topleft", 
       legend = c("Thuc te (poil)", "Mo hinh Tho (yhat1)", "Trung binh truot MA(4) (yhat2)", "San bang mu don SES (yhat3)"),
       col = c("black", "blue", "darkgreen", "red"),
       lty = c(1, 2, 4, 3), lwd = c(2, 1.5, 1.5, 2), bty = "n")

grid(col = "lightgray", lty = "dotted")
dev.off()

print(head(df[, c("quarter", "poil", "yhat1", "yhat2", "yhat3")], 10))
cat("\n--- Bang Tieu Chi Danh Gia Do Chinh Xac Du Bao (R) ---\n")
print(eval_df_r)
cat("Da luu bang danh gia vao:", predict_csv_r, "\n")
