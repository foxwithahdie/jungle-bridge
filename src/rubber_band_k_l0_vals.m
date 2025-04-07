function new_table = rubber_band_k_l0_vals()
    load("..\data\rubber_band_values.mat", "k_list", "l0_list");
    new_table = array2table([k_list, l0_list].', VariableNames=["Band_1", "Band_2", "Band_3", "Band_4", "Band_5", "Band_6"], RowNames=["K", "L_0"]);
end
