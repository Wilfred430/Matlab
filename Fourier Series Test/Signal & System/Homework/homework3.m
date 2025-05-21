clear all;
T = 3; % Period
w = 2*pi/T; % Angular frequency

% Define the piecewise function f(t)
f = @(t) (t >= -1 & t < 1).*(t + 1) + (t >= 1 & t < 2).*(sin(pi*t/2));

% Fourier series coefficient function (complex form)
fk = @(t, k, w) f(t).*exp(-1i*k*w*t);

% Calculate C0 (constant term)
C0 = 1/T * integral(@(t) fk(t, 0, w), -1, 2);

% Initialize arrays for storing results
C = zeros(1, 5);
k_vals = [-2, -1, 0, 1, 2];

% Calculate Fourier coefficients C(k) for k = -2, -1, 0, 1, 2
for idx = 1:5
    k = k_vals(idx);
    C(idx) = 1/T * integral(@(t) fk(t, k, w), -1, 2);
end

% Display results for C(-2), C(-1), C(0), C(1), C(2)
fprintf('Complex Fourier Coefficients (Ck):\n');
for idx = 1:5
    k = k_vals(idx);
    fprintf('C%d = %5.3f + %5.3fi\n', k, real(C(idx)), imag(C(idx)));
end

% Calculate amplitude and phase
amplitudes = abs(C);
phases = angle(C);

% Display amplitude and phase
fprintf('\nAmplitudes and Phases:\n');
for idx = 1:5
    k = k_vals(idx);
    fprintf('Amplitude of C%d = %5.3f, Phase of C%d = %5.3f radians\n', ...
        k, amplitudes(idx), k, phases(idx));
end