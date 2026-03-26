clear; close all; clc;
%% =====================================================
%% 1. generate m(t) + sampling
%% =====================================================
fd = 8000;              % Discretization frequency 
fs = 200;               % Symbol Rate 
T  = 1;
t  = 0:1/fd:T-1/fd;
noise_power = 0.1;      

% 產生 message m(t)
fm = 100;
m = 0.1 + 3*cos(2*pi*fm*(t-1.5/T)/25) ...
    - 4*sin(2*pi*fm*(t-0.5/T)/15);
figure; plot(t,m,'k'); title('Original Message m(t)'); xlabel('t');

% Sampling
Ns = round(fd/fs);      % Oversampling factor (40 samples per symbol)
n = 1:Ns:length(m);
m_s = m(n);
t_s = t(n);
figure; stem(t_s,m_s,'filled'); title('sampled signal'); xlabel('t');

%% =====================================================
%% 2. Quantize (量化)
%% =====================================================
% Quantization (L=16 levels) -> 得到符號 a
L = 16;
m_min = min(m_s);
m_max = max(m_s);

% 計算量化間隔 (總範圍除以 L-1 個間隔)
delta = ??; 

% 計算量化索引
q_index = ??; 

% 根據索引還原成量化後的數值 (重建數值)
a = ??; 

figure; stem(a,'filled'); title('Quantized Symbols');
xlabel('Symbol Index');

%% =====================================================
%% 3. PAM Waveform (脈衝振幅調變)
%% =====================================================
pulse = ones(1,Ns);

% 將每個符號 a 展頻成方波 (提示：利用 kron 函數與 pulse 結合)
s_sc = ??; 

t_sc = (0:length(s_sc)-1)/fd;
figure;
plot(t_sc,s_sc);
title('PAM Waveform (Tx)');
xlabel('t');

%% =====================================================
%% 4. Multipath Channel (設定多路徑通道)
%% =====================================================
% 設定延遲 (秒) 與 路徑增益
delay_sec = [0,  0.05, 0.07]; 
amp = [1 -0.95 -0.4];
delay_samples = ??; % 將時間延遲換算成離散化點數，算出現在第幾個1/fd
h = zeros(1,max(delay_samples)+1);
for k = 1:length(delay_samples)
    h(delay_samples(k)+1) = amp(k);
end
figure; stem((0:length(h)-1)*1/fd,h,'filled');
title('Channel Impulse Response h_1(t)');
xlabel('t')

%% =====================================================
%% 5. Each Path Contribution (觀察各路徑成分)
%% =====================================================
% 畫出各路徑成分
path = cell(1,3);
Lmax = 0;
for k=1:3
    path{k} = conv(s_sc,[zeros(1,delay_samples(k)) amp(k)]);
    Lmax = max(Lmax,length(path{k}));
end
for k=1:3
    path{k} = [path{k} zeros(1,Lmax-length(path{k}))];
end
t_path = (0:Lmax-1)/fd;
figure;
plot(t_path,path{1},'k'); hold on;
plot(t_path,path{2},'r');
plot(t_path,path{3},'g');
legend('Path1','Path2','Path3');
title('Multipath Components'); xlabel('t');

%% =====================================================
%% 6. Received PAM Signal (Multipath + AWGN)
%% =====================================================
% 計算通過通道後的訊號 (提示：使用 "conv" 函數卷積 s_sc 與 h)
r_sc_clean = ??; 

noise_pam = sqrt(noise_power) * randn(size(r_sc_clean)); % 加入雜訊
r_sc = r_sc_clean + noise_pam;
t_r = (0:length(r_sc)-1)/fd;
figure;
plot(t_r,r_sc,'b'); hold on;
plot(t_sc,s_sc,'k--');
legend('Received (Noisy+ISI)','Original');
title('PAM with ISI + AWGN'); 
xlabel('t');

%% =====================================================
%% 7. 計算正確的 H (等效通道)
%% =====================================================
Nfft = 32;
% 1. 產生時域 Impulse (測試信號)
test_x = [1 zeros(1, Nfft-1)]; 

% 2. 經過類比傳輸流程
% 將測試 Impulse 轉為方波形式 (提示：利用 kron 與 pulse)
test_wave = ??; 


noise_impluse = sqrt(noise_power) * randn(size(conv(test_wave, h)));
test_rx = conv(test_wave, h)+noise_impluse;

% 3. 接收端取樣 (Downsampling)
h_eff_t = test_rx(Ns:Ns:end); 
figure; stem(0:length(h_eff_t)-1 ,h_eff_t, 'filled'); title('Effective Channel Response h_2[n]');
xlabel('n');

% 4. 轉頻域得到 H_eff
H_eff = fft([h_eff_t zeros(1, Nfft-length(h_eff_t))], Nfft); 
figure; stem(abs(H_eff),'filled');
title('Channel Frequency Response $|H(e^{(j2\pi n/N)})|$', 'Interpreter', 'latex', 'FontSize', 14);
xlabel('n');

%% =====================================================
%% 8. OFDM 資料準備
%% =====================================================
numBlocks = ceil(length(a)/Nfft);
a_pad = [a zeros(1, numBlocks*Nfft - length(a))]; % 補零
A_mat = reshape(a_pad, Nfft, numBlocks); % Reshape: 每 Nfft 個 symbol 排成一個 column

%% =====================================================
%% 9. Case 1: CP = 2 (太短) + AWGN
%% =====================================================
CP_short = 2;
ofdm_tx_short = [];

for b=1:numBlocks
    % IFFT: 對 A_mat 的第 b 個 column 做 IDFT 轉換，可以用"ifft"函數
    x = ??; 
    
    % Add CP: 取 x 的最後 CP_short 點放到最前面，構成 [CP; x]
    ofdm_tx_short = ??; 
end

%  將 OFDM 訊號加載到方波 (提示：使用 kron)
tx_short = ??; 

rx_short_clean = conv(tx_short, h); 
noise_short = sqrt(noise_power) * randn(size(rx_short_clean));
rx_short = rx_short_clean + noise_short;

% RX Sampling (Downsampling)
rx_short_down = rx_short(Ns:Ns:end); 

ptr = 1; 
ofdm_rx_short = [];
for b=1:numBlocks    
    % Remove CP: 從目前的指針 ptr，跳過 CP，取出長度為 Nfft 的訊號
    seg = ??; 
    
    % 將 seg 轉回頻域，可以用"fft" 函數 (記得轉置 .' 以符合維度)
    Y = ??; 
    
    % Zero-Forcing Equalizer: 除以通道響應 H_eff (去除通道影響)，可用"./"
    X_hat = ??; 
    
    ofdm_rx_short = [ofdm_rx_short; X_hat];
    ptr = ptr + Nfft + CP_short;
end

rx_vals_cp2 = real(ofdm_rx_short(1:length(a))).';
figure;
stem(real(rx_vals_cp2(1:length(a))),'filled'); hold on;
stem(a,'r--');
title('recovered real value OFDM CP=2');
xlabel('Symbol Index');

% --- Slicer (Decision) ---
% 1. 反推量化 index
idx_est = round((rx_vals_cp2 - m_min) / delta);
% 2. 限制範圍 (Clamp)
idx_est(idx_est < 0) = 0;
idx_est(idx_est > L-1) = L-1;
% 3. 重建數值
a_recovered_cp2 = idx_est * delta + m_min;

figure;
stem(real(a_recovered_cp2(1:length(a))),'filled'); hold on;
stem(a,'r--');
title('recovered PAM level OFDM CP=2');
xlabel('Symbol Index');

%% =====================================================
%% 10. Case 2: CP = 20 (足夠) + AWGN + 還原
%% =====================================================
CP_long = 20; 
ofdm_tx_long = [];

% TX Process
for b=1:numBlocks
    % IFFT: 對 A_mat 的第 b 個 column 做 IFFT
    x = ??;
    % Add CP: 加上長度為 CP_long 的循環字首
    ofdm_tx_long = ??;
end

% 產生方波 (提示：使用 kron)
tx_long = ??;

rx_long_clean = conv(tx_long, h);
noise_long = sqrt(noise_power) * randn(size(rx_long_clean));
rx_long_noisy = rx_long_clean + noise_long;

% RX Sampling 
rx_long_down = rx_long_noisy(Ns:Ns:end);

% RX Processing
ptr = 1; 
ofdm_rx_long = [];
for b=1:numBlocks
    % Remove CP: 
    seg = ??;
    Y = ??;
    X_hat = ??;
    
    ofdm_rx_long = [ofdm_rx_long; X_hat];
    ptr = ptr + Nfft + CP_long;
end

% 取實部得到接收到的浮點數值
rx_vals_cp20 = real(ofdm_rx_long(1:length(a))).';

figure;
stem(real(rx_vals_cp20(1:length(a))),'filled'); hold on;
stem(a,'r--');
title('recovered real value OFDM CP=20');
xlabel('Symbol Index');

% --- Decision ---
idx_est = round((rx_vals_cp20 - m_min) / delta);
idx_est(idx_est < 0) = 0;
idx_est(idx_est > L-1) = L-1;
a_recovered_cp20 = idx_est * delta + m_min;

% 繪圖比較
figure;
stem(real(a_recovered_cp20(1:length(a))),'filled'); hold on;
stem(a,'r--');
title('recovered PAM level OFDM CP=20');
xlabel('Symbol Index');

% 計算錯誤率
num_errors_cp2 = sum(a_recovered_cp2 ~= a);
num_errors_cp20 = sum(a_recovered_cp20 ~= a);
disp(['Error Rate (cp=2): ', num2str(num_errors_cp2/length(a))]);
disp(['Error Rate (cp=20): ', num2str(num_errors_cp20/length(a))]);