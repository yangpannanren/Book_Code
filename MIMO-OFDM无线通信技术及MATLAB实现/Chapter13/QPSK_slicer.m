function x_sliced = QPSK_slicer(x)

for i = 1:length(x)
    if real(x(i))>0 && imag(x(i))>0
        x_sliced(i) = 1/sqrt(2) + 1j*(1/sqrt(2));
    elseif real(x(i))<0 && imag(x(i))>0
        x_sliced(i) = -1/sqrt(2) + 1j*(1/sqrt(2));
    elseif real(x(i))<0 && imag(x(i))<0
        x_sliced(i) = -1/sqrt(2) - 1j*(1/sqrt(2));
    elseif real(x(i))>0 && imag(x(i))<0
        x_sliced(i) = 1/sqrt(2) - 1j*(1/sqrt(2));
    end
end