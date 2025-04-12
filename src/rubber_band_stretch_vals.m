function new_table = rubber_band_stretch_vals()
    % RUBBER_BAND_STRETCH_VALS Returns a table of all of the rubber band
    % stretch values.
    load("../data/rubber_band_values.mat", "rubber_band_1", "rubber_band_2", "rubber_band_3", "rubber_band_4","rubber_band_5", "rubber_band_6");
    array_val = [rubber_band_1(:, 1).'; rubber_band_2(:, 1).'; rubber_band_3(:, 1).'; rubber_band_4(:, 1).'; rubber_band_5(:, 1).'; rubber_band_6(:, 1).'];
    new_table = array2table(array_val, RowNames=["Band_1", "Band_2", "Band_3", "Band_4", "Band_5", "Band_6"], VariableNames=["Stretch_1", "Stretch_2", "Stretch_3", "Stretch_4", "Stretch_5"]);
end
