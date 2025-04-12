function rubber_band_1_line_of_best_fit()
    % RUBBER_BAND_1_LINE_OF_BEST_FIT Plots a line of best fit for all of
    % the calculated rubber band stretch values.
    load("../data/rubber_band_values.mat", "rubber_band_1", "weight_value")
    slope_intercept_1 = rubber_band_1 \ weight_value;
    m_1 = slope_intercept_1(1); b_1 = slope_intercept_1(2);
    slope_func_1 = @(x) m_1 * x + b_1;
    data_points_1 = linspace(.08,.1, 100);

    plot(data_points_1, slope_func_1(data_points_1), Color=[1, 0.5, 0]); hold on
        plot(rubber_band_1(:,1),weight_value, 'o', Color="g", MarkerFaceColor='g',MarkerSize=3);
        xlabel("Rubber Band Stretch (m)"); ylabel("Weight on the Rubber Band (N)")
        legend(["Line of Best Fit", "Individual Rubber Band Points"], Location="Northwest")
    hold off
end
