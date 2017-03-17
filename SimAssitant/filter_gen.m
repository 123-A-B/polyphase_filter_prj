%% ԭʼ���˲��ṹ

clear all; clc, close all;
%% ������ʼ��
fs=50e6;
fc=[2e5,10e5];%�ź�Ƶ�㣬�������ں������һ���ź�
deAddF=[2.5e5,9e5];%������˲���ͨ�����
p=[0,0];%�źų�ʼ��λ
a=[1,1];%�źŷ���
signalLen=1024;

%% �źŲ���
[t,s]=cosSignalGen(fc,p,a,fs,signalLen);%plot(t,s,'.-') %����1s���������ź�
x=awgn(s,50,'measured');%��������

%% ԭ���˲������--Parks�CMcClellan�㷨
[n0,f0,m0,w]=remezord(deAddF,[1,0],[0.001,0.001],fs);%ԭ���˲�����������%ԭ���˲������� - [ͨ��f,���f],[ͨ��A,���A],[ͨ������,�������],fs
n0=64;
b=remez(n0,f0,m0,w);%����ԭ���˲���ϵ��

%% �ź�Ƶ�׺��˲�����Ӧ
figure(1),subplot(211),title('�ź�Ƶ�׺��˲�����Ӧ');
[sf,sp]=myPsdCal(s,fs,length(s)); %��������źŵĹ�����
[bf,bp]=myPsdCal(b,fs,length(b));%��������źŵĹ�����
plot(sf,sp,'bo-',bf,bp,'r.-'), legend('�ź�Ƶ��','�˲�����Ƶ��Ӧ');
xlabel('f/Hz');ylabel('A/dB');axis tight;

%% ���źŽ���ֱ��Ƶ���˲�
N=length(x);
delay=round(length(b)/2)-1;%�˲��ӳ�
y1=conv(x,b);%Ƶ���˲�
y1=circshift(y1,[0,-delay]);
y1=y1(1:length(t));
Point=signalLen;
figure(1),subplot(212),title('�˲���ǰ����ź�');
plot(t(1:Point),x(1:Point),'bo-',t(1:Point),y1(1:Point),'r.-');legend('�˲�ǰ','ֱ���˲���');
xlabel('t/s');ylabel('A/v');axis tight;


% ϵ������ͱ���
h=fopen('hn.txt','w');
scale=2^8/max(b);%����hn��λ����������
for k=1:length(b)
    fprintf(h,'%d\r\n',round(scale*b(k)));
end
fclose(h);
