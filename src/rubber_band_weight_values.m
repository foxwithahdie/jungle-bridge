function new_table = rubber_band_weight_values()
    % RUBBER_BAND_WEIGHT_VALUES Returns a table of the rubber bands to
    % their respective weights.

    % Load in important data for the weight table.
    load("../data/rubber_band_values.mat", ...
        "weight_value" ...
    );
    
    new_table = array2table(weight_value.', RowName="Weight_Values(N)", VariableNames=["Weight_1", "Weight_2", "Weight_3", "Weight_4", "Weight_5"]);
end
