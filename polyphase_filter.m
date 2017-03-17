%% ԭʼ�����Ķ����˲��ṹ
% ������fs>8e3��D=8ʱ��Ҫ�Ƚ���fs/2/8=500�Ŀ�����˲������У��������Խ��˲���ʹ�ö����˲��ṹ�����²���֮��ִ�С�
% ���⣺fc���õ�Ƶ�㵼��fc-n*fs���˲�������Χ��ʱ�������˲������׵����˲����ɾ�

clear all; clc, close all;
%% ������ʼ��
fs=8e3;%ԭʼ�źŲ�����
fc=[1e2,6.5e2,7e2];%�ź�Ƶ�㣬�������ں������һ���ź�
p=[0,0,pi/2];%�źų�ʼ��λ
a=[1,1,0.6];%�źŷ���
D=8;%8����ȡ��
deAddF=[200,300];%������˲���ͨ�����
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
% ��ԭ���˲������ж���ֽ�
h=reshape(b(1:(end-1)),D,[]);%h(k,r)=b((r-1)*I+k);


%% ����ṹ�˲�---û�в����ʱ任��û�ж���ṹ�������Դ������ʱ�ò��Ŷ���ṹ��
xp=reshape(x,D,[]);%����ṹ������
y2=zeros(D,signalLen);%���
for k=1:D
%     delay=round((size(h,2)-1)/2);%�˲��ӳ�---�����˲����Լ�����ʱ�����䳤�ȵ�һ��
    delay=size(h,2)/2-1;%�˲��ӳ�---�����˲����Լ�����ʱ�����䳤�ȵ�һ��
    ytmp=conv(xp(k,:),h(k,:));%Ƶ���˲�
    ytmp=circshift(ytmp,[0,-delay]);%ȥ����ʱ
    y1(k,:)=ytmp(1:phaseLen);%ȡ�ź�ʱ��
    y1tmp=repmat(y1(k,:),D,1);
    y2(k,:)=circshift(y1tmp(:),[k-1,0]);
end
y=sum(y2,1);%���
ty=(0:1:signalLen-1)/fs;%����ʱ��
%% ʱ���λ���
point=64;
figure(1),subplot(312),title('ԭʼ�źźͶ����˲�ʱ��ͼ');
plot(t(1:D*point),x(1:D*point),'k.-',ty(1:D*point),y(1:D*point),'ro-'), 
legend('ԭʼ�ź�','�����˲��ź�');
xlabel('t/s');ylabel('A/v');axis tight;
%% Ƶ�ײ��λ���
figure(1),subplot(313),title('ԭʼ�źźͶ����˲�Ƶ��');
[xf,xp]=myPsdCal(x,fs,length(y)); %����ԭʼ�źŵĹ�����
[yf,yp]=myPsdCal(y,fs/D,length(y));%��������˲����źŵĹ�����
plot(xf,xp,'kp-',yf,yp,'ro-'), 
legend('ԭʼ�źŹ�����','�����˲��źŵĹ�����');
xlabel('f/Hz');ylabel('A/dB');axis tight;