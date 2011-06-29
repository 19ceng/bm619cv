clear;
FileInfo = imfinfo('C:\corner.tif');
[ImageData,map] = imread('C:\corner.tif');

if(strcmp('truecolor',FileInfo.ColorType) == 1)
   ImageData = im2uint8(rgb2gray(ImageData));
elseif(strcmp('indexed',FileInfo.ColorType) == 1)
   ImageData = im2uint8(ind2gray(ImageData,map));  
end    
ori_im=ImageData;
%ori_im = imread('arroyo-r.tiff');     % 读取图像

% fx = [5 0 -5;8 0 -8;5 0 -5];          % 高斯函数一阶微分，x方向(用于改进的Harris角点提取算法)
fx = [-2 -1 0 1 2];                 % x方向梯度算子(用于Harris角点提取算法)
Ix = filter2(fx,ori_im);              % x方向滤波
% fy = [5 8 5;0 0 0;-5 -8 -5];          % 高斯函数一阶微分，y方向(用于改进的Harris角点提取算法)
fy = [-2;-1;0;1;2];                 % y方向梯度算子(用于Harris角点提取算法)
Iy = filter2(fy,ori_im);              % y方向滤波
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;
clear Ix;
clear Iy;

h= fspecial('gaussian',[7 7],2);      % 产生7*7的高斯窗函数，sigma=2

Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

height = size(ori_im,1);
width = size(ori_im,2);
result = zeros(height,width);         % 纪录角点位置，角点处值为1

R = zeros(height,width);

Rmax = 0;                              % 图像中最大的R值
for i = 1:height
    for j = 1:width
        M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];             % auto correlation matrix
        R(i,j) = det(M)-0.06*(trace(M))^2;                     % 计算R
        if R(i,j) > Rmax
            Rmax = R(i,j);
        end;
    end;
end;

cnt = 0;
for i = 2:height-1
    for j = 2:width-1
        % 进行非极大抑制，窗口大小3*3
        if R(i,j) > 0.01*Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
            result(i,j) = 1;
            cnt = cnt+1;
        end;
    end;
end;

[posc, posr] = find(result == 1);
cnt                                      % 角点个数
imshow(ori_im);
hold on;
plot(posr,posc,'r+');

