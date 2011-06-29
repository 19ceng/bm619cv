clear;
FileInfo = imfinfo('C:\corner.tif');
[ImageData,map] = imread('C:\corner.tif');

if(strcmp('truecolor',FileInfo.ColorType) == 1)
   ImageData = im2uint8(rgb2gray(ImageData));
elseif(strcmp('indexed',FileInfo.ColorType) == 1)
   ImageData = im2uint8(ind2gray(ImageData,map));  
end    
ori_im=ImageData;
%ori_im = imread('arroyo-r.tiff');     % ��ȡͼ��

% fx = [5 0 -5;8 0 -8;5 0 -5];          % ��˹����һ��΢�֣�x����(���ڸĽ���Harris�ǵ���ȡ�㷨)
fx = [-2 -1 0 1 2];                 % x�����ݶ�����(����Harris�ǵ���ȡ�㷨)
Ix = filter2(fx,ori_im);              % x�����˲�
% fy = [5 8 5;0 0 0;-5 -8 -5];          % ��˹����һ��΢�֣�y����(���ڸĽ���Harris�ǵ���ȡ�㷨)
fy = [-2;-1;0;1;2];                 % y�����ݶ�����(����Harris�ǵ���ȡ�㷨)
Iy = filter2(fy,ori_im);              % y�����˲�
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;
clear Ix;
clear Iy;

h= fspecial('gaussian',[7 7],2);      % ����7*7�ĸ�˹��������sigma=2

Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

height = size(ori_im,1);
width = size(ori_im,2);
result = zeros(height,width);         % ��¼�ǵ�λ�ã��ǵ㴦ֵΪ1

R = zeros(height,width);

Rmax = 0;                              % ͼ��������Rֵ
for i = 1:height
    for j = 1:width
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];             % auto correlation matrix
        R(i,j) = det(M)-0.06*(trace(M))^2;                     % ����R
        if R(i,j) > Rmax
            Rmax = R(i,j);
        end;
    end;
end;

cnt = 0;
for i = 2:height-1
    for j = 2:width-1
        % ���зǼ������ƣ����ڴ�С3*3
        if R(i,j) > 0.01*Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
            result(i,j) = 1;
            cnt = cnt+1;
        end;
    end;
end;

[posc, posr] = find(result == 1);
cnt                                      % �ǵ����
imshow(ori_im);
hold on;
plot(posr,posc,'r+');

