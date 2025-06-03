function new_table = string_coords()
    % STRING_COORDS Returns a table of the coordinates at each point of the
    % string jungle bridge.
    
    % Loads in the coordinates table directly.
    load("data/string_bridge_data.mat", "coords_table");

    new_table = coords_table;
    new_table.Properties.VariableNames = ["X_Values", "Y_Values"];
end
