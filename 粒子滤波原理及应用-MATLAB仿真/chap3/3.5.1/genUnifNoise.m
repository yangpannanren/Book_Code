%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ȩ������
%     ���������ϸ����ע����ο�
%     ��Сƽ�����ң�������.�����˲�ԭ��Ӧ��[M].���ӹ�ҵ�����磬2017.4
%     ������ԭ�����+����+����+����ע��
%     ����˳����д��������ʾ�޸�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����˵������ͼ����ɢ�о��ȷֲ���������
function genUnifNoise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error('����Ĳ���N��ο����е�ֵ���ã�Ȼ��ɾ�����д���')
N=0;           
x=zeros(1,N);    
y=zeros(1,N);      
image=imread('baby.jpg');    
imageNew=image;               
imageSize=imresize(image,1); 
[height width channel]=size(imageSize);  
for k=1:N;
   
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
subplot(1,2,2);
imshow(imageNew);  
axis([0 width 0 height]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%