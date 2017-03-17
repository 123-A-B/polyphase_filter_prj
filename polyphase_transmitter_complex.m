%% 8·�����˲��ŵ���������ߵ緢���MATLAB�������
% ���ź�����Ķ����˲����ŵ��������
% ����汾+��������I��1��ʾ����+����ѭ��

clear all; clc, close all;
%% ������ʼ��
I=8;%8·
fc=(1:I)*0.5;%��������Ƶ��(kHz)
% fc=8.0*ones(1,I);%��������Ƶ��(kHz)
Fs=50.0;%����Ƶ������
fs=Fs*I;%���������
% K=2.0;%��Ƶָ��
R=1.56;%ԭ�͵�ͨ�˲�������ϵ��
signalLen=200;%�������źų���

%% ԭ���˲������--Parks�CMcClellan�㷨
[n0,f0,m0,w]=remezord([Fs/(2*R) Fs/2],[1,0],[0.001,0.001],fs);%ԭ���˲�����������%ԭ���˲������� - [ͨ��f,���f],[ͨ��A,���A],[ͨ������,�������],fs
n0=ceil(n0/I)*I*2;%ȡI�������������Ƴ���Ϊ2���������������˲��ӳٱȽϺü���
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
for r=1:signalLen %ÿһ·�źŰ���n1+I��������
    mfft=ifft(m(:,r));%��ÿһ������ʱ�̵�I·�źţ�������ɢ����Ҷ���任
    x0(:,r)=mfft.'.*exp(1j*pi/I*(0:(I-1)));%����
end

%% �����˲�+����
for k=1:I%ÿһ·�źŰ���n1+I��������
    delay=size(h,2)/2-1;%�˲��ӳ�
    y_tmp=I*ifft(fft(x0(k,:),signalLen).*fft(h(k,:),signalLen));
    y_tmp=circshift(y_tmp,[0,-delay]);%ʱ������
    y_phase(k,:)=y_tmp;%���ڽ��ն˶Ա�
%     subplot(211),plot(1:signalLen,x0(k,:),'bo-',1:signalLen, y_phase(k,:),'r.-')
%     [ft1,pt1]=myPsdCal(x0(k,:),2*pi);
%     [ft2,pt2]=myPsdCal(y_phase(k,:),2*pi);
%     subplot(212),plot(ft1, pt1,'bo-',ft2,pt2,'r.-'),pause
    y(k,:)=y_tmp.*(-1).^(0:signalLen-1);%����
end
%% �ڲ�I�����ӳ��������
yout=y(:);

%% Ƶ�׻���
% yt=awgn(yout,30,'measured');
yt=yout;%����ȡ��ʲô�ô���
f=fs/length(yt)*(1:length(yt));

pComplex=abs(fft(yt));%����Ƶ��
figure(2);
plot(f,20*log10(pComplex/max(pComplex)));grid on;title('�����źŵ�Ƶ��');%�˲�����Ƶ����
ylim([-150,1]);xlabel('f/Hz');ylabel('A/dB');

% save('polyphase_transmitter_complex.mat','yt','m','t','h');