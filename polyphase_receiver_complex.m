%% 8·�����˲��ŵ���������ߵ���ջ�MATLAB�������
% ���ź�����Ķ����˲����ŵ������ջ�
% ���⣺
% 1��δ֪�źŹ����ںδ���С�ˣ�%--�������ź��²����ĵط�����Ŵ�
% 2���źŻ�ԭ����λΪʲôƫ���ˣ�--�²�����Ƿ�����߽��ջ���һ���ط�����λû�г˶ԡ�
% 3��Ϊʲô���յ���mͨ���ͷ����mͨ��֮���෴�ˣ�%--�������²�����תһ��yr=flipud(yr);

polyphase_transmitter_complex;
% clear all; clc, close all;
%% ������ʼ��
% I=8;%8·
% fc=(1:I)*0.5;%��������Ƶ��(kHz)
% % fc=8.0*ones(1,I);%��������Ƶ��(kHz)
% Fs=50.0;%����Ƶ������
% fs=Fs*I;%���������
% R=1.56;%ԭ�͵�ͨ�˲�������ϵ��
% load polyphase_transmitter_complex.mat
% signalLen=length(yt)/I;%�������źų���

% h=fliplr(h);%ƥ���˲��Ƿ���Ҫ��

%% �����ź��ӳ�+�²���+����+�����˲�
for k=1:I
    yr(k,:)=yt(k:I:end).'.*(-1).^(0:signalLen-1);%���ƣ��뷢���y0��ͬ
	% �����˲�
    delay=size(h,2)/2;%�˲��ӳ٣�ǰ���1�����ﲻ�ü�1����
    x_tmp=I*ifft(fft(yr(k,:),signalLen).*fft(h(k,:),signalLen));%�˲�
    x(k,:)=circshift(x_tmp,[0,-delay]);%ʱ������
%     plot(1:signalLen,yr(k,:),'bo-',1:signalLen,x(k,:),'r.-')
end

%% ����+IFFT
for r=1:signalLen%ÿһ·�źŰ���n1+I��������
    mfft(:,r)=x(:,r).'.*exp(-1j*pi/I*(0:(I-1)));%����
    mhat(:,r)=ifft(mfft(:,r));%��ÿһ������ʱ�̵�I·�źţ�������ɢ����Ҷ���任
end

%% ���Ƶ��
figure,
% �޸�������ԭ��ͬ�ĵط�����1����������
index=[1,I:-1:2];%Ϊʲôͨ���Ķ�Ӧ˳�����������أ�ĳ���ط�����λ�����˰ɣ������п������ң����������¡�
for k=1:I%����I·�ź�
    %Ƶ��ȥ��
    mf=fft(mhat(k,:));
    thrd_mf=max(abs(mf))/2;%��ֵ����
    mf(abs(mf)<thrd_mf)=0;
    mhat(k,:)=ifft(mf);%��ԭʱ���ź�
    subplot(4,2,k);plot(t,I*real(mhat(index(k),:)),'.-', t,m(k,:),'ro-');legend('���ս���ź�','ԭʼ�����ź�');% pause()%�鲿��cos
end
%I=4ʱ1-1,2-4,3-3,4-2
% I=8ʱ1-1,2-8,3-7,4-6,5-5...