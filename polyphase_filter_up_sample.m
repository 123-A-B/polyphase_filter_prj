%% �������Ķ����˲��ṹ
% ������fs=4e3��I=8ʱ��Ҫ�����fs/2�Ŀ�����˲������У��������Խ��˲���ʹ�ö����˲��ṹ�����²���֮��ִ�С�

clear all; clc, close all;
%% ������ʼ��
fs=2e3;%ԭʼ������
fc=[1e2,5e2];%�ź�Ƶ�㣬�������ں������һ���ź�
p=[0,0];%�źų�ʼ��λ
a=[1,1];%�źŷ���
I=8;%8���ڲ���
deAddF=[fs/2/2,fs/2];%������˲���ͨ�����
phaseLen=512;%���೤��
signalLen=I*phaseLen;

%% �źŲ���
[t,s]=cosSignalGen(fc,p,a,fs,phaseLen);%plot(t,s,'.-') %����1s���������ź�
x=awgn(s,100,'measured');%��������

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
% ��ԭ���˲������ж���ֽ�
h=reshape(b(1:(end-1)),I,[]);%h(k,r)=b((r-1)*I+k);
% h=circshift(h,[1,0]);%�����ᵼ�´���

%% ֱ�Ӳ�ֵ�ź�
yu=zeros(1,signalLen);
yu(1:I:end)=x;

%% ����ṹ�˲�---û�в����ʱ任��û�ж���ṹ�������Դ������ʱ�ò��Ŷ���ṹ��
xp=repmat(x,I,1);%����ṹ������
for k=1:I
    delay=size(h,2)/2;%�˲��ӳ�---�����˲����Լ�����ʱ�����䳤�ȵ�һ��
%     delay=round((size(h,2)-1)/2);%�˲��ӳ�---�����˲����Լ�����ʱ�����䳤�ȵ�һ��
    ytmp=I*conv(xp(k,:),h(k,:));%Ƶ���˲�
    ytmp=circshift(ytmp,[0,-delay]);%ȥ����ʱ
    y1(k,:)=ytmp(1:phaseLen);%ȡ�ź�ʱ��
end
y=y1(:);%�������
ty=(0:1:signalLen-1)/fs/I;%����ʱ��
%% ʱ���λ���
point=64;
figure(1),subplot(312),title('ԭʼ�źź��������ź�ʱ��ͼ');
plot(t(1:point),x(1:point),'k.-',ty(1:I*point),y(1:I*point),'ro-',ty(1:I*point),yu(1:I*point),'b+-'), 
legend('ԭʼ�ź�','�����������ź�','ֱ�Ӳ�ֵ�ź�');
xlabel('t/s');ylabel('A/v');axis tight;
%% Ƶ�ײ��λ���
figure(1),subplot(313),title('ԭʼ�źź��������ź�Ƶ��');
[xf,xp]=myPsdCal(x,fs,length(x)); %����ԭʼ�źŵĹ�����
[yf,yp]=myPsdCal(y,fs*I,length(x));%��������˲����źŵĹ�����
[yuf,yup]=myPsdCal(yu,fs*I,length(x));%��������˲����źŵĹ�����
plot(xf,xp,'kp-',yf,yp,'ro-',yuf,yup,'b+-'), 
legend('ԭʼ�ź�','�����������ź�','ֱ�Ӳ�ֵ�ź�');
xlabel('f/Hz');ylabel('A/dB');axis tight;