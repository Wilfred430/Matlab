% 1. 參數設定 (根據 Lab2.pdf)
fs = 10000;             % 取樣頻率 (1 / 100us)
T = 1/fs;               % 取樣週期
a = 0.3;                % 調變指數
fc = 2000;              % 載波頻率
fm = 200;               % 訊息訊號頻率

% 為了畫出極度平滑的頻譜 (類似你提供的圖片)，我們使用高點數 N
% 這裡不只用 300 點，我們取 2^15 點來獲得極高的頻率解析度
N = 32768;              
t = (0:N-1) * T;        % 時間向量

% 2. 產生 AM 訊號與絕對值解調
x = (1 + a * sin(2*pi*fm*t)) .* cos(2*pi*fc*t);
v_env = abs(x);         % 絕對值解調 (全波整流)

% 3. 執行 FFT
V_ENV = fft(v_env, N);
P2 = abs(V_ENV/N);      % 雙邊頻譜
P1 = P2(1:N/2+1);       % 單邊頻譜
P1(2:end-1) = 2*P1(2:end-1); % 能量補償

% 建立頻率軸
f = fs * (0:(N/2)) / N;

% 4. 轉換為 dB 刻度 (加上微小偏移 1e-12 避免 log(0) 錯誤)
P1_dB = 20 * log10(P1 + 1e-12);

% 5. 繪製精美頻譜圖
figure;
plot(f, P1_dB, 'r', 'LineWidth', 1.2);
title('Single-Sided Spectrum of v\_env (dB)');
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;
axis([0 5000 -250 0]);  % 設定與圖片相似的視角比例