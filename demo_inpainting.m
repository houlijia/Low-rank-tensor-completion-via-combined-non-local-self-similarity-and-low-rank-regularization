clc
clear all
close all
addpath(genpath('lib'));
addpath(genpath('testData'));
%% ��һ�ࣺ����
% ������PPT�Ȼ������Լ���Ҫ�����ߣ�Ȼ�󱣴�� .png ��ʽ��ͼƬ����matlab������
load('sails.mat');
Ori = X.*255;
%Ori = double(imread('sailboat.bmp'));        % ԭʼ����ͼ��
X   = double(imread('ppt1.png'));    % �������ߵ�ppt�����ͼƬ
X   = X( 19:274,44:299);                  % ���������߽س� 256*256 ͼ��
%17:272, 1019:1274  656:911,108:363
X = 255 - X;
known = find( X < 255 );                  % ����ֵ������0��255֮�䣬������ֵС��255�ı��0
X(known) = 0;
XX = zeros(size(Ori));
XX(:,:,1) = X;
XX(:,:,2) = X;
XX(:,:,3) = X;
index = find( XX == 255 );               % ��֪���λ��
data  = Ori(index);                      % ��֪�������ֵ
Obe   = zeros(size(Ori));
Obe(index) = data;                       % �����۲�ͼ��
figure,imshow(uint8(Obe));

Y_tensorT = double(Ori)./255;
X = Y_tensorT;
data = double(data)./255;
known = index;
Y_tensor0 = double(Obe)./255;
%% �ڶ��ࣺ���֡���ĸ

I = double(imread('house.bmp'))/255;
text_str = cell(3,1);
conf_val = [85.212 98.76 78.342]; 
for ii=1:3
   text_str{ii} = ['Confidence: ' num2str(conf_val(ii),'%0.2f') '%'];
end
position = [23 373;35 185;77 107]; 
RGB = insertText(I,position,text_str,'FontSize',18,'BoxColor',...
   'w','BoxOpacity',0,'TextColor','white');
figure
imshow(RGB)


%% �����ࣺ��ɫ����
% �����

Ori = double(imread('house.bmp'));
[n1,n2,~] = size(Ori);
% 
X = ones( n1, n2 )*255;
a = [2:5, 44:46, 74:77, 80:81, 102:103, 134:135, 165:166, 183:184, 223:226, 246:247];    % 2:5 �ӵڶ��п�ʼ�����Ϊ4������    % �������
b = [16:17, 26:30, 44:45, 54:55, 86:87, 136:137, 139:141, 200:201, 238:241, 249:250];    % 26:30 �ӵ�26�п�ʼ�����Ϊ5������
X(a,:) = 0;
X(:,b) = 0;

XX = ones(size(Ori))*255;
XX(:,:,1) = X;
XX(:,:,2) = X;
XX(:,:,3) = X;
index = find( XX == 255 );
data  = Ori(index);
Obe   = zeros(size(Ori));
Obe(index) = data;              % �����۲�ͼ��
figure,imshow(uint8(Obe));

%% �����ࣺ��עͼ��ĳ������
% ��MATLAB�У�ʹ��roipoly��ѡ��һ������Ȥ����ROI�����ú���������һ������ε�ROI;
% �������÷�Ϊ��B = roipoly��f��c��r����
%     ����fΪҪ�����ͼ��c��r�ֱ���ROI�Ķ����Ӧ��������������꣨��˳�����У�
%     BΪһ����ֵͼ�񣬴�С��f��ͬ��ROI֮��Ϊ0��֮��Ϊ1��
%     ͼ��Bͨ�����������������ڸ��������ڵ�һ��ģ�塣
%     ���������ԭ�������Ͻǡ�

Ori = double(imread('house.bmp'));
roipoly
% figure, imshow(B);

XX = zeros(size(Ori));
XX(:,:,1) = B;
XX(:,:,2) = B;
XX(:,:,3) = B;

index = find( XX == 0 );
data  = Ori(index);
Obe   = zeros(size(Ori));
Obe(index) = data;              % �����۲�ͼ��
figure,imshow(uint8(Obe));
