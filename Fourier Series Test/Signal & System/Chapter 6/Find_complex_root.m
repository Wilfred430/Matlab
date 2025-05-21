clc; clear; close all;

% 元件值（你提供的數值）
R1 = 10e3;             % 10k Ohm
L1 = 100e-6;           % 100 uH
L2 = 47e-6;            % 17 uH
C1 = 42.409e-12;      % 112.734 pF
C2 = 100e-12;          % 100 pF

% s-domain變數
s = tf('s');

% Transfer Function H(s)
H = (1 / (R1 * (1/(s*(L1+L2)) + s*C1 + s*C2) + 1)) * (L2 / (L1+L2));

% 畫 Bode 圖
figure;
bode(H);
grid on;
title('Bode Plot of H(s)');

% 取得頻率響應資料
[mag, phase, w] = bode(H, logspace(5, 7, 1000));  % 頻率範圍 10^3 ~ 10^9 rad/s

% 壓成向量
mag = squeeze(mag);

% 最大值
max_mag = max(mag);

% 3dB點大小
target_mag = max_mag / sqrt(2);

% 找到上下3dB點
idx = find(mag <= target_mag);

if isempty(idx)
    disp('找不到 3dB 頻率點，請調整頻率範圍。');
else
    lower_3dB_freq = w(idx(1)) / (2*pi);   % Hz
    upper_3dB_freq = w(idx(end)) / (2*pi); % Hz

    % 顯示結果
    fprintf('Lower 3dB 頻率：%.2f Hz\n', lower_3dB_freq);
    fprintf('Upper 3dB 頻率：%.2f Hz\n', upper_3dB_freq);
end
