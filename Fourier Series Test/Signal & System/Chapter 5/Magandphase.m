% FS4.m : Matlab program for exponential Fourier series
clear all;
T=5;
w0=2*pi/T;
f=@(t,jk,w) 2.*exp(-1.*jk.*w.*t);
N=20+1;
for n=1:N
 jk=i*(n-1);
 k(n)=n-1;
 c(n)=1/T*integral(@(t) f(t,jk,w0),-1,1);
 if abs(c(n))<1e-6
 c(n)=0;
 end
 magc(n)=abs(c(n));
 phasec(n)=angle(c(n));
end
ax1=nexttile;
stem(ax1,k,magc,'filled')
title('magc(n)')
ax2=nexttile;
stem(ax2,k,phasec,'filled')
title('phasec(n)')
% End of FS4.m