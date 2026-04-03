clear; close all; clc;

%% Part 1: Demonstration (Analog Modulation)
% parameter setting
fs = 100;        % sample frequency
fm = 1/64;
fc = 1/4;
a = 0.3;
T = 300;
t = 0:1/fs:T-1/fs;

% signal
x = 1 + a*sin(2*pi*fm*t);   
figure;
plot(t,x,'k');
title('original message x(t)');
xlabel('t (s)'); ylabel('Amplitude');

% modulation
y_demo = x .* cos(2*pi*fc*t);
figure;
plot(t,y_demo,'k');
title('modulation signal y(t)');
xlabel('t (s)'); ylabel('Amplitude');

% demodulation
z_demo = y_demo .* cos(2*pi*fc*t);
figure;
plot(t,z_demo,'k');
title('demodulation signal z(t)');
xlabel('t(s)'); ylabel('Amplitude');

% 進行濾波
L = round(fs / (2 * fc)); % 理想 window size
x_recover = movmean(z_demo, L, 'Endpoints', 'shrink');

% demonstration 繪圖比較
figure;
plot(t, x, 'r', 'LineWidth', 1.5);      
hold on;
plot(t, x_recover, 'b--', 'LineWidth', 1.5); 
hold off;
xlabel('Time (s)'); ylabel('Amplitude');
title('Demonstration: Comparison of x and x\_recover');
legend('x (original)', 'x\_recover', 'Location', 'best');
grid on;



%% Part 2: Homework (Complex Modulation)

% 1. 生成 I-branch 與 Q-branch 訊號
I = rectpuls(t - 150, 100); 
Q = tripuls(t - 150, 100);

figure;
subplot(2,1,1); plot(t,I,"k"); title('Original I-branch (Rectangular)'); ylim([-0.2 1.2]);
subplot(2,1,2); plot(t,Q,"k"); title('Original Q-branch (Triangular)'); ylim([-0.2 1.2]);

% 2. 實數運算調變 (Real Operations)
I_p = sqrt(2) .* cos(2*pi*fc*t) .* I;
Q_p = -sqrt(2) .* sin(2*pi*fc*t) .* Q;
x_real = I_p + Q_p;

figure;
plot(t,x_real,"k");
title('Transmitted Signal: x_{real}(t)');
xlabel('t (s)'); ylabel('Amplitude');

% 3. 複數運算調變
x_b = I + 1i.*Q;
x_com = real(x_b .* (sqrt(2) .* exp(1i*2*pi*fc*t)));

% 計算誤差
error_signal = abs(x_real - x_com);
fprintf('The maximum error between real and complex operation is: %e\n', max(error_signal));

% 4. 接收與解調 (Demodulation)
y = x_real; % Assume no channel effect

y1 = y .* (sqrt(2) .* cos(2*pi*fc*t));
y2 = y .* (-sqrt(2) .* sin(2*pi*fc*t));

figure;
subplot(2,1,1); plot(t,y1,"k"); title('Mixed Signal y_1(t)');
subplot(2,1,2); plot(t,y2,"k"); title('Mixed Signal y_2(t)');

% 通過低通濾波器 (LPF)
z1 = movmean(y1, L, 'Endpoints', 'shrink');
z2 = movmean(y2, L, 'Endpoints', 'shrink');

% 5. 解調結果比較繪圖
figure;
subplot(2,1,1);
plot(t, I, 'r', 'LineWidth', 1.5); hold on;
plot(t, z1, 'b--', 'LineWidth', 1.5); hold off;
title('I-branch Recovery'); legend('Original I', 'Recovered z_1'); ylim([-0.2 1.2]); grid on;

subplot(2,1,2);
plot(t, Q, 'r', 'LineWidth', 1.5); hold on;
plot(t, z2, 'b--', 'LineWidth', 1.5); hold off;
title('Q-branch Recovery'); legend('Original Q', 'Recovered z_2'); ylim([-0.2 1.2]); grid on;