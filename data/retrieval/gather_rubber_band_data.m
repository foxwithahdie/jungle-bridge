function gather_rubber_band_data()
    [~, data_matrix] = load_excel_file();
    GRAVITY = 9.8;
    rubber_band_1 = [data_matrix(2, :)/100; ones(size(data_matrix(2, :)))].';
    rubber_band_2 = [data_matrix(4, :)/100; ones(size(data_matrix(4, :)))].';
    rubber_band_3 = [data_matrix(6, :)/100; ones(size(data_matrix(6, :)))].';
    rubber_band_4 = [data_matrix(8, :)/100; ones(size(data_matrix(8, :)))].';
    rubber_band_5 = [data_matrix(10, :)/100; ones(size(data_matrix(10, :)))].';
    rubber_band_6 = [data_matrix(12, :)/100; ones(size(data_matrix(12, :)))].';

    weight_value = (data_matrix(1, :) ./ 1000 .* GRAVITY).';

    slope_intercept_1 = rubber_band_1 \ weight_value;
    m_1 = slope_intercept_1(1); b_1 = slope_intercept_1(2);
    % slope_func_1 = @(x) m_1 * x + b_1;
    slope_intercept_2 = rubber_band_2 \ weight_value;
    m_2 = slope_intercept_2(1); b_2 = slope_intercept_2(2);
    % slope_func_2 = @(x) m_2 * x + b_2;
    slope_intercept_3 = rubber_band_3 \ weight_value;
    m_3 = slope_intercept_3(1); b_3 = slope_intercept_3(2);
    % slope_func_3 = @(x) m_3 * x + b_3;
    slope_intercept_4 = rubber_band_4 \ weight_value;
    m_4 = slope_intercept_4(1); b_4 = slope_intercept_4(2);
    % slope_func_4 = @(x) m_4 * x + b_4;
    slope_intercept_5 = rubber_band_5 \ weight_value;
    m_5 = slope_intercept_5(1); b_5 = slope_intercept_5(2);
    % slope_func_5 = @(x) m_5 * x + b_5;
    slope_intercept_6 = rubber_band_6 \ weight_value;
    m_6 = slope_intercept_6(1); b_6 = slope_intercept_6(2);
    % slope_func_6 = @(x) m_6 * x + b_6;

    k_list = [m_1, m_2, m_3, m_4, m_5, m_6].';
    l0_list = [    ...
        (-1 * b_1) ./ m_1, ...
        (-1 * b_2) ./ m_2, ...
        (-1 * b_3) ./ m_3, ...
        (-1 * b_4) ./ m_4, ...
        (-1 * b_5) ./ m_5, ...
        (-1 * b_6) ./ m_6  ...
    ].';
    m_list = [0, 26, 31, 41, 46, 50] ./ 1000;
    rubber_band_xy_pos = [7.2, 5.5, 12, 6.8, 20.9, 7.5, 26.3, 6.7, 29.2, 3.3] ./ 100;
    
    save("../rubber_band_values.mat","k_list","l0_list","m_list","rubber_band_xy_pos","GRAVITY", "rubber_band_1", "rubber_band_2", "rubber_band_3", "rubber_band_4", "rubber_band_5", "rubber_band_6", "weight_value")
end