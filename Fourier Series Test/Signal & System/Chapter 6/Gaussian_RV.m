% Generate and plot PDF and CDF of Log-Normal distribution
m = 0; % Mean of ln(y)
sigma = 2 * sqrt(2); % Standard deviation
y = linspace(0.01, 10, 1000); % Range for y-axis (y > 0)

% Calculate Log-Normal PDF
pdf = (1 ./ (y * sqrt(2*pi) * sigma)) .* exp(-((log(y) - m).^2) / (2 * sigma^2));

% Calculate Log-Normal CDF
cdf = 0.5 * (1 + erf((log(y) - m) ./ (sigma * sqrt(2))));

% Plot PDF
figure;
subplot(2,1,1);
plot(y, pdf, 'b-', 'LineWidth', 2);
title('Log-Normal PDF');
xlabel('y');
ylabel('Probability Density');
grid on;

% Plot CDF
subplot(2,1,2);
plot(y, cdf, 'r-', 'LineWidth', 2);
title('Log-Normal CDF');
xlabel('y');
ylabel('Cumulative Probability');
grid on;