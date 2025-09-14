% Zinc-blende structure with cubic guide lines
clc; clear; close all;

a = 5.65; % 晶格常數 (Å) - GaAs

% Ga 原子 (FCC)
Ga_atoms = a * [...
    0 0 0;
    0.5 0.5 0;
    0.5 0 0.5;
    0 0.5 0.5];

% As 原子 (偏移)
offset = a * [0.25 0.25 0.25];
As_atoms = Ga_atoms + offset;

figure;
scatter3(Ga_atoms(:,1), Ga_atoms(:,2), Ga_atoms(:,3), ...
    200, 'filled', 'MarkerFaceColor', [1 0.4 0.4]); hold on;
scatter3(As_atoms(:,1), As_atoms(:,2), As_atoms(:,3), ...
    200, 'filled', 'MarkerFaceColor', [0.4 1 0.4]);

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
title('Zinc-Blende Structure with Cubic Guide Lines');
legend('Ga atoms', 'As atoms');
grid on;
xlim([0 a]); ylim([0 a]); zlim([0 a]);