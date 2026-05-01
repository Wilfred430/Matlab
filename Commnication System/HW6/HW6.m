%% OFDM System Simulation (Homework1) - Full Robust Version
clear; clc; close all;

%% 1. 系統參數設定 (Parameters)
Nsym = 2400;          % Number of OFDM symbols
Nfft = 128;           % FFT size
Ncp  = Nfft/8;        % CP size (16 samples)
Nact = 24;            % Active subcarriers

%% 2. 發射端 (Transmitter)
% QAM Mapping (16-QAM)
M = 16;
bits = randi([0 M-1], Nact, Nsym); 
qamSymbols = qammod(bits, M, 'UnitAveragePower', true);

% Subcarrier Mapping (Insert into FFT bins)
X = zeros(Nfft, Nsym);
X(2:Nact+1,:) = qamSymbols;   % 將有效載波放在低頻區段

% IFFT (OFDM modulation)
x = ifft(X, Nfft);

% Add Cyclic Prefix
x_cp = [x(end-Ncp+1:end,:); x];

% Serialize (Data Stream)
txSig = x_cp(:);

%% ==========================================
%% 第一部分：特定延遲 (Delay = 4) 的接收與分析
%% ==========================================
delay = 4;   
h = [0.9, zeros(1, delay-1), 0.6];  % 建立二徑通道脈衝響應

% 通道卷積 (Channel)：使用 filter 確保因果性與長度一致
rxSig = filter(h, 1, txSig);

% 接收端處理 (Receiver)
rxSig_matrix = reshape(rxSig, Nfft+Ncp, Nsym); % 轉回矩陣
rx_noCP = rxSig_matrix(Ncp+1:end,:);           % 移除 CP
Y = fft(rx_noCP, Nfft);                        % FFT 轉回頻域

% 通道頻率響應與一階等化器 (One-tap FEQ)
H = fft([h zeros(1, Nfft-length(h))], Nfft).'; 
Yeq = Y ./ H;

% 擷取有效子載波並進行 QAM 解調
rxQAM = Yeq(2:Nact+1,:);
rxBits = qamdemod(rxQAM, M, 'UnitAveragePower', true);

% 計算 MSE
mse_fixed = mean(abs(rxBits(:) - bits(:)).^2);
fprintf('【單點分析】當 Delay = %d 時，系統的 MSE = %.6f\n', delay, mse_fixed);

% 繪圖 1：等化後的 QAM 符號 (實部)
figure;
plot(real(rxQAM(:)), '.', 'MarkerSize', 2);
xlabel('Symbol Index'); 
ylabel('Real Part Amplitude');
title(sprintf('Equalized 16-QAM Symbols (Real Part) - Delay = %d', delay));
grid on;

%% ==========================================
%% 第二部分：Delay Sweep (尋找系統崩潰點)
%% ==========================================
maxDelay = 30;   % 擴大測試範圍到 30，以觀察超過 CP(16) 後的急遽惡化
mse_values = zeros(1, maxDelay);  

for d = 1:maxDelay
    h_test = [0.9, zeros(1,d-1), 0.6];
    
    % 使用 filter 取代 conv('same')
    rx_test_sig = filter(h_test, 1, txSig);
    rx_test = reshape(rx_test_sig, Nfft+Ncp, Nsym);
    rx_noCP_test = rx_test(Ncp+1:end,:);
    
    Y_test = fft(rx_noCP_test, Nfft);
    H_test = fft([h_test zeros(1,Nfft-length(h_test))], Nfft).';
    Yeq_test = Y_test ./ H_test;
    
    rxQAM_test = Yeq_test(2:Nact+1,:);
    rxBits_test = qamdemod(rxQAM_test, M, 'UnitAveragePower', true);
    
    mse_values(d) = mean(abs(rxBits_test(:) - bits(:)).^2);
end

% 繪圖 2：懸崖效應 (MSE vs. Delay)
figure;
plot(1:maxDelay, mse_values, 'o-', 'LineWidth', 2, 'MarkerFaceColor', 'b');
hold on;
xline(Ncp, '--r', ['CP Boundary (d = ' num2str(Ncp) ')'], ...
    'LineWidth', 1.5, 'LabelVerticalAlignment', 'bottom');
xlabel('Second path delay (samples)');
ylabel('Mean Square Error (MSE)');
title('OFDM Performance: MSE vs. Multipath Delay');
grid on;

crash_point = find(mse_values > 0.1, 1);
if ~isempty(crash_point)
    fprintf('【掃描分析】經過系統實測，當 Delay 達到 %d samples 時，MSE 開始急遽上升！\n', crash_point);
end