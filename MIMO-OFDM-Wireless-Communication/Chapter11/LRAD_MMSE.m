function[X_Estimated]= LRAD_MMSE(H_complex,y,sigma2,delta)
% Lattice Reduction with MMSE
% Input parameters
%     H_complex : complex channel matrix, nRxnT
%     y : complex received signal, nRx1
%     sigma2 : noise variance
% Output parameters
%     X_Estimated : estimated signal, nTx1

Nt = 4;
Nr = 4;
N = 2*Nt;
% complex channel -> real channel
H_real=[[real(H_complex) -imag(H_complex)];[imag(H_complex) real(H_complex)]];
H=[H_real;sqrt(sigma2)*eye(N)];
y_real=[real(y);imag(y)];  % complex y -> real y
y=[y_real;zeros(N,1)];
[Q,R,P,~] = SQRD(H);        % sorted QR decomposition
[~,~,T] = original_LLL(Q,R,N,delta);  % W*L = Q*R*T
H_tilde = H*P*T;             % H*P = Q*R
X_temp = inv(H_tilde'*H_tilde)*H_tilde'*y;  % MMSE detection
X_temp = round(X_temp);     % slicing
X_temp = P*T*X_temp;
for i=1:Nr  % real x -> complex x
    X_Estimated(i) = X_temp(i)+1i*X_temp(i+4);
end