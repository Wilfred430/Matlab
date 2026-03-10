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
m_scale  = ??;   %try max() function
m_normal = ??;

s_AM = A*(1 + ka*m_normal).*carrier;

figure; plot(t,s_AM); title('DSB-LC Signal');

%% ================== 2. Envelop Detector ==================
v_diode = ??;  %通過二極體之後的電壓，try to use ".*" 

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
        v_env(n) = ??;     % 放電，請參考第(1)式
    end
end

figure;
plot(t,v_env,'b'); hold on;
plot(t,A*(1+ka*m_normal),'r--','LineWidth',1.2);
legend('Envelope Output','True Envelope');
title('After Diode + RC (Envelope Detector)');

%% ================== 3️. RC Low-Pass Filter ==================
% 這個才是真正取出 m(t) 的濾波器
fc_lpf = 1200;                % > fm 但 << fc
RC_lpf = 1/(2*pi*fc_lpf);

alpha = dt/(RC_lpf + dt);
v_lpf = zeros(size(v_env));

for n = 2:length(v_env)
    v_lpf(n) = ??;          % 請參考第(3)式
end

figure;
plot(t,v_lpf,'b'); hold on;
plot(t,A*(1+ka*m_normal),'r--');
legend('After LPF','Ideal Envelope');
title('After Additional Low-Pass Filter');

%% ================== 4️. 還原原始訊號 ==================
m_rec = ??;
m_rec = m_rec * m_scale;

figure;
plot(t,m,'k','LineWidth',1.5); hold on;
plot(t,m_rec,'r','LineWidth',1.2);
legend('Original Message','Recovered Message');
title('Final Recovered Signal');


%% ============================================================
%% ===================== DSB-SC ===============================
%% ============================================================

s_SC = A * m .* carrier;

figure; plot(t,s_SC);
title('DSB-SC Signal');

%% ===== Coherent Detection =====
theta = 0;   % 改成 pi/6, pi/3, pi/2 看失真

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
    cohe_lpf(n) = ??;
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





