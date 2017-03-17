%% ԭʼ���˲��ṹ

clear all; clc, close all;
%% ������ʼ��
fs=4e3;
fc=[1e2,6.5e2,7e2];%�ź�Ƶ�㣬�������ں������һ���ź�
p=[0,0,pi/2];%�źų�ʼ��λ
a=[1,1,1];%�źŷ���
D=8;%8����ȡ��
phaseLen=8*512;%���೤��
signalLen=D*phaseLen;

%% �źŲ���
[t,s]=cosSignalGen(fc,p,a,fs,signalLen);%plot(t,s,'.-') %����1s���������ź�
x=awgn(s,50,'measured');%��������

%% ԭ���˲������--Parks�CMcClellan�㷨
[n0,f0,m0,w]=remezord([150,200],[1,0],[0.001,0.001],fs);%ԭ���˲�����������%ԭ���˲������� - [ͨ��f,���f],[ͨ��A,���A],[ͨ������,�������],fs
n0=ceil(n0/D)*D*2;%ȡD�������������Ƴ���Ϊ2���������������˲��ӳٱȽϺü���
b=remez(n0,f0,m0,w);%����ԭ���˲���ϵ��

%% �ź�Ƶ�׺��˲�����Ӧ
figure(1),subplot(211),title('�ź�Ƶ�׺��˲�����Ӧ');
[sf,sp]=myPsdCal(s,fs,length(s)); %��������źŵĹ�����
[bf,bp]=myPsdCal(b,fs,length(b));%��������źŵĹ�����
plot(sf,sp,'bo-',bf,bp,'r.-'), legend('�ź�Ƶ��','�˲�����Ƶ��Ӧ');
xlabel('f/Hz');ylabel('A/dB');axis tight;
% ��ԭ���˲������ж���ֽ�
h=reshape(b(1:(end-1)),D,[]);%h(k,r)=b((r-1)*I+k);

%% ���źŽ���ֱ��Ƶ���˲�
N=length(x);
delay=round(length(b)/2)-1;%�˲��ӳ�
% y1=ifft(fft(x,N).*fft(b,N));%Ƶ���˲�
y1=conv(x,b);%Ƶ���˲�
y1=circshift(y1,[0,-delay]);
y1=y1(1:length(t));
Point=128;
figure(1),subplot(212),title('�˲���ǰ����ź�');
plot(t(1:Point),x(1:Point),'bo-',t(1:Point),y1(1:Point),'r.-');legend('�˲�ǰ','ֱ���˲���');
xlabel('t/s');ylabel('A/v');axis tight;


%% ����ṹ�˲�---û�в����ʱ任��û�ж���ṹ�������Դ������ʱ�ò��Ŷ���ṹ��
% for k=1:D
%     xphase(k,:)=circshift(x,[0,k-1]);%xʱ��
%     yphase(k,:)=circshift(b,[0,k-1]);%xʱ��
%     %     x_tmp=ifft(fft(xphase(k,:),signalLen).*fft(h(k,:),signalLen));%�˲�
%     x_tmp=conv(xphase(k,:),yphase(k,:));%Ƶ���˲�
%     x_tmp=circshift(x_tmp,[0,-delay]);
%     x_tmp=x_tmp(:,1:signalLen);
%     y2(k,:)=x_tmp;
%     %         figure(2),plot(t,x,'b.-',t,xphase(k,:),'ro-'),pause
% end
% y2=y2(:);
% y2=y2(1:D:end);%�²���
% figure(1),subplot(212),title('�˲���ǰ����ź�');
% plot(t,x,'bo-',t,y1,'r.-',t,y2,'kx-');legend('�˲�ǰ','ֱ���˲���','�����˲���');hold on;

