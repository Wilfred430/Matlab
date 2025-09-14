% Diamond structure with cubic guide lines
clc; clear; close all;

a = 5.43; % 晶格常數 (Å) - Silicon

% FCC 基底
fcc_atoms = a * [...
    0 0 0;
    0.5 0.5 0;
    0.5 0 0.5;
    0 0.5 0.5];

% 偏移晶格
offset = a * [0.25 0.25 0.25];
diamond_atoms = [fcc_atoms; fcc_atoms + offset];

figure;
scatter3(diamond_atoms(:,1), diamond_atoms(:,2), diamond_atoms(:,3), ...
    200, 'filled', 'MarkerFaceColor', [0.2 0.6 1]); hold on;

% 畫 cubic 輔助線
cube_edges = [...
    0 0 0; a 0 0;
    a 0 0; a a 0;
    a a 0; 0 a 0;
    0 a 0; 0 0 0;
    0 0 a; a 0 a;
    a 0 a; a a a;
    a a a; 0 a a;
    0 a a; 0 0 a;
    0 0 0; 0 0 a;
    a 0 0; a 0 a;
    a a 0; a a a;
    0 a 0; 0 a a];

for i = 1:2:size(cube_edges,1)
    plot3(cube_edges(i:i+1,1), cube_edges(i:i+1,2), cube_edges(i:i+1,3), ...
        'k-', 'LineWidth', 1.2);
end

axis equal;
xlabel('x (Å)'); ylabel('y (Å)'); zlabel('z (Å)');
title('Diamond Structure with Cubic Guide Lines');
grid on;
xlim([0 a]); ylim([0 a]); zlim([0 a]);