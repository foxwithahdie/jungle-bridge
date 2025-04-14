function rubber_band_contour()
    % RUBBER_BAND_CONTOUR Plots a contour plot of a given rubber band,
    % comparing the line of best fit to others in a contour.
    
    % Loading in important information for the contour plot.
    load("../data/rubber_band_values.mat", ...
        "rubber_band_1", ...
        "weight_value", ...
        "k_list", ...
        "l0_list" ...
    );

    % Rubber Band for which we are plotting the cost function
    rubber_band_num = 1;

    force_list = k_list(rubber_band_num) * (rubber_band_1(:, 1) - l0_list(rubber_band_num));
    length_list = rubber_band_1(:, 1);
   
    rubber_band_slope_intercept = rubber_band_1 \ weight_value;
    m_opt = rubber_band_slope_intercept(1);
    b_opt = rubber_band_slope_intercept(2);

    % Range for plotting m and b on cost function;
    %   m scaling will be delta_m
    %   b scaling will be delta_b
    % Plot window centered at regressed value (m_opt, b_opt)
    delta_m = .5;
    delta_b = .05;

    val_amount = 101;
    m_range = linspace(m_opt - delta_m / 2, m_opt + delta_m / 2, val_amount);
    b_range = linspace(b_opt - delta_b / 2, b_opt + delta_b / 2, val_amount);

    [m_grid, b_grid] = meshgrid(m_range, b_range);

    cost_grid = zeros(size(m_grid));

    % Evaluate total cost function for regression
    for measurement_index = 1:length(force_list)
        xi = length_list(measurement_index);
        yi = force_list(measurement_index);
        cost_grid = cost_grid + (m_grid * xi + b_grid - yi).^2;
    end

    min_val = min(min(cost_grid));
    max_val = max(max(cost_grid));
    
    d_val = sqrt(max_val - min_val);
    amount_levels = 21;
    levels = min_val + linspace(0, d_val, amount_levels).^2;
    
    % Generated contour plot for all possible linear regressions.
    figure;
    contourf(m_grid, b_grid, cost_grid, levels(1:end-1), Color='w'); hold on
        plot(m_opt, b_opt, "o", Color='r', MarkerFaceColor='r', MarkerSize=5);
        xlabel('m (N / m)'); ylabel('b (N)')
        title('Regression Cost Function');
        subtitle("A Contour of Linear Regression Error for Rubber Band Stretch")
    hold off
end
