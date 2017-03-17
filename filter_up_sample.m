%% ��������ԭʼ�˲��ṹ
% ������fs=2e3��I=8ʱ��Ҫ�����fs/2�Ŀ�����˲������У��������Խ��˲���ʹ�ö����˲��ṹ�����²���֮��ִ�С�

clear all; clc, close all;
%% ������ʼ��
fs=2e3;%ԭʼ������
fc=[1e2,6.5e2,7e2];%�ź�Ƶ�㣬�������ں������һ���ź�
p=[0,0,pi/2];%�źų�ʼ��λ
a=[1,1,0.8];%�źŷ���
I=8;%8���ڲ���
deAddF=[fs/2,fs/2+100];%������˲���ͨ�����
phaseLen=512;%���೤��
signalLen=I*phaseLen;

%% �źŲ���
[t,s]=cosSignalGen(fc,p,a,fs,phaseLen);%plot(t,s,'.-') %����1s���������ź�
x=awgn(s,5,'measured');%��������

%% ԭ���˲������--Parks�CMcClellan�㷨
[n0,f0,m0,w]=remezord(deAddF,[1,0],[0.001,0.001],fs*I);%ԭ���˲�����������%ԭ���˲������� - [ͨ��f,���f],[ͨ��A,���A],[ͨ������,�������],fs
n0=ceil(n0/I)*I*2;%ȡI�������������Ƴ���Ϊ2���������������˲��ӳٱȽϺü���
b=remez(n0,f0,m0,w);%����ԭ���˲���ϵ��

%% �ź�Ƶ�׺��˲�����Ӧ
figure(1),subplot(311),title('�ź�Ƶ�׺��˲�����Ӧ');
[sf,sp]=myPsdCal(s,fs,length(s)); %��������źŵĹ�����
[bf,bp]=myPsdCal(b,fs*I,length(b));%�����˲�����Ƶ��Ӧ
plot(sf,sp,'bo-',bf,bp,'r.-'), legend('ԭʼ�ź�Ƶ��','�˲�����Ƶ��Ӧ');
xlabel('f/Hz');ylabel('A/dB');axis tight;

%% ֱ�Ӳ�ֵ�ź�
yu=zeros(1,signalLen);
yu(1:I:end)=x;
tu=(0:signalLen-1)/fs/I;
% yu=repmat(x,I,1);%ʹ�ø���ǰһ���ķ���ʵ��upSampling
% yu=yu(:)';
% yu = yu/I;

%% ���źŽ���ֱ��Ƶ���˲�
N=length(x);
delay=round(length(b)/2)-1;%�˲��ӳ�
% y1=ifft(fft(x,N).*fft(b,N));%Ƶ���˲�
y=I*conv(yu,b,'same');%Ƶ���˲�
% y=circshift(y,[0,-delay]);
% y=y(1:length(t));

%% ��ͼ
Point=64;
figure(1),subplot(312),title('ԭʼ���������׶ε��ź�');
plot(t(1:Point),x(1:Point),'k.-',tu(1:Point*I),yu(1:Point*I),'b+',tu(1:Point*I),y(1:Point*I),'ro-');legend('ԭʼ�ź�','ֱ�Ӳ�ֵ��','�˲���');
xlabel('t/s');ylabel('A/v');axis tight;

figure(1),subplot(313),title('ԭʼ�źź��������ź�Ƶ��');
[xf,xp]=myPsdCal(x,fs,length(x)); %����ԭʼ�źŵĹ�����
[yuf,yup]=myPsdCal(yu,fs*I,length(yu));%����ֱ���˲����źŵĹ�����
[yf,yp]=myPsdCal(y,fs*I,length(y));%��������˲����źŵĹ�����
plot(xf,xp,'kp-',yuf,yup,'b+-',yf,yp,'ro-'), 
legend('ԭʼ�źŹ�����','��ֵ��ĵĹ�����','�˲���Ĺ�����');
xlabel('f/Hz');ylabel('A/dB');axis tight;
