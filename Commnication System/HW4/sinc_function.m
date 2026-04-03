
% 假設已在 workspace 有 fs, L（或用你原本的程式先算出 L）
% 下面從頭建立窗並做 FFT、畫圖與找第一個 null

% 矩形窗（作為 movmean 的係數）
h = ones(1, L) / L;   % 長度 L，歸一化使直流增益為 1

% FFT 參數
Nfft = 4096;           % 足夠高解析度
H = fft(h, Nfft);
Hshift = fftshift(H);
f = (-Nfft/2 : Nfft/2-1) * (fs / Nfft);   % 頻率軸 (Hz)

% 解析式（DTFT 的幅值）： |H(ω)| = | sin(ω L/2) / (L sin(ω/2)) |
% ω = 2*pi*f/fs
omega = 2*pi*f / fs;
H_analytic = abs( sin(omega * L/2) ./ ( L * sin(omega/2) ) );
% 避免除以零數值問題（ω = 0 處 limit = 1）
tol = 1e-12;
idx0 = abs(omega) < tol;
H_analytic(idx0) = 1;

% 數值幅值（歸一化）
Hmag = abs(Hshift);

% 找第一個 null (解析式)：
f_null_analytic = fs / L;  % 第一個非零 null 在 f = fs / L

% 找第一個 null (數值搜尋)：找最接近零的正頻率位置
% 只觀察正頻段 (f>0)
pos_idx = find(f > 0);
[~, minind_rel] = min(Hmag(pos_idx));
minind = pos_idx(minind_rel);
f_null_numeric = f(minind);

% 圖示
figure;
subplot(2,1,1);
plot(f, 20*log10(Hmag+eps), 'b', 'LineWidth', 1.2); hold on;
plot(f, 20*log10(H_analytic+eps), 'r--', 'LineWidth', 1.2);
xlim([0, fs/2]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title(['Window FFT and Analytic DTFT (L = ' num2str(L) ')']);
legend('FFT (numeric)', 'Analytic (sinc-like)', 'Location', 'best');
grid on;

% 標記第一個 null
ymin = min(20*log10(Hmag+eps));
plot([f_null_analytic f_null_analytic], [ymin 0], 'k:', 'LineWidth', 1);
text(f_null_analytic, 0, ['  analytic null = ' num2str(f_null_analytic, '%.4f') ' Hz'], 'VerticalAlignment','bottom');

plot([f_null_numeric f_null_numeric], [ymin 0], 'g--', 'LineWidth', 1);
text(f_null_numeric, -3, ['  numeric null ≈ ' num2str(f_null_numeric, '%.4f') ' Hz'], 'Color','g');

subplot(2,1,2);
% 線性幅度比較（更直觀看零點）
plot(f, Hmag, 'b', 'LineWidth', 1.2); hold on;
plot(f, H_analytic, 'r--', 'LineWidth', 1.2);
xlim([0, fs/2]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (linear)');
title('Linear Magnitude');
grid on;
plot(f_null_analytic, 0, 'ko', 'MarkerFaceColor','k');
plot(f_null_numeric, Hmag(minind), 'go', 'MarkerFaceColor','g');
legend('FFT (numeric)', 'Analytic', 'analytic null', 'numeric null', 'Location','best');

% 顯示結果
fprintf('Analytic first null frequency = %.6f Hz (f_s / L = %g / %g)\n', f_null_analytic, fs, L);
fprintf('Numeric detected null frequency ≈ %.6f Hz\n', f_null_numeric);