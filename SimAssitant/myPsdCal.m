function [f,pf]=myPsdCal(s,fs,N)
%���㹦�����ܶ�dB�����������һά�����ݡ�
%% ����ͼ��
pf=abs(fftshift(fft(s)));
pf=pf/max(pf);
pf=20*log10(pf);
f=linspace(-fs/2,fs/2,length(s));

% WELCH��
% LenWin=N;
% window=blackman(LenWin); %blackman�� 
% noverlap=round(N/2); %�������ص�  
% range='centered'; %'onesided'  | 'twosided' | 'centered'
% [pf,f]=pwelch(s,window,noverlap,N,fs,range); 
% pf=10*log10(pf/max(pf));


end