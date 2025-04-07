function new_table = rubber_band_weight_values()
    load("../data/rubber_band_values.mat", "weight_value");
    new_table = array2table(weight_value.', RowName="Weight_Values(N)", VariableNames=["Weight_1", "Weight_2", "Weight_3", "Weight_4", "Weight_5"]);
end
