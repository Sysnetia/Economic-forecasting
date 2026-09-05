import sys
import os
import pandas as pd
import numpy as np
import pandas_datareader.data as web
import matplotlib.pyplot as plt
from statsmodels.tsa.api import SimpleExpSmoothing

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')


# 1. Tải và lọc dữ liệu
df = web.DataReader('POILBREUSDQ', 'fred', start='1980-01-01')
df.reset_index(inplace=True)
df.rename(columns={'DATE': 'quarter', 'POILBREUSDQ': 'poil'}, inplace=True)
df['quarter'] = pd.to_datetime(df['quarter']).dt.to_period('Q')
df.set_index('quarter', inplace=True)
df = df[df.index > '2018Q4'].copy()

# 2. Mô hình 1: Dự báo bằng mô hình thô (điều chỉnh mùa vụ & xu thế)
df['yhat1'] = df['poil'].shift(4) + (df['poil'].shift(1) - df['poil'].shift(5)) / 4

# 3. Mô hình 2: Trung bình trượt (Moving Average, window = 4)
df['yhat2'] = df['poil'].rolling(window=4).mean()

# 4. Mô hình 3: San bằng mũ đơn (Simple Exponential Smoothing)
model = SimpleExpSmoothing(df['poil'].dropna(), initialization_method='estimated').fit(optimized=True)
df['yhat3'] = model.fittedvalues

# 5. Lưu dataset vào thư mục data/chapter1 với tên chapter1.csv
os.makedirs('data/chapter1', exist_ok=True)
df.to_csv('data/chapter1/chapter1.csv')

# 6. Tính toán 7 tiêu chí đánh giá độ chính xác của dự báo
df['poil_diff'] = df['poil'] - df['poil'].shift(1)

metrics_list = []
models_info = [
    ('yhat1', 'Mô hình Thô (Naive)'),
    ('yhat2', 'Trung bình trượt MA(4)'),
    ('yhat3', 'San bằng mũ đơn SES')
]

for col, name in models_info:
    valid = df[['poil', col, 'poil_diff']].dropna()
    y = valid['poil']
    yhat = valid[col]
    e = y - yhat
    diff = valid['poil_diff']
    
    me = np.mean(e)
    mpe = np.mean(e / y) * 100
    mae = np.mean(np.abs(e))
    mape = np.mean(np.abs(e) / y) * 100
    mse = np.mean(e**2)
    rmse = np.sqrt(mse)
    theil_u = np.sqrt(np.sum(e**2)) / np.sqrt(np.sum(diff**2))
    
    metrics_list.append({
        'Model': name,
        'ME': me,
        'MPE': mpe,
        'MAE': mae,
        'MAPE': mape,
        'MSE': mse,
        'RMSE': rmse,
        'Theil_U': theil_u
    })

eval_df = pd.DataFrame(metrics_list)

# Lưu bảng đánh giá vào data/chapter1/chapter1predict.csv
predict_csv_path = 'data/chapter1/chapter1predict.csv'
eval_df.to_csv(predict_csv_path, index=False)

# 7. Vẽ biểu đồ dự báo trên cùng hệ trục tọa độ
plt.figure(figsize=(12, 6))
plt.plot(df.index.astype(str), df['poil'], label='Thực tế (poil)', color='black', linewidth=2)
plt.plot(df.index.astype(str), df['yhat1'], label='Mô hình Thô (yhat1)', linestyle='--', color='blue')
plt.plot(df.index.astype(str), df['yhat2'], label='Trung bình trượt MA(4) (yhat2)', linestyle='-.', color='green')
plt.plot(df.index.astype(str), df['yhat3'], label='San bằng mũ đơn SES (yhat3)', linestyle=':', color='red', linewidth=2)

plt.title('So sánh giá dầu Brent thực tế và các mô hình dự báo', fontsize=14, fontweight='bold')
plt.xlabel('Quý (Quarter)', fontsize=12)
plt.ylabel('Giá dầu Brent (USD/thùng)', fontsize=12)
plt.xticks(rotation=45)
plt.legend(fontsize=11)
plt.grid(True, linestyle=':', alpha=0.6)
plt.tight_layout()

chart_path = 'data/chapter1/chapter1_chart.png'
plt.savefig(chart_path, dpi=300)
plt.close()

print("--- Data snippet (first 10 rows) ---")
print(df[['poil', 'yhat1', 'yhat2', 'yhat3']].head(10))
print("\n--- Forecast Evaluation Metrics ---")
print(eval_df.to_string(index=False))
print(f"\nChart saved to: {chart_path}")
print(f"Evaluation metrics saved to: {predict_csv_path}")
