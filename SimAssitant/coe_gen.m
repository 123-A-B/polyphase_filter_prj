%% ���Ҳ��źŵĲ������û�*.mif�ļ������
clear,clc,close all;
bitWidth=8;%λ��
addrWidth=10;%��ַλ��
romLen=2^addrWidth;%ROM����
t=(0:romLen-1)/romLen*2*pi;%ʱ��
data=floor(2^(bitWidth-1)*sin(t));
data=2^(bitWidth-1)+data;

h=fopen('sinwave.coe','w');
fprintf(h,'MEMORY_INITIALIZATION_RADIX=10;\r\n');%����10���Ʊ�ʾ������
fprintf(h,'MEMORY_INITIALIZATION_VECTOR=\r\n');%����10���Ʊ�ʾ������
for k=1:length(data)-1
    if data(k)>2^bitWidth-1
        data(k)=2^bitWidth-1;
    end
    fprintf(h,'%d,\r\n',data(k));
end
fprintf(h,'%d;\r\n',data(end));
fclose(h);

%% DDSƵ�ʼ��㹫ʽ
fclk=50e6;%ʱ��Ƶ��
fprintf('������Ƶ��Ϊ%e����С���Ƶ��Ϊ[����]%e\n',fclk/2,fclk/romLen);
% ����fword�������Ƶ��
fword=1;%Ƶ�ʿ�����
pword=0;%��λ������
fout=fword*fclk/romLen;%Ƶ�ʼ���
pout=pword*2*pi/romLen;%��λ����
fprintf('fword=%d,pword=%dʱ �����Ƶ��f=%e�� �������T=%e �������λp=%e \n',...
                fword,pword,fout,1/fout,pout);

%���Ʋ���ͼ
% data_out=data(1:fword:end);
% t_out=t(1:fword:end);
% stairs(t_out,data_out,'r');axis tight;

% ����f_target����fword����������Ƶ����fclk/2
ftarget=4e5;%Ŀ��Ƶ��
ptarget=0;%Ŀ����λ
fword=round(romLen*ftarget/fclk);%Ƶ��->Ƶ�ʿ�����
pword=round(romLen*ptarget/2/pi);%��λ->��λ������
fprintf('fword=%d,pword=%dʱ�����Ƶ��Ϊf=%e�� �������T=%e����λΪp=%f\n',...
                fword,   pword,  fword*fclk/romLen,  romLen/fword/fclk,     pword*2*pi/romLen);
%���Ʋ���ͼ
% data_out=data(1:fword:end);
% t_out=t(1:fword:end);
% stairs(t_out,data_out,'r');axis tight;
