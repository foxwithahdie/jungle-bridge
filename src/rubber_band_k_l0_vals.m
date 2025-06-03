function new_table = rubber_band_k_l0_vals()
    % RUBBER_BAND_K_L0_VALS Returns a table of all of the rubber bands to
    % their respective Hooke's Law constants and original lengths.

    % Loads important data to rebuild this table.
    load("data/rubber_band_values.mat", ...
        "k_list", ...
        "l0_list" ...
    );
    
    new_table = array2table([k_list, l0_list].', VariableNames=["Band_1", "Band_2", "Band_3", "Band_4", "Band_5", "Band_6"], RowNames=["K", "L_0"]);
end
