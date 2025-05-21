clear all;  % 清除工作區中所有的變數，確保執行時不會有殘留的數據
T = 3;  % 設定週期 T 為 3
w = 2 * pi / T;  % 計算角頻率 w，公式為 w = 2*pi/T
fc = @(t,k,w) (2*t-1) .* cos(k .* w .* t);  % (2*t-1) 與 cos(k*w*t) 相乘的部分
fs = @(t,k,w) (2*t-1) .* sin(k .* w .* t);  % (2*t-1) 與 sin(k*w*t) 相乘的部分
fcc = @(t,k,w) 3 .* cos(k .* w .* t);  % 常數 3 與 cos(k*w*t) 相乘的部分
fss = @(t,k,w) 3 .* sin(k .* w .* t);  % 常數 3 與 sin(k*w*t) 相乘的部分
A0 = 1/T * (integral(@(t) fc(t,0,w), 0, 2) + integral(@(t) fcc(t,0,w), 2, 3));
for k = 1:5
    % 計算餘弦項 A(k)，積分分為兩段 (從 t=0 到 t=2 的 fc 及 t=2 到 t=3 的 fcc)
    A(k) = 2/T * (integral(@(t) fc(t,k,w), 0, 2) + integral(@(t) fcc(t,k,w), 2, 3));
    
    % 計算正弦項 B(k)，積分分為兩段 (從 t=0 到 t=2 的 fs 及 t=2 到 t=3 的 fss)
    B(k) = 2/T * (integral(@(t) fs(t,k,w), 0, 2) + integral(@(t) fss(t,k,w), 2, 3));
end
% 打印 A0 的值，格式為 "A0 = x.xxx"
Spec1 = 'A0 = %5.5f \n';
fprintf(Spec1, A0)
Spec2 = 'A1 = %5.5f, A2 = %5.5f, A3 = %5.5f, A4 = %5.5f, A5 = %5.5f \n';
fprintf(Spec2, A)
Spec3 = 'B1 = %5.5f, B2 = %5.5f, B3 = %5.5f, B4 = %5.5f, B5 = %5.5f \n';
fprintf(Spec3, B)
