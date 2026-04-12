clear; close all; clc;

%% Demonstration 2
% set data samples
N = 2500;
data = randi([0,1],N,4);

%% divide into real and complex region
I_index = bi2de(data(:,1:2), 'left-msb')+1;
Q_index = bi2de(data(:,3:4), 'left-msb')+1;


%% mapping
map_table = [-3,-1,3,1];
I = map_table(I_index);
Q = map_table(Q_index);

Symbol = I + 1j*Q;

%% add AWGN
P_sig = mean(abs(Symbol).^2);
P_noise = P_sig / (10^1.5);

Noise = sqrt(P_noise/2) * (randn(N,1) + 1j*randn(N,1));

%% after pass through ideal channel
demos = Symbol + Noise;

%% Plotting
figure('Position',[100 100 800 600]); 
plot(real(demos), imag(demos), '.', 'MarkerSize', 8); % 畫出接收到的點
hold on;
plot(real(Symbol), imag(Symbol), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % 畫出原始理想的點（紅色圈圈）

% 圖表美化
grid on;
axis equal; % 極重要：確保 I 軸與 Q 軸比例一致，否則星座圖會變形
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title(['16-QAM Constellation (SNR = ', num2str(15), ' dB)']);
legend('Received Symbols', 'Ideal Symbols');


%% homework 2
P_noise_10 = P_sig / (10);

Noise_2 = sqrt(P_noise_10/2) * (randn(N,1) + 1j*randn(N,1));

%% after pass through ideal channel
home = Symbol + Noise_2;

%% Plotting
figure('Position',[100 100 800 600]); 
plot(real(home), imag(home), '.', 'MarkerSize', 8); % 畫出接收到的點
hold on;
plot(real(Symbol), imag(Symbol), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % 畫出原始理想的點（紅色圈圈）

% 圖表美化
grid on;
axis equal; % 極重要：確保 I 軸與 Q 軸比例一致，否則星座圖會變形
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title(['16-QAM Constellation (SNR = ', num2str(10), ' dB)']);
legend('Received Symbols', 'Ideal Symbols');

%% boundary
rx_I = real(home);
rx_Q = imag(home);

det_I = zeros(size(rx_I));
det_Q = zeros(size(rx_Q));

% real part
det_I(rx_I > 2) = 3;
det_I(rx_I <= 2 & rx_I > 0) = 1;
det_I(rx_I < -2) = -3;
det_I(rx_I >= -2 & rx_I < 0) = -1;

% complex part
det_Q(rx_Q > 2) = 3;
det_Q(rx_Q <= 2 & rx_Q > 0) = 1;
det_Q(rx_Q < -2) = -3;
det_Q(rx_Q >= -2 & rx_Q < 0) = -1;

bound = det_I + det_Q*1j;

%% Plotting bound
figure('Position',[100 100 800 600]); 
plot(real(Symbol), imag(Symbol), 'ro', 'MarkerSize', 10, 'LineWidth', 2); % 理想點
hold on;
plot(real(bound), imag(bound), 'gx', 'MarkerSize', 10, 'LineWidth', 2); % 判決後的點

% 圖表美化
grid on;
axis equal;
xlabel('In-phase (I)');
ylabel('Quadrature (Q)');
title(['16-QAM Constellation with Decision Boundaries (SNR = ', num2str(10), ' dB)']);
legend('Ideal Symbols','Detected Symbols');

%% SER Calculation Support
% 1. 找出判決錯誤的符號總數
num_symbol_errors = sum(Symbol ~= bound); 

% 2. 計算比例
SER = num_symbol_errors / N;

% 3. 顯示結果
fprintf('--- Homework 2 Results ---\n');
fprintf('Total Symbols: %d\n', N);
fprintf('Error Count: %d\n', num_symbol_errors);
fprintf('Symbol Error Rate (SER): %.4f\n', SER);
fprintf('Average SER: %.4f\n', sum(SER)/N);



