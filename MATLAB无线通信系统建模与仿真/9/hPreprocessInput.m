function hest = hPreprocessInput(rxGrid,dmrsIndices,dmrsSymbols)
% 执行网格的线性插值并将结果输入到神经网络
%这个辅助函数从接收到的网格rxGrid中的dmrsIndices位置提取DM-RS符号，并对提取的导频执行线性插值。
    % 获得导频符号估计
    dmrsRx = rxGrid(dmrsIndices);
    dmrsEsts = dmrsRx .* conj(dmrsSymbols);
    % 创建空网格以在线性插值后填充
    [rxDMRSGrid, hest] = deal(zeros(size(rxGrid)));
    rxDMRSGrid(dmrsIndices) = dmrsSymbols;
    %查找给定DMRS配置的行和列坐标
    [rows,cols] = find(rxDMRSGrid ~= 0);
    dmrsSubs = [rows,cols,ones(size(cols))];
    [l_hest,k_hest] = meshgrid(1:size(hest,2),1:size(hest,1));
    % 执行线性插值
    f = scatteredInterpolant(dmrsSubs(:,2),dmrsSubs(:,1),dmrsEsts);
    hest = f(l_hest,k_hest);
end