%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 功能说明：在图像上散列均匀分布白噪声点
% Fig.3-5、3-6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function genUnifNoise
N=1000;
x=zeros(1,N);
y=zeros(1,N);
image=imread('baby.jpg');
imageNew=image;
imageSize=imresize(image,1);
[height, width, channel]=size(imageSize);
for k=1:N
    x(k)=ceil(unifrnd(0,height));
    y(k)=ceil(unifrnd(0,width));
    for i=1:channel
        imageNew(x(k),y(k),i)=255;
    end
end
figure
subplot(1,2,1);
imshow(image);
axis([0 width 0 height]);
title('原始图像')
subplot(1,2,2);
imshow(imageNew);
axis([0 width 0 height]);
title('白噪声图像')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%