clear; clc; close all; % clear workspace and command terminal

syms s % laplace analysis 
syms Rs Rp Cp % constant component 
syms Ru Cu % unknown component


Z1 = (Rp)/(1+(s*Rp*Cp)); % Rp parallel with Cp

Zu = Ru + 1/(s*Cp); % unknown component as Ru series to Cu

Zpara = parallel(Z1,Zu); % defined Z1 || (Z1 + Zu)

H = (Z1/(Z1+Zu))*(Zpara/(Rs+Zpara));

% draw simplified equation
H_simplified = simplify(H); 
disp('show the H(s) simplify result：');
pretty(H_simplified);

% steady-state analysis
H_steady =limit(H_simplified,s,0);
disp("show the steady-state analysis : ");
pretty(H_steady);

% function declaration
function z = parallel(x,y)
z = (x*y)/(x+y);
end