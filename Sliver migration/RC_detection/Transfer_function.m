clear; clc; close all; % clear workspace and command terminal

syms s % laplace analysis 
syms Rs Rp Cp % constant component 
syms Ru Cu % unknown component

% Fig 3.(a) analysis
Z1 = (Rp)/(1+(s*Rp*Cp)); % Rp parallel with Cp

Zu_a = Ru + 1/(s*Cu); % unknown component as Ru series to Cu

Zpara_a = parallel2(Z1,Zu_a); % defined Z1 || (Z1 + Zu)

H_a = (Z1/(Z1+Zu_a))*(Zpara_a/(Rs+Zpara_a));

% draw simplified equation
H_simplified_a = simplify(H_a); 
disp('show the Ha(s) simplify result：');
pretty(H_simplified_a);

% steady-state analysis
H_steady_a =limit(H_simplified_a,s,0);
disp("show the (a) steady-state analysis : ");
pretty(H_steady_a);

% Fig 3.(b) analysis
Zb = parallel2(1/(s*Cu),Z1);

Zpara_b = parallel2(Z1,(Ru+Zb));

H_b = (Zb/(Ru+Zb))*(Zpara_b/(Rs+Zpara_b));

% draw simplified equation
H_simplified_b = simplify(H_b); 
disp('show the Hb(s) simplify result：');
pretty(H_simplified_b);

% steady-state analysis
H_steady_b =limit(H_simplified_b,s,0);
disp("show the (b) steady-state analysis : ");
pretty(H_steady_b);

% function declaration

% 2 parameters parallel
function z = parallel2(x,y)
z = (x*y)/(x+y);
end

%% --- Phase 2: Data Bridge to Simulink ---

% 1. defined parameter as a num
Rs_val = 10;      % 10 Ohm
Rp_val = 10000;   % 10 kOhm
Cp_val = 1e-6;    % 1 uF
Ru_val = 100;     % 100 Ohm
Cu_val = 1e-6;    % 1 uF 

% 2. Substitution
% use subs to substitute abstract para to real value
H_numeric = subs(H_simplified_b, ...
                 [Rs, Rp, Cp, Ru, Cu], ...
                 [Rs_val, Rp_val, Cp_val, Ru_val, Cu_val]);

% 3. drive  Extraction
% num_sym and den_sym remain in symbol
[num_sym, den_sym] = numden(H_numeric);

% 4. turn Simulink to vector (Conversion)
numerator_coeffs = sym2poly(num_sym);
denominator_coeffs = sym2poly(den_sym);

% 5. check result
disp('=== Simulink parameters ===');
disp('Numerator coefficient');
disp(numerator_coeffs);
disp('Denominator coefficient');
disp(denominator_coeffs);