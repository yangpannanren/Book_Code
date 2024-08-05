prmQPSKTxRx = commqpsktxrx_init % QPSK系统参数

useScopes = true;   %如果使用作用域，则为True
printReceivedData = false; %如果要打印接收的数据，则为True
compileIt = false;  % 如果要编译代码，则为True
useCodegen = false; % True运行生成的mex文件

if compileIt
    codegen -report runQPSKSystemUnderTest.m -args {coder.Constant(prmQPSKTxRx),coder.Constant(useScopes),coder.Constant(printReceivedData)} %#ok
end
if useCodegen
    BER = runQPSKSystemUnderTest_mex(prmQPSKTxRx, useScopes, printReceivedData);
else
    BER = runQPSKSystemUnderTest(prmQPSKTxRx, useScopes, printReceivedData);
end
fprintf('错误率 = %f.\n',BER(1));
fprintf('检测到的错误数 = %d.\n',BER(2));
fprintf('比较样本总数 = %d.\n',BER(3));