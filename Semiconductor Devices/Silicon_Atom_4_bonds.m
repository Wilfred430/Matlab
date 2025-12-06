% Si 原子電子殼層視覺化
clear; clc;

figure('Name','Si 原子電子殼層與共價鍵形成','Color','w');

% 子圖 1：原始電子組態
subplot(1,2,1);
hold on;
title('孤立 Si 原子電子組態');
rectangle('Position',[0.5 0.5 1 1],'Curvature',[1 1],'EdgeColor','k'); % 1s
rectangle('Position',[1.5 1.5 2 2],'Curvature',[1 1],'EdgeColor','b'); % 2s/2p
rectangle('Position',[3.5 3.5 3 3],'Curvature',[1 1],'EdgeColor','r'); % 3s/3p

text(1,1,'1s^2','HorizontalAlignment','center');
text(2.5,2.5,'2s^2 2p^6','HorizontalAlignment','center');
text(5,5,'3s^2 3p^2','HorizontalAlignment','center');

axis equal; axis off;

% 子圖 2：形成共價鍵後的有效滿殼
subplot(1,2,2);
hold on;
title('形成共價鍵後（sp^3 混成）');
rectangle('Position',[0.5 0.5 1 1],'Curvature',[1 1],'EdgeColor','k'); % 1s
rectangle('Position',[1.5 1.5 2 2],'Curvature',[1 1],'EdgeColor','b'); % 2s/2p
rectangle('Position',[3.5 3.5 3 3],'Curvature',[1 1],'EdgeColor','g'); % sp3

text(1,1,'1s^2','HorizontalAlignment','center');
text(2.5,2.5,'2s^2 2p^6','HorizontalAlignment','center');
text(5,5,'sp^3 → 3s^2 3p^6','HorizontalAlignment','center');

% 顯示四個共價鍵方向
for theta = 45:90:360
    x = 5 + cosd(theta);
    y = 5 + sind(theta);
    plot([5 x],[5 y],'g','LineWidth',2);
    text(x,y,'共價鍵','Color','g','FontSize',8);
end

axis equal; axis off;