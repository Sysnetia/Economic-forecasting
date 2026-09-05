import os
import pandas as pd
import pandas_datareader.data as web
import matplotlib.pyplot as plt
from statsmodels.tsa.api import SimpleExpSmoothing

# Tải và lọc dữ liệu
df = web.DataReader('POILBREUSDQ', 'fred', start='1980-01-01')
df.reset_index(inplace=True)
df.rename(columns={'DATE': 'quarter', 'POILBREUSDQ': 'poil'}, inplace=True)
df['quarter'] = pd.to_datetime(df['quarter']).dt.to_period('Q')
df.set_index('quarter', inplace=True)
df = df[df.index > '2018Q4'].copy()

# Mô hình 1: Dự báo bằng mô hình thô (điều chỉnh mùa vụ & xu thế)
df['yhat1'] = df['poil'].shift(4) + (df['poil'].shift(1) - df['poil'].shift(5)) / 4

# Mô hình 2: Trung bình trượt (Moving Average, window = 4)
df['yhat2'] = df['poil'].rolling(window=4).mean()

# Mô hình 3: San bằng mũ đơn (Simple Exponential Smoothing)
model = SimpleExpSmoothing(df['poil'].dropna(), initialization_method='estimated').fit(optimized=True)
df['yhat3'] = model.fittedvalues

# Lưu dataset vào thư mục data/chapter1 với tên chapter1.csv
os.makedirs('data/chapter1', exist_ok=True)
df.to_csv('data/chapter1/chapter1.csv')

# Vẽ biểu đồ dự báo trên cùng hệ trục tọa độ
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

# Lưu biểu đồ vào thư mục data/chapter1
chart_path = 'data/chapter1/chapter1_chart.png'
plt.savefig(chart_path, dpi=300)
plt.close()

print(df[['poil', 'yhat1', 'yhat2', 'yhat3']].head(10))
print(f"Chart saved to: {chart_path}")
