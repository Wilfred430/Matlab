clear; close all; clc;

%% ================== 基本參數 ==================
fd = 8000; % Discretization frequency
T  = 1;
t  = 0:1/fd:T-1/fd;

fc = 1000;      % 載波
fm = 100;       % 訊號頻率
ka = 0.8;
A  = 1;

%% ============================================================
%% ===================== DSB-C ===============================
%% ================== 原始訊號 ==================
m = 0.1 + 3*cos(2*pi*fm*(t-1.5)/25) - 4*sin(2*pi*fm*(t-0.5)/15);

figure; plot(t,m,'k','LineWidth',1.5);
title('Original Message m(t)');

%% ================== 1. DSB-C ==================
carrier = cos(2*pi*fc*t);

figure;plot(t,carrier);xlim([0,0.01]);ylim([-1.2,1.2]);title("Carrier");

m_scale  = max(m);   %try max() function
m_normal = m/m_scale;

s_AM = A*(1 + ka*m_normal).*carrier;

figure; plot(t,s_AM); title('DSB-C Signal');

%{
%% --- FFT of s_AM (放在計算 s_AM 並畫圖之後) ---
Fs = fd;                % 取樣頻率
x = s_AM;               % 要做 FFT 的訊號
L = length(x);

% 可選：去直流（若要保留包絡的直流成份，可註解此行）
% x = x - mean(x);

% 視需要使用窗（或用 ones(L,1) 不使用窗）
w = hann(L);
xw = x(:) .* w(:);

% zero-padding 提升頻率解析
nfft = 2^nextpow2(L * 4);

Y = fft(xw, nfft);
P2 = abs(Y) / L;                 % 雙邊幅值（正規化）
P1 = P2(1:nfft/2+1);            % 單邊幅值
P1(2:end-1) = 2 * P1(2:end-1);

f = Fs * (0:(nfft/2)) / nfft;   % 頻率向量 (Hz)

% 單邊線性幅值
figure;
plot(f, P1, 'b', 'LineWidth', 1.2);
xlim([0, Fs/2]);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Single-Sided Spectrum of s\_AM (Linear)');
grid on;

% 單邊 dB 幅值
P1db = 20*log10(P1 + eps);
figure;
plot(f, P1db, 'r', 'LineWidth', 1.2);
xlim([0, Fs/2]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Single-Sided Spectrum of s\_AM (dB)');
grid on;

% 若只想放大載波附近範圍（例如 ±2000 Hz 範圍）
zoomBW = 2000;
figure;
plot(f, P1db, 'r','LineWidth',1.0); hold on;
xlim([fc-zoomBW, fc+zoomBW]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title(['s\_AM Spectrum Around Carrier (f_c = ', num2str(fc), ' Hz)']);
grid on;
%}

%% ================== 2. Envelop Detector ==================
v_diode = s_AM .* (s_AM > 0);  %通過二極體之後的電壓，try to use ".*" 

figure; plot(t,v_diode);
title('After Diode');

% 條件：1/fc << RC_env << 1/fm
RC_env = 5/fc;       % 夠大來濾掉載波，但能跟上envelop
dt = 1/fd;

v_env = zeros(size(v_diode));
for n = 2:length(v_diode)
    if v_diode(n) > v_env(n-1)
        v_env(n) = v_diode(n);   % 充電
    else
        v_env(n) =v_env(n-1)*(exp(-dt/RC_env));     % 放電，請參考第(1)式
    end
end

figure;
plot(t,v_env,'b'); hold on;
plot(t,A*(1+ka*m_normal),'r--','LineWidth',1.2);
legend('Envelope Output','True Envelope');
title('After Diode + RC (Envelope Detector)');


%{
%% 對 v_env 做 FFT 與畫圖 ---
Fs = fd;                 % 取樣頻率
x = v_env;               % 要做 FFT 的訊號（已在前面計算）
L = length(x);

% 可選：是否先去直流（取消註解則去直流）
% x = x - mean(x);

% 使用窗以降低洩漏（可改為 ones(L,1) 不使用窗）
w = hann(L);
xw = x(:) .* w(:);

% zero-padding 提升頻率解析的插值（可調整倍率）
nfft = 2^nextpow2(L * 4);

Y = fft(xw, nfft);
P2 = abs(Y) / L;                 % 雙邊幅值（正規化）
P1 = P2(1:nfft/2+1);            % 取單邊
P1(2:end-1) = 2 * P1(2:end-1);  % 除直流與 nyquist 外乘二

f = Fs * (0:(nfft/2)) / nfft;   % 頻率向量 (Hz)

% 繪單邊線性幅值
figure;
plot(f, P1, 'b', 'LineWidth', 1.2);
xlim([0, Fs/2]);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Single-Sided Spectrum of v\_env (Linear)');
grid on;

% 繪單邊 dB 幅值
P1db = 20*log10(P1 + eps); % 加 eps 避免 log10(0)
figure;
plot(f, P1db, 'r', 'LineWidth', 1.2);
xlim([0, Fs/2]);
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Single-Sided Spectrum of v\_env (dB)');
grid on;
%}

%% ================== 3️. RC Low-Pass Filter ==================
% 這個才是真正取出 m(t) 的濾波器
fc_lpf = 1200;                % > fm 但 << fc
RC_lpf = 1/(2*pi*fc_lpf);

alpha = dt/(RC_lpf + dt);
v_lpf = zeros(size(v_env));

for n = 2:length(v_env)
    v_lpf(n) = alpha*v_env(n)+(RC_lpf/(RC_lpf+dt))*v_lpf(n-1);          % 請參考第(3)式
end

figure;
plot(t,v_lpf,'b'); hold on;
plot(t,A*(1+ka*m_normal),'r--');
legend('After LPF','Ideal Envelope');
title('After Additional Low-Pass Filter');


%% ================== 4️. 還原原始訊號 ==================
m_rec = (v_lpf-A)/ka;
m_rec = m_rec * m_scale;

figure;
plot(t,m,'k','LineWidth',1.5); hold on;
plot(t,m_rec,'r','LineWidth',1.2);
legend('Original Message','Recovered Message');
title('Final Recovered Signal');


%% ============================================================
%% ===================== DSB-SC ===============================
%% ============================================================

s_SC = A * m .* carrier; % modulated signal

figure; plot(t,s_SC);
title('DSB-SC Signal');

%% ===== Coherent Detection =====
theta = pi/6;   % 改成 pi/6, pi/3, pi/2 看失真

local_carrier = cos(2*pi*fc*t + theta);
coher = s_SC .* local_carrier;

figure;
plot(t,coher);
title('After Multiplying with Local Carrier');

%% ===== RC Low-Pass Filter =====
fm_cutoff = 100;        % 要大於 message 頻寬
RC = 1/(2*pi*fm_cutoff);
dt = 1/fd;
alpha = dt/(RC + dt);

cohe_lpf = zeros(size(coher));
for n = 2:length(coher)   
    cohe_lpf(n) = alpha*coher(n)+(RC/(RC+dt))*cohe_lpf(n-1);
end

figure;
plot(t,cohe_lpf,'b','LineWidth',1.2);
title('After Low-Pass Filter');

%% ===== Recover Message =====
m_rec_SC = (2/(A*cos(theta))) * cohe_lpf;   

figure;
plot(t,m_rec_SC,'b--','LineWidth',1.2);hold on;
plot(t,m,'k','LineWidth',1.5); 
legend('Recovered DSB-SC','Original');
title(['DSB-SC Coherent Detection, \theta = ', num2str(theta)]);
xlabel('t');




