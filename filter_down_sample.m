%% ��������ԭʼ�˲��ṹ
% ������fs>8e3��D=8ʱ��Ҫ�Ƚ���fs/2/8=500�Ŀ�����˲������У��������Խ��˲���ʹ�ö����˲��ṹ�����²���֮��ִ�С�

clear all; clc, close all;
%% ������ʼ��
fs=8e3;%ԭʼ�źŲ�����
fc=[5e2,11.5e2,14e2];%�ź�Ƶ�㣬�������ں������һ���ź�
p=[0,0,pi/2];%�źų�ʼ��λ
a=[1,1,0.8];%�źŷ���
D=4;%8����ȡ��
deAddF=[600,1000];%������˲���ͨ�����
% deAddF=[fs/2/D/1.5,fs/2/D];%������˲���ͨ�����
phaseLen=512;%���೤��
signalLen=D*phaseLen;

%% �źŲ���
[t,s]=cosSignalGen(fc,p,a,fs,signalLen);%plot(t,s,'.-') %����1s���������ź�
x=awgn(s,100,'measured');%��������

%% ԭ���˲������--Parks�CMcClellan�㷨
[n0,f0,m0,w]=remezord(deAddF,[1,0],[0.001,0.001],fs);%ԭ���˲�����������%ԭ���˲������� - [ͨ��f,���f],[ͨ��A,���A],[ͨ������,�������],fs
n0=ceil(n0/D)*D*2;%ȡI�������������Ƴ���Ϊ2���������������˲��ӳٱȽϺü���
b=remez(n0,f0,m0,w);%����ԭ���˲���ϵ��

%% �ź�Ƶ�׺��˲�����Ӧ
figure(1),subplot(311),title('�ź�Ƶ�׺��˲�����Ӧ');
[sf,sp]=myPsdCal(s,fs,length(s)); %��������źŵĹ�����
[bf,bp]=myPsdCal(b,fs,length(b));%�����˲�����Ƶ��Ӧ
plot(sf,sp,'bo-',bf,bp,'r.-'), legend('�ź�Ƶ��','�˲�����Ƶ��Ӧ');
xlabel('f/Hz');ylabel('A/dB');axis tight;

%% ���źŽ���ֱ��Ƶ���˲�
N=length(x);
delay=round(length(b)/2)-1;%�˲��ӳ�
% y1=ifft(fft(x,N).*fft(b,N));%Ƶ���˲�
y1=conv(x,b);%Ƶ���˲�
y1=circshift(y1,[0,-delay]);
y1=y1(1:length(t));

%% ֱ�ӳ�ȡ�ź�
yd=y1(1:D:end);
td=(0:phaseLen-1)/fs*D;

%% ��ͼ
Point=64;
figure(1),subplot(312),title('ԭʼ��ȡ���׶ε��ź�');
plot(t(1:Point*D),x(1:Point*D),'k.-',t(1:Point*D),y1(1:Point*D),'b+',td(1:Point),yd(1:Point),'ro-');legend('�˲�ǰ','ֱ���˲���','��ȡ��');
xlabel('t/s');ylabel('A/v');axis tight;

figure(1),subplot(313),title('ԭʼ�źź��²����ź�Ƶ��');
[xf,xp]=myPsdCal(x,fs,length(x)); %����ԭʼ�źŵĹ�����
[yf,yp]=myPsdCal(y1,fs,length(y1));%����ֱ���˲����źŵĹ�����
[ydf,ydp]=myPsdCal(yd,fs/D,length(yd));%��������˲����źŵĹ�����
plot(xf,xp,'kp-',yf,yp,'ro-',ydf,ydp,'b+-'), 
legend('ԭʼ�źŹ�����','�˲���Ĺ�����','��ȡ��Ĺ�����');
xlabel('f/Hz');ylabel('A/dB');axis tight;