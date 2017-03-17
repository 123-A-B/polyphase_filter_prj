%% �������Ķ����˲��ṹ�ķ����ϵ�����ɣ���������˲����޲����ʱ任����ϵ��Ҳ������ô����
% ʹ��5e5��20e5��Ƶ�ʵ���

clear all; clc, close all;
%% ������ʼ��
fs=50e6;%ԭʼ�źŲ�����
fc=[4e5,2e6];%�ź�Ƶ�㣬fpword=[8,41]
p=[0,0];%�źų�ʼ��λ
a=[1,1];%�źŷ���
D=8;%8����ȡ��
deAddF=[5e5,15e5];%������˲���ͨ�����
% deAddF=[fs/2/D/1.5,fs/2/D];%������˲���ͨ�����
phaseLen=512;%���೤��
signalLen=D*phaseLen;

%% �źŲ���
[t,s]=cosSignalGen(fc,p,a,fs,signalLen);%plot(t,s,'.-') %����1s���������ź�
x=awgn(s,100,'measured');%��������

%% ԭ���˲������--Parks�CMcClellan�㷨
[n0,f0,m0,w]=remezord(deAddF,[1,0],[0.001,0.001],fs);%ԭ���˲�����������%ԭ���˲������� - [ͨ��f,���f],[ͨ��A,���A],[ͨ������,�������],fs
n0=ceil(n0/D)*D;%ȡI�������������Ƴ���Ϊ2���������������˲��ӳٱȽϺü���
b=remez(n0,f0,m0,w);%����ԭ���˲���ϵ��

%% �ź�Ƶ�׺��˲�����Ӧ
figure(1),subplot(311),title('�ź�Ƶ�׺��˲�����Ӧ');
[sf,sp]=myPsdCal(s,fs,length(s)); %��������źŵĹ�����
[bf,bp]=myPsdCal(b,fs,length(b));%�����˲�����Ƶ��Ӧ
plot(sf,sp,'bo-',bf,bp,'r.-'), legend('�ź�Ƶ��','�˲�����Ƶ��Ӧ');
xlabel('f/Hz');ylabel('A/dB');axis tight;
% ��ԭ���˲������ж���ֽ�
h=reshape(b(1:(end-1)),D,[]);%h(k,r)=b((r-1)*I+k);

scale=2^8/max(b);%����hn��λ����������
hn=round(scale*h);%����ϵ��
% ϵ������ͱ���
for k1=1:size(hn,1)
    filename=['./FIR_dec/hdec_',num2str(k1),'.txt'];
    file=fopen(filename,'w');
    for k2=1:size(hn,2)
        fprintf(file,'%d\r\n',hn(k1,k2));
    end
    fclose(file);
end

%% ֱ�ӳ�ȡ�ź�
yd=x(1:D:end);

%% ����ṹ�˲�---û�в����ʱ任��û�ж���ṹ�������Դ������ʱ�ò��Ŷ���ṹ��
xp=reshape(x,D,[]);%����ṹ�����룿��
for k=1:D
    delay=round((size(h,2)-1)/2);%�˲��ӳ�---�����˲����Լ�����ʱ�����䳤�ȵ�һ��
%     delay=size(h,2)/2-1;%�˲��ӳ�---�����˲����Լ�����ʱ�����䳤�ȵ�һ��
    ytmp=conv(xp(k,:),h(k,:));%Ƶ���˲�
    ytmp=circshift(ytmp,[0,-delay]);%ȥ����ʱ
    y1(k,:)=ytmp(1:phaseLen);%ȡ�ź�ʱ��
end
y=sum(y1,1);%���
ty=(0:1:phaseLen-1)/fs*D;%����ʱ��

%% ʱ���λ���
point=64;
figure(1),subplot(312),title('ԭʼ�źź��²����ź�ʱ��ͼ');
plot(t(1:D*point),x(1:D*point),'k.-',ty(1:point),y(1:point),'ro-',ty(1:point),yd(1:point),'b+-'), 
legend('ԭʼ�ź�','����ṹ�²����ź�','ֱ�ӳ�ȡ�ź�');
xlabel('t/s');ylabel('A/v');axis tight;
%% Ƶ�ײ��λ���
figure(1),subplot(313),title('ԭʼ�źź��²����ź�Ƶ��');
[xf,xp]=myPsdCal(x,fs,length(y)); %����ԭʼ�źŵĹ�����
[yf,yp]=myPsdCal(y,fs/D,length(y));%��������˲����źŵĹ�����
[ydf,ydp]=myPsdCal(yd,fs/D,length(yd));%��������˲����źŵĹ�����
plot(xf,xp,'kp-',yf,yp,'ro-',ydf,ydp,'b+-'), 
legend('ԭʼ�źŹ�����','�²����źŵĹ�����','ֱ�ӳ�ȡ�źŹ�����');
xlabel('f/Hz');ylabel('A/dB');axis tight;