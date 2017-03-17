%% 8·�����˲��ŵ���������ߵ緢���MATLAB�������
% ʵ�ź�����Ķ����˲����ŵ��������
% ����汾+��������I��1��ʾ����+����ѭ��

clear all; clc, close all;
%% ������ʼ��
I=8;%8·
fc=(1:I)*1;%��������Ƶ��(kHz)
% fc=2.0*ones(1,I);%��������Ƶ��(kHz)
Fs=50.0;%����Ƶ������
fs=Fs*I*2;%���������---���Ǻ͸����źŵ�����
K=2.0;%��Ƶָ��
R=1.56;%ԭ�͵�ͨ�˲�������ϵ��
signalLen=200;%�������źų���

%% ԭ���˲������--ԭ���˲�������2����������Ӱ��
[n0,f0,m0,w]=remezord([Fs/(2*R) Fs/2],[1,0],[0.001,0.001],fs);%ԭ���˲������� - [ͨ��f,���f],[ͨ��A,���A],[ͨ������,�������],fs
N=(n0-mod(n0,I))/I+1;%ȡI��������
n0=I*N*2;%���Ƴ���Ϊ2���������������˲��ӳٱȽϺü���
b=remez(n0,f0,m0,w);%����ԭ���˲���ϵ��
%% ��ԭ���˲������ж���ֽ�
h=reshape(b(1:(end-1)),I,[]);%h(k,r)=b((r-1)*I+k);
h=circshift(h,[1,0]);

%% �����źŲ���
for k=1:I%����I·�ź�
    t=0:signalLen-1;%����ʱ��
    m(k,:)=cos(2*pi*fc(k)/Fs*t+k/pi);%����0��Ƶ�����źű��ڲ鿴Ч����ÿһ��ͨ������һ�������ź�
end

%% IFFT+����
for r=1:signalLen%ÿһ·�źŰ���n1+I��������
    mfft=ifft(m(:,r));%��ÿһ������ʱ�̵�I·�źţ�������ɢ����Ҷ���任
    x0(:,r)=mfft.'.*exp(1j*pi/2/I*(0:(I-1)));%����
end

%% ��������2���ڲ�
z=zeros(size(x0,1),2*size(x0,2));%�ڲ�0
z(:,1:2:end)=x0;%�����㸳ֵ

%% �����˲�+����
for k=1:I%ÿһ·�źŰ���n1+I��������
    delay=size(h,2)/2-1;%�˲��ӳ�
    y0=I*conv(z(k,:),h(k,:));%����˲����˲�������I����
    y0=y0((delay+1):(signalLen*2+delay));%�ӳ�����
%         plot(1:length(z(k,:)),abs(z(k,:)),'k',1:length(y0),abs(y0),'r');legend('ԭʼ�ź�','�˲����ź�');pause
    y(k,:)=y0.*exp(1j*pi/2*(0:signalLen*2-1));%����
end
%% �ڲ�I��
yout=y(:);
% plot(real(yout),'.-')%����Ҫ�˲���������Ƶ�����ڰ��Ƶ�Ч����

%% Ƶ�׻���
% yy=awgn(yout,30,'measured');
yy=yout;%����ȡ��ʲô�ô���
f=fs/length(yy)*(1:length(yy));
%�Ը����źŷ���--�ɼ�ǰ�����ӵ�2����ȡʵ���˽�Ƶ�μ���ӳ�1���Ĺ���
pComplex=abs(fft(yy));%����Ƶ��
figure(2);subplot(2,1,1)
plot(f,20*log10(pComplex/max(pComplex)));grid on;title('�����źŵ�Ƶ��');%�˲�����Ƶ����
ylim([-60,0])

%ȡʵ��������źŷ���
yt=real(yy);%ȡʵ��
pReal=abs(fft(yt));%����Ƶ��
figure(2);subplot(2,1,2)
plot(f,20*log10(pReal/max(pReal)));grid on;title('ʵ���źŵ�Ƶ��');%�˲�����Ƶ����
ylim([-60,0]);xlabel('f/Hz');ylabel('A/dB');

% save('polyphase_transmitter_real.mat','yt','m','t','h');