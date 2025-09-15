% NMOS 工作區域圖
clear; clc;

% 參數設定
Vth = 1;              % 閾值電壓 (V)
Vgs_max = 5;          % 最大 Vgs
Vds_max = 5;          % 最大 Vds

% 建立網格
[VGS, VDS] = meshgrid(0:0.05:Vgs_max, 0:0.05:Vds_max);

% 區域判斷
cutoff_region    = (VGS < Vth);
linear_region    = (VGS >= Vth) & (VDS < (VGS - Vth));
saturation_region = (VGS >= Vth) & (VDS >= (VGS - Vth));

% 繪圖
figure;
hold on;
% 填色區域
fill([0 Vth Vth 0], [0 0 Vds_max Vds_max], [0.9 0.9 0.9], 'EdgeColor', 'none'); % Cut-off 灰色
contourf(VGS, VDS, linear_region, [1 1], 'FaceColor', [0.6 0.8 1], 'EdgeColor', 'none'); % Linear 藍色
contourf(VGS, VDS, saturation_region, [1 1], 'FaceColor', [1 0.6 0.6], 'EdgeColor', 'none'); % Saturation 紅色

% 邊界線 (Vds = Vgs - Vth)
Vgs_line = linspace(Vth, Vgs_max, 200);
plot(Vgs_line, Vgs_line - Vth, 'k', 'LineWidth', 2);

% 標籤與外觀
xlabel('V_{GS} (V)');
ylabel('V_{DS} (V)');
title('NMOS 工作區域圖');
legend('Cut-off', 'Linear', 'Saturation', 'Boundary V_{DS} = V_{GS} - V_{th}', ...
       'Location', 'northwest');
grid on;
axis([0 Vgs_max 0 Vds_max]);
hold off;