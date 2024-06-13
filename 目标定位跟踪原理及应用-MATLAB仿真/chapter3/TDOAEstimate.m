function TDOAEstimate
%第一步:定位初始化
Length=100;                          %场地空间，单位：米
Width=100;                           %场地空间，单位：米
Node_number=3;                       %观测站的个数,最少必须有3个
for i=1:Node_number                  %观测站的位置初始化,这里位置是随机给定的
    Node(i).x= Width * rand;
    Node(i).y= Length * rand;
    Node(i).D= Node(i).x^2+Node(i).y^2; % 固定参数便于位置估计
end
%目标的真实位置,这里也随机给定
Target.x= Width * rand;
Target.y= Length * rand;
BroadcastPacket=0;                    %数据包，用于目标节点周期性广播数据包和超声
ultrasonicV=340;                      %超声在空气中传输速度为340m/s
%第二步:各观测站对目标探测，记录时间。收到无线信号,启动计时器
%目标节点发送数据包
sendData(BroadcastPacket);
%延时一段时间后发送超声
delaytime=10; %延时10ms
delay(delaytime);
%目标节点发送超声脉冲
sendUltraPlus();
%第三步:各个观测站接收无线数据包和超声
%假设所有观测站之前都成功接收到BroadeastPacket数据包，之后启动定时器计时
uT=[];                              %各观测站采集时间差
for i=1:Node_number
    recvUltraPlus();               %第i个观测站成功接收到超声脉冲
    %每个节点成功接收到超声脉冲后，记录时间
    [d]= DIST( Node(i),Target);     %观测站离目标的真实距离
    %第i个观测站记录的时间
    uT(i)= GetTimeLength(d);
end
%第四步:根据记录的时间,计算观测站与目标之间的距离
Zd=[];
for i=1:Node_number
    Zd(i)= uT(i) * ultrasonicV;     %距离=时间*速度
end
%第五步:根据距离,用最小二乘法计算目标节点的估计位置
H=[];b=[];
for i=2:Node_number
    H=[ H;2* ( Node(i).x-Node(1).x) ,2* (Node(i).y-Node(1).y)]; %参照三边测距法公式
    b=[b;Zd(1)^2-Zd(i)^2+Node(i).D-Node(1).D];                   %参照三边测距法公式
end
Estimate=inv(H'*H)*H'*b;             %目标的估计位置
Est_Target.x= Estimate(1);Est_Target.y= Estimate(2);

%画图
figure
hold on;box on;axis([0 120 0 120]);
%输出图形的框架
for i= 1: Node_number
    h1= plot(Node(i).x, Node(i).y,'ko','MarkerFace','g','MarkerSize',10);
    text(Node(i).x+2,Node(i).y,[ 'Node ', num2str(i)]);
end
h2= plot(Target.x,Target.y,'k^','MarkerFace','b','MarkerSize', 10) ;
h3= plot(Est_Target.x,Est_Target.y,'ks','MarkerFace','r','MarkerSize',10);
line([Target.x,Est_Target.x],[Target.y,Est_Target.y] ,'Color' ,'k');
legend([h1,h2,h3 ],'Observation Station','Target Postion','Estimate Postion');
[Error_Dist]=DIST(Est_Target,Target);
xlabel(['error=',num2str( Error_Dist),'m']);

%子函数,计算两点间的距离
function [dist]= DIST(A,B)
dist=sqrt((A.x-B.x)^2+(A.y-B.y)^2);

%子函数,观测站距离目标点为d时，超声脉冲传输的时间
function time = GetTimeLength(d)
%当距离为d时,仿真系统给出一个与实际距离相对应的仿真值
ultrasonicV=340; %超声在空气中传输速度为340m/s
time = d/ultrasonicV;
%实际测量值是受到噪声污染的，需要考虑实际的温度、湿度、气压等因素
Q=5e-6;
time = time+sqrt(Q) * randn; %实际观测量是带有噪声的,仿真就是在模仿真实情况

%子函数，仿真通信机制，目标节点发送数据包和超声
function sendData( BroadeastData)
%由于MATLAB不便于仿真通信机制，这里假定发送的数据都被成功接收
disp( 'The TargetNode send wireless data success !\n')

%子函数,仿真目标节点发送超声
function sendUltraPlus( )
disp( 'The TargetNode send ultrasonie plus success !\n')

%子函数,观测站成功接收超声
function recvUltraPlus()
disp( 'The ObserNode receive ultrasonie plus success !\n')

function delay(delaytime)
disp('System delay for sometime! \n')