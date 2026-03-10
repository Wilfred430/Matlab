close all; % 關閉所有繪圖視窗
clear all; % 清除所有workspace內變數資料
clc; % 清除command window上的執行結果

% 以上指令建議打在每個主程式的開頭，但不要打在作為function的m-file內

% 參數範例
a1 = 1; a2 = pi; % scalar
b1 = [1,2,3,4] % vector
  % 若程式中某行指令沒打分號會在執行程式時在command window顯示結果
b2 = 0:1.5:2^4; % vector
b3 = linspace(0,1,4); % vector
c1 = [1,2;3 4]; % matrix
c2 = [b1;b3]; % matrix
c3 = [0:0.2:1; eye(2), rand(2,4)]; % matrix
d1 = 'hello word'; % char

% 運算範例
x = (a1+a2)*cos(2^4)*exp(0.5); % 一般數學運算
y = c2*b1.'; % 矩陣乘法請注意維度
 % .' : 矩陣轉置運算
 % ' : 矩陣共扼轉置運算
 
% elementwise operation
z1 = b1.*b3; 
z2 = c1./c1;
z3 = cos(c3);


% 函數宣告範例
d2 = functionexample(a1,d1);



