function plotChEstimates(interpChannelGrid,estChannelGrid,estChannelGridNN,estChannelGridPerfect,...
                         interp_mse,practical_mse,neural_mse)
    figure
    subplot(1,4,1)
    imagesc(abs(interpChannelGrid));
    xlabel('OFDM Symbol');
    ylabel('Subcarrier');
    title({'Linear Interpolation', ['MSE: ', num2str(interp_mse)]});
    subplot(1,4,2)
    imagesc(abs(estChannelGrid));
    xlabel('OFDM Symbol');
    ylabel('Subcarrier');
    title({'Practical Estimator', ['MSE: ', num2str(practical_mse)]});
    subplot(1,4,3)
    imagesc(abs(estChannelGridNN));
    xlabel('OFDM Symbol');
    ylabel('Subcarrier');
    title({'Neural Network', ['MSE: ', num2str(neural_mse)]});
    subplot(1,4,4)
    imagesc(abs(estChannelGridPerfect));
    xlabel('OFDM Symbol');
    ylabel('Subcarrier');
    title({'Actual Channel'});
end