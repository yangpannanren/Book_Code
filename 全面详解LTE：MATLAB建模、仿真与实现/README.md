﻿# 全面详解LTE：MATLAB建模、仿真与实现 / Houman Zarrinkoub

作者：洋盘男人

> 《全面详解LTE：MATLAB建模、仿真与实现 》代码

> 代码地址：[Code_Link](https://github.com/yangpannanren/Book_Code/tree/main/全面详解LTE：MATLAB建模、仿真与实现)

[TOC]

# 导论

LTE（Long Term Evolution，长期演进）和LTE-Advance（高级LTE）标准，迎合了时代需求，实现了全球基带移动通信的愿景。有低延迟，低运营成本，多路天线支持，以及互联网与现存移动通信系统的无缝继承特点。

## 无线通信标准速览

2G-TDMA:GSM(Global System for Mobile Communications，全球移动通信系统)、北美IS-54;
3G-CDMA:北美IS-95、3GPP;
无线本地网络（Wireless Local Area Network，WLAN）、无线城域网（Wireless Metropolitan Area Network，WMAN）;
WiFi协议系列、WiMAX协议;
4G。

20年以来无线通信标准的演进如下图：

![2O年以来无线通信标准的演进](./img/Fig_1.1.png "2O年以来无线通信标准的演进")

## 数据速率的历史

下表为过去20年间推出的各个无线协议的峰值通信速率：
|          技术          | 理论峰值数据速率（在低移动率状态下） |
|:----------------------:|:------------------------------------:|
|           GSM          |               9.6kbit/s              |
|          IS-95         |              14.4kbit/s              |
|          GPRS          |              171.2kbit/s             |
|          EDGE          |               473kbit/s              |
|   CDMA-2000( 1xRTT )   |               307kbit/s              |
|      WCDMA( UMTS )     |              1.92Mbit/s              |
|     HSDPA( Rel 5 )     |               14Mbit/s               |
|  CDMA-2000( 1x-EV-DO ) |               3.1Mbit/s              |
|     HSPA+( Rel 6 )     |               84Mbit/s               |
|    WiMAX( 802.16e )    |               26Mbit/s               |
|      LTE( Rel 8 )      |               300Mbit/s              |
|    WiMAX( 802.16m )    |               303Mbit/s              |
| LTE-Advanced( Rel 10 ) |               1Gbit/ s               |

## IMT-Advanced要求

国际电信联盟(International Telecommunication Unio，ITU)发布了一系列移动系统设计要求。IMT-Advanced 一个标志性的特性，是针对高级服务与应用峰值强化提升数据速率（高移动率100Mbit/s；低移动率1Gbit/s）。这些要求为研究提供方向。3GPP开发的LTE-Advanced标准和IEEE的移动WiMAX标准就是满足IMT-Advanced规范要求的两个代表。

## 3GPP和LTE标准化

LTE 和LTE-Advanced 标准由3GPP 开发。LTE-Advanced 的进步表现在谱效率、峰值数据速率以及用户体验相关方面。随着峰值数据速率达到1Gbit/s，LTE-Advanced 被 ITU 认可并作为 IMT-Advanced 技术。

## LTE要求

LTE 的各个要求涵盖了演进的通用移动通讯系统（Universal Mobile Telecommunications System，UMTS）系统架构的两个基本组件：UMTS陆基接入演进（E-UTRAN），核心分组网演进（EPC）。整个系统的目标包括：
1. 系统容量和覆盖扩展；
2. 高峰值数据传输率；
3. 低延迟（用户平台和控制平台）
4. 成本节约；
5. 多天线支持；
6. 可变带宽操作；
7. 无缝兼容现有设备（UMTS，WiFi等）。

## 理论策略

ShannOn 关于信道容量状态的基础工作告诉我们数据速率永远受限于可接收到的信号功率（或接收信号信噪功率比）。在接收端使用多路天线是一个比增加整体功率更好的办法。这就是我们说的接收分集。多路天线也可以在发送端使用，这就是我们说的发送分集。发送分集的方法基于波束形成，使用多路发送天线聚焦发送功率直接指向接收端。这个技术可以成指数增长接收信号功率从而达到更高数据传输速率。不过，应用发送分集或接收分集以提高数据速率只能在特定的点有效。超过这个点，增加数据速率会造成饱和。一个替代方案是同时应用多路天线在发送端
和接收端，即MIMO。LTE标准中包括不同类型的MIMO技术，包括开环和闭环空域复用。

除了接收信号强度之外，另一个参数也直接影响无线通信系统可达到的数据速率。它就是传输带宽。更高传输速率通常需要提供更宽的带宽。一个与宽带传送有关的重要的设计挑战就是无线信道的多径衰落效应。多径衰落是一个传输信号在到达接收端之前由于通过不同路径造成不同版本传播的现象。这些不同版本的信号叠加导致变化的信号功率特点和时延或相移。其结果是，接收端收到的信号会被调制成一个被信道脉冲响应滤波的样子。在频域上看，多径衰减信道表现为随时间变化的信道频率响应。信道频率响应不可避免地混杂在原始信号的频率特性中，从而对数据速率产生消极影响。为了调整信道频率选择性和得到满意的性能，我们必须在增加传输功率的同时，降低我们对数据速率的预期，或者用信道平衡补偿频域特性的畸变。

很多信道平衡技术都可以克服多径衰落效应。有两个办法可以适用于宽带传输中：
1. 使用多载波传输方案：宽带信号可以处理成多路窄带正交信号的和。应用于LTE标准中多载波传输的例子就是OFDM传输。
2. 使用单载波传输方案：OFDM可以提供一个简单得多的频域平衡方法，不需要要求高传输功率起落。一个在LTE标准中的例子被称为单载波频分复用，应用于上行链路传输。

不仅如此，对在给定带宽实现更高数据速率有更大作用的办法是使用高阶调制。使用高阶调制允许我们在单调制符上搭载更多比特，提高带宽利用率。当然，高的带宽利用率也伴随着代价：减小了调制符之间的最小距离，因而对噪声和干扰变得更敏感。因此，在低或高阶调制中使用自适应调制和编码以及其他链路自适应策略是明智的办法。通过使用自适应方法，我们可以本质上提升通信链路的通过率和可实现的数据速率。

## LTE关键技术

LTE 以及其演进标准中诸关键技术包括了OFDM，MIMO，Turbo编码和动态链路自适应技术。

### OFDM

LTE 选择OFDM 以及其单载波版本的单载波频分复用（Single-Carrier Frequency Division Multiplexing，SC-FDM）作为基本传输方案内容如下：针对多径衰减的可靠性高、频谱效率高、配置复杂度低、可支持可变传输带宽和如频率选择分配这样的高级功能、MIMO传输和干扰协调。

### SC-FDM

OFDM 多载波传输的一个缺点是瞬态发送功率的大范围波动。这对功率放大器产生消极影响而使移动终端基站负担较高的功率消耗。在上行两路传输中，设计一个复杂的功率放大器特别具有挑战性。因而，OFDM传输的一个变体，就是我们所知的SC-FDM被引入LTE标准使用在上行链路传送。SC-FDM一般和标准OFDM系统集成配置，并使用离散傅里叶变换（DFT）预编码。通过使用DFT预编码，SC-FDM根本上减小了发送功率波动的不利影响。因此，上行
链路传输架构可以得到OFDM带来的更多好处，如低复杂度的频域平衡器和频域分配，而不需要对功率放大器设计提出那么硬性的要求。

### MIMO

MIMO 方法对移动通信的贡献体现在两个不同方面：提高总数据速率和提升通信链路的可靠性。应用于LTE标准的MIMO算法可分为4类：接受分集、发送分集，波束形成和空域复用。LTE标准在下行链路协议中提供了4径天线多路传送配置，已实现MIMO。LTE-Advance在下行链路上则允许使用最多8径发送天线。

### Turbo信道编码

Turbo编码进化自卷积码。在LTE标准中，与以往不同，Turbo编码作为了信道编码机制的唯一方案，用于
处理用户数据。Turbo编码近乎理想的性能被LTE采用源自他的复杂度可计算和执行。LTE中的Turbo编码为了有效的执行进行了很多改进。比如，通过附加CRC（循环冗余检查）以检查Turbo 编码器的输入，LTE Turbo解码器可以在编码质量可以接受的情况下实现早期终止机制。这样，不用反复检查追踪解码的整个过程，解码器就能在CRC检查无误的情况下早一些停止。这一简单的解决方案带来了LTE Turbo解码器有可计算复杂度减小，避免了不少性能上的损失。

### 链路自适应

链路自适应的定义是：一种可以调整和适应移动通信系统传输参数以更好响应通信信道的动态性的技术。根据信道质量不同，我们可以使用不同的调制和编码技术（适应性调制和编码），调整几个发送或接受天线（适应性MIMO），甚至调整传输带宽（适应性波长）。

## LTE 物理层建模

物理层建模包括所有数据比特从更高层传输到物理层的处理。它表现为一些列传输信道如何映射到物理信道，信号处理如何在每一个物理信道工作，以及数据如何最终被传送到天线而被发送。

![LTE标准中的物理层协议](./img/Fig_1.2.png "LTE标准中的物理层协议")

如上图所示，这是一个LTE下行链路传输的物理模型。首先，数据被阶梯化多路编码，也就是我们说的下行链路信道共享处理（DLSCH）。DLSCH处理包括附加CRC编码用于检差误码，对用户数据进行TurbO编码，进行比特率匹配操作选择几个输出比特去表示编码率，以及最后把码组重组和为码字。下一步就是所谓下行物理链路信道共享处理（PDSCH）。在这一步，对码字首先进行绕码操作，然后进行调制映射以形成调制过的符号流。再下一步包括LTE MIMO或多径天线处理，调制过的符号信号流被分为指定的多路子信号流通过多径天线传输。MIMO操作可以表示为两个步骤：预编码和层映射。预编码组织符号分配到每一个子数据流，层映射选择和路由数据到子数据流，配置成MIMO下行链路传输中9种不同模式中的一个。所有MIMO在下行链路中都以传输分集，空域复用和波束形成实现。最后工作是和多载波传输相关的一些列处理。在下行链路中，多载波操作基于OFDM传输方案。OFDM传输也包括两个步骤：首先，使用时域-频域资源网格，把资源元素映射到每一层的调制符号上。在调制网格的频轴上，数据和子载波的频域相关。在OFDM信号生成阶段，应用反傅里叶变换生成一系列的OFDM符号，以及时计算发送数据并传输到每个天线。

## LTE（R8 版和R9版）

LTE 标准的第一个版本（3GPP，R8版）发布于2OO8年12月。R9版发布于2OO9年12月；它的内容相应地反映了
一些最新技术进展如支持多媒体广播/组播服务（MBMS），定位服务和提供基站支持多种协议。

## LTE-AdVanced（R10版）

LTE-AdVanced 发布于2O1O 年12 月。LTE-AdVanced 是原始 LTE 标准的演进，并不表示一个最新技术的出现。一些列技术被LTE吸收最终使LTE-Advanced成为包括载波聚合，增强型下行链路MIMO/上行链路MIMO和分程传递的标准升级版。

## MATLAB和无线系统设计

## 本书组织结构

理解四个关键技术（OFDMA、MIMO、TurbO编码和链路自适应）。

# LTE物理层概览

LTE 为上行链路（移动端到基站）和下行链路（基站到移动端）定义了数据通信协议。在3GPP 命名习惯上，基站一般命名为eNodeB（enhanced Node Base station，增强型节点基站），移动单元一般命名为UE（User Equipment，用户设备）。

## 空中接口

LTE 的空中接口在下行链路基于OFDM（正交频分复用）多路接入技术，在上行链路基于类似的技术：SC-FDM（单载波频分复用）。OFDM 的时-频分布在传输中同时分配频谱和时间帧方面提供了高度的灵活性。LTE的频谱灵活性不仅表现在频带多样化上，更表现在对带宽可变的设置。LTE 同时支持1OmS的短帧来减少延迟。通过定义短帧大小，LTE可以更好地评估移动端的信道，实时地为基站的链路自适应提供必要的反馈。

## 频带

LTE标准定义了在不同频带上可用的无线电频率位置。LTE标准的一个目标是无缝兼容旧移动系统。因此，过去3GPP标准中已定义使用的频率在LTE开发中依然可以使用。除了这些通用频带，LTE协议也第一次引入了几个新频带。这些新频带随不同国家间管制规定不同而不同。

FDD频带为成对频谱，它可以同时在两个频率上传输：下行链路使用一个，上行链路使用一个。成对频带有足够的间隔以提升接收器性能。TDD频带是非成对频谱，上行链路和下行链路传输共用同一信道和载波频率。这中传输在上行链路和下行链路上是时间复用的。

## 单播和组播服务

对移动通信来说，一般传输模式是我们熟知的单播传输。它只对单一用户传输数据。除了单播模式之外，LTE支持多媒体广播/组播服务（MBMS）的传输模式。MBMS提供如TV和广播以及音频视频流这样高数据速率的多媒体服务。

MBMS拥有一套它自己的专有业务和控制信道，以及基于多校区传输方案而形成的多媒体广播单频网络（MBSFN）。多媒体信号从属于一个指定的MBSFN服务区内多个相邻的小区发送。当一个多播信道内容从不同小区发送，在相同子载波的信号会在UE连贯组合起来。这使得SNR（Signal-tO-NOiSeRatiO，信噪比）和多媒体传输的最大上限数据速率得到本质提升。

## 带宽分配

LTE的频率范围和包括12个子载波的资源块互相关联。这些子载波以15kHZ等分，所以资源块的总带宽是18OkHZ。传输带宽可以在单一频率的载波上配置6到11O个资源块，这样LTE标准的多径传输特性就提供了1.4～2OMHZ每18OkHZ递增的信道带宽，并保证了所要求的频谱灵活性，如下图所示。

![信道带宽与资源块数量的关系](./img/Fig_2.1.png "信道带宽与资源块数量的关系")

## 时间帧

下图所示为LTE的时域结构。理解LTE传输过程取决于清晰理解数据的时-频分布，映射到资源网格，以及资源网格是如何最终转变成OFDM 符号而传输的。在时域，LTE以1Oms长度的无线电帧序列传输。每一个帧可以细分为1O个长度为1ms的子帧。每一个子帧由两个长度O.5ms的时隙组成。每个时隙包含若干个OFDM符号。这些OFDM符号一般有6个或7个，取决于使用普通循环前缀或是使用扩展循环前缀。

![LTE时域结构](./img/Fig_2.2.png "LTE时域结构")

## 时-频分布

OFDM最吸引人的一个特点就是对发送信号明确映射了时-频分布。在编码与调制之后，复调制信号的变体———物理资源元素，被映射到时-频坐标系统———资源网格中。资源网格在x轴方向为时间，在y轴方向为频率。x轴的资源元素是与时间相关的OFDM符号。y轴方向表示与频率相关的OFDM子载波。

![资源元素，块，和网格](./img/Fig_2.3.png "资源元素，块，和网格")

上图所示为使用普通循环前缀的LTE下行链路资源网格。一个OFDM符号和子载波方向的交叉点对应一个资源元素。子载波间隔15kHZ。在使用普通循环前缀的情况下，每一个子帧有14个OFDM符号（每一个时隙有7个符号）。资源块定义为在频域上12个载波或18OkHZ，在时域上一个O.5mS时隙构成的资源元素组。当使用普通循环前缀的情况下，每一个时隙有7个OFDM符号，这样每一个资源块包括了84个资源元素。在使用扩展循环前缀的情况下，每一个时隙有6个OFDM符号，这样每一个资源块包括了72个资源元素。资源元素的定义非常重要，因为它是时域调度的传输最小单元。

下行和上行链路有一点点区别在于子载波的中心频率有所不同。在上行链路中，没有不使用的DC频率成分的子载波，而上行链路载波中心频率定义在两个子载波中间。在下行链路，中心位置频率不使用。下行链路传输中不使用DC子载波是为了避免非比例高串扰出现的概率。

## OFDM多载波传输

在LTE标准中，下行链路传输基于OFDM方案，而上行链路基于与OFDM类似的SC-FDM方案。OFDM是一个多载波传输的方法，表现在它的基带传输带宽是若干个窄带子信道的集合。

OFDM 信号生成过程略

### 循环前缀
### 子载波间隔
### 资源块尺寸

在选择资源块尺寸时，若干个因素需被考虑。首先，它必须足够小以在频率选择性调度中占优（如在良好频率子载波上调度数据传输）。小资源块尺寸保证每个资源块的频率响应较小，而使调度器只分配那些良好的资源块。不过，eNOdeB不清楚哪个资源块处于好的信道条件下，这个信息须由UE反馈。因此，资源块必须足够大以避免过度的反馈开销。当LTE的子帧大小为1mS以保证延迟时，资源块尺寸在频率上应很小，这样可以有效支持小数据包。因此，LTE 选择18OkHZ（12 子载波）作为资源块带宽。

### 频域调度

LTE支持不同系统带宽。OFDM和SC-FDM通过IFFT操作产生发送信号。我们因此可以通过选择不同的FFT长度而得到不同的带宽。忽略被使用的带宽，LTE保持OFDM符号时长一定，为66.7μS。这使相同15kHZ子载波可用于所有带宽。这一设计选择保证了相同频域平衡技术可以应用跨越多个频带。固定的符号时长也意味着在不同频带上有相同的子帧长度，这一特性使传输模型中时间帧定义得到大大简化。即使在实际的FFT在每个带宽上长度并没有标准定义，2OMHZ上FFT长度通常为2O48。其他频带上FFT长度也通常成比例缩小，见下图。

![资源块、FFT和每个LTE带宽的循环前缀长度](./img/Fig_2.5.png "资源块、FFT和每个LTE带宽的循环前缀长度")

### 接收端典型操作

OFDM接受端反转了OFDM信号生成和发送的过程。首先，我们从接收到的OFDM符号的开始删除循环前缀。随后，通过FFT操作，我们计算接收到的一个OFDM符号内的资源网格元素。在这一步，我们需要在接受到的资源元素上进行平衡操作，来消除信道和码内串扰的影响，以恢复发射资源元素的最好估计。

在资源元素上进行平衡，我们首先需要对所有带宽估计信道频率响应；这一过程针对所有资源元素。引入引导符或小区参考信号（CSR）的重要性是显而易见的。通过在资源网格上多个已知点发送一个已知信号作为引导符，我们可以在相应子信道轻松估计实际的信道响应。这些信道响应可以通过各种方式计算，如通过一个接受信号和发送信号的简单比值。现在我们得到了一些资源网格上标准点的信道响应，接下来可以进行各种平均或插值操作来估计所有资源网格的信道响应。估计资源网格的信道响应之后，我们可以通过把信道响应估计值的倒数乘以接受到的资源资源元素，得到资源元素发送值的最好估计。

## 单载波频分复用

LTE标准中SC-FDM实质上是通过一个带DFT（离散傅里叶变换）预编码器的OFDM调制器执行的。这一技术即离散傅里叶变换扩展正交频分复用（DFTS-OFDM）。与单载波传输的不同之处，在于每个数据符号实质上分散于所有所用带宽上。对比OFDM，每个数据符号只分布在一个子载波上。通过在所有带宽上分散数据功率，SC-FDM减少了传输功率的有效值并保证了传输信号在功率放大器线性区域内的动态范围。SC-FDM同样拥有OFDM所有的优势，包括保证多个上行链路用户的正交性、用频域平衡恢复数据以及克服多径衰落。不过，SCFDM的性能对于同一接收端来说一般弱于OFDM。

## 资源网格的内容

三种类型的信息实际存在于物理资源网格。每个资源元素既包括用户数据的调制符号，也包括参考信号、同步信号和来自更高层信道的控制信息。下图所示为在单播模式下定义的用户数据、控制信息和参考信号在资源网格中的位置。

![单播模式下LTE下行链路子帧内的物理信道和信号内容](./img/Fig_2.6.png "单播模式下LTE下行链路子帧内的物理信道和信号内容")

对单模模式，用户数据搭载了每个用户想要通信的信息，它们以传输块方式从MAC（媒体介入控制）层发送到物理层。多种类型的参考和同步信号在基站和移动设备上生成。这些信号用于如信道估计、信道测量，同步这些用途。最后还有各种类型的控制信息，它们通过控制信道携带了接受端需要的用以正确解码信号所需的信息。

## 物理信道

下图所示为无线电接入网络的协议栈和它的层结构。逻辑信道体现了无线电链路控制（RLC）层和MAC层的数据传输和互联。LTE定义了两种逻辑信道：业务信道和控制信道。业务信道传输用户平面数据。传输信道连接MAC层和物理层，物理信道在物理层上由收发端实现。每个物理信道由一组资源元素构成，这些资源元素搭载了用于空中接口上最终传输的上层信道协议栈。在下层或上层链路数据传输分别使用DL-SCH（下行链路公共信道）和UL-SCH（上行链路公共信道）这两种传输信道。。一个物理信道搭载特定传输信道传输使用的时-频资源。每个传输信道映射到相应的物理信道。除此以外，也有物理信道和传输信道没有一一映射的情况。LTE中逻辑信道、传输信道和物理信道在上行链路和下行链路中不同。

![LTE无线电接入网络的层架构](./img/Fig_2.7.png "LTE无线电接入网络的层架构")

### 下行链路物理信道
### 下行链路信道功能
### 上行链路物理信道
### 上行链路信道功能

## 物理信号

物理信号多种多样，包括参考和同步信号，在公共物理信道内传输。物理信号映射对应PHY特定的资源元素但并不携带上层信息。

### 参考信号

为了表现反映真实信道质量的下行链路调度，移动终端必须为基站提供信道状态信息（CSI）。CSI由测量下行链路中参考信号生成。参考信号由发射端和接收端的同步序列生成器生成。这些信号在时-频网格中被放置于特定的资源元素。

#### 下行链路参考信号

下行链路参考信号提供了信道测量功能，它用于平衡和解调控制信息和数据信息。它们也辅助CSI测量（如RI、CQI和PMI），用于信道质量反馈。LTE定义5种参考信号类型：小区特定参考信号（CSR），解调参考信号（DM-RS以及其他如UE特定参考信号等），信道状态信息参考信号（CSI-RS），MBSFN参考信号和位置参考信号。

#### 上行链路参考信号

LTE 标准定义两种上行链路参考信号：DM-RS和探测参考信号（SRS）。这两种参考信号基于ZadOff-Chu序列。ZadOff-Chu序列用于生成下行链路主同步信号（PSS）和下行链路前导信号。不同UE的参考信号由基本序列的不同循环移位参数区分。

### 同步信号

下行链路同步信号用于多个处理过程中，包括帧边界检测、确定天线数量、初始化小区搜索、相邻小区搜索和
交接。LTE定义了两种同步信号：主同步信号（PSS）和辅助同步信号（SSS）。

PSS和SSS占用DC子波段周围的72个子波段。不过，FDD模式下这些位置不同于TDD模式。在FDD帧中，它们使用子帧O和5，彼此相邻。在TDD帧中，它们并不相邻。SSS信号位于子帧O和5的最后一个符号，PSS位于一个特定帧的第一个OFDM符号。

同步信号与PHY小区识别有关。LTE定义了5O4个小区识别码，分为168个组，每个组包括3个特殊识别码。PSS搭载特殊识别码O、1或2，而SSS搭载组识别码O～167。

## 下行链路帧结构

LTE 定义了两种下行链路帧结构。第一种帧用于FDD，第二种用于TDD。每种帧由1O个子帧组成，每个子帧由时-频资源网格描述。一个资源网格包括三个组成部分：用户数据、控制信道和参考、同步信号。

## 上行链路帧结构
## MIMO

多天线技术依托接收器或发射器使用多个天线传输以及其先进的信号处理技术。虽然多天线技术增加了执行的可计算性复杂度，但它可以达到提升系统性能，包括提升系统容量（换句话说就是一个小区网络容纳更多用户）和提升覆盖率或更大范围小区传输的可能性作用。

### 接收分集

应用于接收分集的常用合并方法：最大比合并（Maximal Ratio Combining，MRC）、选择式合并（Selection Combining，SC）和等增益合并（Equal Gain Combining，EGC)。当使用MRC时，我们合并多路接收信号（平均它们则为等增益合并）找到发射信号的最似然估计。当使用SC时，只有最高SNR的接收信号被采用用以估计发射信号。

### 发射分集

发射分集即在发射端使用多天线通过发射相同信号的随机版本。这一类MIMO技术一般为空-时区块编码（STBC）。使用STBC调制时，符号映射到时域和空域（发射天线）捕捉多发射天线的分集。空-频区块编码（SFBC）是一种和STBC非常相关的技术，它作为发射分集技术引入LTE标准。这两种技术的主要区别在于SFBC在天线（空域）和频域编码而不是在天线（空域）和时域编码，而STBC正相反。发射分集并不会对数据速率有提升作用，它只是增加了对信道衰落影响的可靠性并增加了链路质量。其他MIMO模式—特别是空分复用—则直接增加了数据速率。

### 空分复用

在空分复用情况下，完全独立的数据流在每个发射天线上同时被发射。应用空分复用可使系统与发射天线端口数量等比例的提高数据速率。同时，在同一频率载波上，不同调制符号通过不同天线发射。这意味着空分复用可以直接提升带宽效率，提高系统的带宽利用率。空分复用的这一好处只在多发射天线彼此不相关时才能体现。空分复用可以在通信链路自然存在多路衰落情况下提高性能。因多路衰落可以在每个接收天线端口与接收信号去相关，在多路衰落信道使用空分复用可以事实上提高性能。

### 波束赋形

在波束赋形过程中，发射天线可以形成所有天线发射图形（或波束）来达到在移动终端方向全天线增益最大化。波束赋形构成了下行链路MIMO传输模式7的基础。应用波束赋形技术可以实现信号功率随发射天线数量成比例增长。一般来说，波束赋形依赖最少8个天线构成的天线阵列工作。波束赋形由天线阵列中不同元素应用不同的复变增益（或称权重）执行。所有的传输波束可以指向不同方向，这一过程由在不同天线信号上进行不同的相移完成。

### 循环延迟分集

循环延迟分集（Cyclic Delay Diversity，CDD）是LTE标准中结合开环空分复用的另一种分集形式。CDD对任意给定时刻不同天线上发射信号的向量或块进行循环移位。其效果如同使用一个已知的预编码器。如此，CDD与块传输方案如OFDM和SC-FDM非常匹配。在OFDM传输情况下，比如，时域的循环移位对应频域上频率相关性相移。因相移在频域上———也就是预编码矩阵———可知和可预知，CDD应用于开环空分复用以及在高移动率情况下优化预编码矩阵的闭环反馈无法完成的情况。应用CDD主要作用就是在接收端经验性的引入一个虚拟的频率分隔。

### MIMO模式

下图总结了LTE传输模式以及与其有关的多天线传输方案。模式1使用接收分集，模式2基于发射分集。模式3和4为单用户空分复用，分别基于开环或闭环预编码。模式3也使用CDD。LTE模式5定义了一个非常简单的多用户MIMO，基于模式4并将最大层数设定为1。模式6为模式4的特殊情况，它使用波束赋形，并将最大层数设定为2。LTE 模式7～9 为不使用码书的空分复用，层数分别为1、2，4～8。LTE-AdVanced（第1O发布版）引入模式8和9大大提升了下行链路MU-MIMO性能。如模式9支持8个天线在8个层传输。这些进步也直接来自于引入新的参考信号（CSI-RS和DM-RS），允许无码书的预编码并接收低开销双码书结构。

![LTE传输模式与其所对应的多天线传输方案](./img/Fig_2.10.png "LTE传输模式与其所对应的多天线传输方案")