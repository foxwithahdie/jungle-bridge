function new_table = string_weights()
    % STRING_WEIGHTS Returns a table of the weights between the strings.
    
    % Loads in the mass table directly.
    load("..\data\string_bridge_data.mat", "mass_table");

    new_table = mass_table;

    new_table.Properties.VariableNames = ["Mass"];
end
