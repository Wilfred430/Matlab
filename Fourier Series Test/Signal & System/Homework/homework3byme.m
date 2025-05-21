clear;
clc;

% 定義範圍與常數
k_values = -2:2;
Ck_abs = zeros(size(k_values));  % 用來儲存 Ck 的絕對值
Ck_phase = zeros(size(k_values));  % 用來儲存 Ck 的 phase 角
pi_val = pi;

% 計算 Ck 的公式
for idx = 1:length(k_values)
    k = k_values(idx);
    
    % 避免 k = 0 的情況，因為分母中有 k
    if k == 0
        Ck = 0;
    else
        % 根據你提供的最新公式
        Ck = (1i / (pi_val * k)) * exp(-1i * (2 * pi_val / 3) * k) - ...
             (3 * 1i / (2 * pi_val^2 * k^2)) * sin((2 * pi_val / 3) * k) - ...
             (12 / (pi_val * (16 * k^2 - 9))) * exp(-1i * 4/3 * pi_val * k) - ...
             (16 * k * 1i / (pi_val * (16 * k^2 - 9))) * exp(-1i * 2 /3 * pi_val * k);
    end
    
    % 儲存 Ck 的絕對值和 phase 角
    Ck_abs(idx) = abs(Ck);
    Ck_phase(idx) = angle(Ck);  % 相位角使用 angle 函數
end

% 輸出結果
fprintf('Ck 絕對值:\n');
disp(Ck_abs);
fprintf('Ck phase 角:\n');
disp(Ck_phase);

% 若需要繪圖顯示：
figure;
subplot(2,1,1);
stem(k_values, Ck_abs, 'filled');
title('Ck 絕對值');
xlabel('k');
ylabel('|Ck|');

subplot(2,1,2);
stem(k_values, Ck_phase, 'filled');
title('Ck 相位角');
xlabel('k');
ylabel('Phase (radians)');
