close all;
clear all;
clc;

% --- 1. 參數設定 (Parameters) ---
a  = 0.3;        % modulation index
fc = 2000;       % carrier freq (Hz)
fm = 200;        % message freq (Hz)
Fs = 10000;      % sampling frequency (Hz)
T  = 1/Fs;
N  = 300;        % number of samples to simulate
t  = (0:N-1)*T;  % time vector

% --- 2. AM 調變訊號產生 ---
% s(t) = (1 + a*sin(2*pi*fm*t)) .* cos(2*pi*fc*t)
AM = (1 + a*sin(2*pi*fm.*t)) .* cos(2*pi*fc.*t);

figure;
% 繪製原始 AM 調變訊號
subplot(2,1,1);
plot(t, AM);
xlabel('Time (s)');
ylabel('Amplitude');
title('AM Signal (Time Domain)');
xlim([0 5/fm]);  % 顯示 5 個訊息週期便於觀察
grid on;

% --- 3. 全波整流 (Absolute Value / Envelope Detection) ---
AM_abs = AM .* cos(2*pi*fc.*t);

% --- 4. IIR 濾波器設定與增益計算 ---
% 分子係數 (b) - 對應前饋係數
b = [1, 10, 45, 120, 210, 252, 210, 120, 45, 10, 1];

% 分母係數 (a) - 對應回授係數 (注意：MATLAB 的格式，a_k 需要加上負號以對應 C 語言的加法移項)
a = [1, -7.9922966624, 28.9121945842, -62.3153522815, 88.5876632513, ...
    -86.7670680406, 59.2809515741, -27.8902991725, 8.6456821375, ...
    -1.5942397677, 0.1327680842];

% 計算濾波器的理論直流增益 H(e^j0)
DC_gain = sum(b) / sum(a);
fprintf('講義上濾波器的理論直流增益為: %e\n', DC_gain);

% --- 5. 進行濾波與增益補償 ---
% 透過 filter 函數進行硬體邏輯模擬
y_unscaled = filter(b, a, AM_abs);

% 將訊號除以 DC_gain 進行還原，抵銷講義公式的瑕疵
y_scaled = y_unscaled / DC_gain;

% --- 6. 繪製解調後的包絡線訊號 ---
subplot(2,1,2);
plot(t, y_scaled, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Demodulated Signal (Scaled Envelope Detector Output)');
xlim([0 5/fm]);
grid on;