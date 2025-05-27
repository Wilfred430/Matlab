% === 使用者輸入部分 ===
% 輸入轉移函數的分子與分母係數（降冪排列）
num = input('請輸入分子係數 (例如 [1]): ', 's');
den = input('請輸入分母係數 (例如 [1 100] 或 [1 2 100]): ', 's');

% 將字串轉為向量
num = str2num(num);
den = str2num(den);

% 建立轉移函數
H = tf(num, den);

% 繪製波特圖
figure;
bode(H);
grid on;
title('Bode Plot with 3dB Cutoff Frequencies');

% 取得波特圖資料
[mag, ~, w] = bode(H);
mag = squeeze(mag); % 壓縮維度
mag_dB = 20*log10(mag); % 轉換為 dB

% 找出所有 mag_dB <= -3 的索引
threshold = -3; % 3dB 點
below_3dB = mag_dB <= threshold;

% 找出從上到下穿過 -3dB 的點（上升沿檢測）
cross_indices = find(diff([0; below_3dB]) == 1); % 上升沿：從 false 變 true

% 對應的角頻率與 Hz 頻率
w_3dB = w(cross_indices);
f_3dB = w_3dB / (2*pi);

% 顯示結果
if isempty(f_3dB)
    disp('找不到任何 3dB 點。');
else
    fprintf('找到 %d 個 3dB 點:\n', length(f_3dB));
    for i = 1:length(f_3dB)
        fprintf('   %.2f Hz\n', f_3dB(i));
    end
end

% 在波特圖中標記所有 3dB 點
[~, phase, w_plot] = bode(H, w);
mag_plot = 20*log10(squeeze(mag));

figure(1); % 回到波特圖
hold on;
for i = 1:length(f_3dB)
    plot([f_3dB(i), f_3dB(i)], ylim, 'r--'); % 垂直紅色虛線
    text(f_3dB(i), max(mag_plot) - 5, sprintf('%.2f Hz', f_3dB(i)), ...
         'HorizontalAlignment','center', 'Color','r');
end
hold off;