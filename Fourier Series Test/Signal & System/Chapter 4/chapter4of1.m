% FS1.m : Matlab program for Fourier series
clear all;
T=pi; w=2*pi/T;
fc=@(t,k,w) (cos(2.*t)+sin(t).^2-sin(t).*cos(3*t)).*cos(k.*w.*t);
fs=@(t,k,w) (cos(2.*t)+sin(t).^2-sin(t).*cos(3*t)).*sin(k.*w.*t);
A0=1/T*integral(@(t) fc(t,0,w),0,pi);
for k=1:3
 A(k)=2/T*integral(@(t) fc(t,k,w),0,pi);
 B(k)=2/T*integral(@(t) fs(t,k,w),0,pi);
end
Spec1='A0 = %5.3f \n';
fprintf(Spec1,A0)
Spec2='A1 = %5.3f, A2 = %5.3f, A3 = %5.3f \n';
fprintf(Spec2,A)
Spec3='B1 = %5.3f, B2 = %5.3f, B3 = %5.3f \n';
fprintf(Spec3,B)
% End of FS1
