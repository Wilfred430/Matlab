% FT1.m : Matlab program for Fourier transform
clear all;
dw=0.01;
func=@(t,jw) 2.*exp(-1.*jw.*t);
N=1000;
for n=1:N
 jw=i*n*dw;
 w(n)=n*dw;
 F(n)=integral(@(t) func(t,jw),-1,1);
 T(n)=abs(F(n))+real(F(n));
 magF(n)=abs(F(n));
 phaseF(n)=angle(F(n));
 if T(n)<1e-6
 phaseF(n)=pi;
 end
end
ax1=nexttile;
plot(ax1,w,magF)
yline(5,'w')
title('magF')
ax2=nexttile;
plot(ax2,w,phaseF)
yline(4,'w')
title('phaseF')
% End of FT1.m
