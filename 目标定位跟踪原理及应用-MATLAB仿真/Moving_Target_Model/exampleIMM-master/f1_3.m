function x_new = f1_3( x, w )
    if nargin < 2
        T = 1;
        A1_3 = [1, 0, 0, T, 0, 0, 1/2*T^2, 0;
            0, 1, 0, 0, T, 0, 0, 1/2*T^2;
            0, 0, 1, 0, 0, T, 0, 0;
            0, 0, 0, 1, 0, 0, T, 0;
            0, 0, 0, 0, 1, 0, 0, T;
            0, 0, 0, 0, 0, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 1, 0;
            0, 0, 0, 0, 0, 0, 0, 1];
        x_new = A1_3 * x;
    else
        T = 1;
        A1_3 = [1, 0, 0, T, 0, 0, 1/2*T^2, 0;
            0, 1, 0, 0, T, 0, 0, 1/2*T^2;
            0, 0, 1, 0, 0, T, 0, 0;
            0, 0, 0, 1, 0, 0, T, 0;
            0, 0, 0, 0, 1, 0, 0, T;
            0, 0, 0, 0, 0, 1, 0, 0;
            0, 0, 0, 0, 0, 0, 1, 0;
            0, 0, 0, 0, 0, 0, 0, 1];
        x_new = A1_3 * x;
        x_new = x_new + w*randn();
    end
end

