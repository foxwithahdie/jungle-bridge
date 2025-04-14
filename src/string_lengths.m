function new_table = string_lengths()
    % STRING_LENGTHS Returns a table of the strings and their corresponding
    % lengths.
    
    % Loads in the string lengths table directly.
    load("..\data\string_bridge_data.mat", "string_lengths_table");

    new_table = string_lengths_table;

    new_table.Properties.VariableNames = ["Length"];


end
