function gather_string_data()
    % GATHER_STRING_DATA Gathers the existing string bridge data and
    % converts it into data MATLAB can understand.
    [coords_table, mass_table, string_lengths_table, data] = load_rope_bridge();

    coords_table.XCoords_cm_ = coords_table.XCoords_cm_ ./ 100;
    coords_table.YCoords_cm_ = coords_table.YCoords_cm_ ./ 100;
    mass_table.Mass_grams_ = mass_table.Mass_grams_ ./ 1000;
    string_lengths_table.Length_cm_ = string_lengths_table.Length_cm_ ./ 100;

    coords = data{1};
    string_x_vals = coords(:, 1) ./ 100;
    string_y_vals = coords(:, 2) ./ 100;

    % Combining separate x and y values into 1 array, alternating.
    string_coords = zeros([1, length(string_x_vals) + length(string_y_vals)]);
    string_coords(1:2:end) = string_x_vals;
    string_coords(2:2:end) = -string_y_vals;
    initial_position = string_coords(1:2);
    final_position = string_coords(end-1:end);
    string_coords = string_coords(3:end-2);
    string_masses = data{2} ./ 1000;

    string_lengths = data{3} ./ 100;
    GRAVITY = 9.8;

    save("..\string_bridge_data.mat", ...
        "coords_table", ...
        "mass_table", ...
        "string_lengths_table", ...
        "initial_position", ...
        "final_position", ...
        "string_coords", ...
        "string_masses", ...
        "string_lengths", ...
        "GRAVITY" ...
    );
end