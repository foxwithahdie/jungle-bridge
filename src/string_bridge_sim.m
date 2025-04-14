function string_bridge_sim()
    % STRING_BRIDGE_SIM Performs gradient descent on two initial string
    % points, predicting where the position will be compared to the actual
    % values.
    
    % Loads in all of the string coordinates.
    load("..\data\string_bridge_data.mat", "string_coords");

    params_struct_val = params_struct();
    %   .r0 The initial position in the string bridge.
    %   .rn The final position in the string bridge.
    %   .num_links The number of strings.
    %   .len_list The length of each string in a list.
    %   .m_list The list of masses between each string.
    %   .g Gravity, in m/s^2.

    string_coords = [params_struct_val.r0, string_coords, params_struct_val.rn];

    [x_measured, y_measured] = split_array(string_coords);

    [x_list, y_list] = generate_shape_prediction(params_struct_val);
    
    % Plots the string bridge.
    figure;
    measured_data = plot(x_measured,y_measured, Color='k', LineWidth=2); hold on
        plot(x_measured, y_measured,'o', Color='r', MarkerFaceColor='r', MarkerSize=5);
        generated_data = plot(x_list, y_list, "--", Color='b', LineWidth=2);
        plot(x_list,y_list,'o', Color='g', MarkerFaceColor='g', MarkerSize=5);
        axis equal
        legend([measured_data, generated_data], ["Measured Data", "Generated Prediction"]);
        title("String Bridge Simulation");
        subtitle("Predicted Shape vs Measured Shape");
        xlabel("X (m)"); ylabel("Y (m)");
    hold off
end

function constraint_error = single_string_error(x_1, y_1, x_2, y_2, ...
                                                                  max_len)
    % SINGLE_STRING_ERROR Computes the constraint error for a single
    % string.
    arguments
        x_1 double
        % The original x position of a string.
        y_1 double
        % The original y position of a string.
        x_2 double
        % The final x position of a string.
        y_2 double
        % The final y position of a string.
        max_len double
        % The maximum length of a string.
    end

    constraint_error = sqrt((x_2 - x_1)^2 + (y_2 - y_1)^2) - max_len;
end

function [error_vector, dummy] = bridge_error(coords, params_struct)
    % BRIDGE_ERROR Computers the constraint error for the entire string
    % bridge.
    arguments
        coords (1, :) double
        % The coordinates of all of the strings in the string bridge.
        params_struct struct
        % A struct of all of the parameters required for the string bridge.
        %   .r0 The initial position in the string bridge.
        %   .rn The final position in the string bridge.
        %   .num_links The number of strings.
        %   .len_list The length of each string in a list.
        %   .m_list The list of masses between each string.
        %   .g Gravity, in m/s^2.
    end

    error_vector = zeros(params_struct.num_links, 1);
    dummy = [];

    coords = [params_struct.r0, coords, params_struct.rn];
    PAIR_SIZE = 2;
    for i = 1:params_struct.num_links
        max_len = params_struct.len_list(i);

        x_1 = coords((i * PAIR_SIZE) - 1);
        y_1 = coords((i * PAIR_SIZE));
        x_2 = coords((i * PAIR_SIZE) + 1);
        y_2 = coords((i * PAIR_SIZE) + 2);

        error_vector(i) = single_string_error(x_1, y_1, x_2, y_2, max_len);
    end 

end

function [x_list, y_list] = generate_shape_prediction(params_struct)
    % GENERATE_SHAPE_PREDICTION Generates the shape of the string bridge.
    arguments
        params_struct struct
        % A struct of all of the parameters required for the string bridge.
        %   .r0 The initial position in the string bridge.
        %   .rn The final position in the string bridge.
        %   .num_links The number of strings.
        %   .len_list The length of each string in a list.
        %   .m_list The list of masses between each string.
        %   .g Gravity, in m/s^2.
    end

    x_guess = linspace(params_struct.r0(1), params_struct.rn(1), params_struct.num_links - 1);
    y_guess = linspace(params_struct.r0(2), params_struct.rn(2), params_struct.num_links - 1);
    coords_guess = reshape([x_guess; y_guess], 1, []).';

    f_cost = @(V_in) total_gravitational_potential_energy(V_in, params_struct);
    
    f_constraint = @(V_in) bridge_error(V_in, params_struct);

    coords_sol = fmincon(f_cost, coords_guess, [], [], [], [], [], [], f_constraint);

    V_list = [params_struct.r0.'; coords_sol; params_struct.rn.'];

    [x_list, y_list] = split_array(V_list);
end

function params = params_struct()
    % PARAMS_STRUCT Constructs a struct of all of the parameters
    % required for the string bridge.
    
    load("..\data\string_bridge_data.mat", ...
        "initial_position", ...
        "final_position", ...
        "string_masses", ...
        "GRAVITY", ...
        "string_lengths" ...
    ); 
    params = struct();
    params.r0 = initial_position; % Starting position of the strings
    params.rn = final_position; % Final Position of the strings
    params.num_links = 6; % Number of strings
    params.len_list = string_lengths; % Length of each string
    params.m_list = string_masses; % Masses between the strings
    params.g = GRAVITY; % Gravity, in m/s^2

    % struct:
    %   .r0 The initial position in the string bridge.
    %   .rn The final position in the string bridge.
    %   .num_links The number of strings.
    %   .len_list The length of each string in a list.
    %   .m_list The list of masses between each string.
    %   .g Gravity, in m/s^2.
end

function U_g_i = single_gravitational_potential_energy(y, m, g)
    % SINGLE_GRAVITATIONAL_POTENTIAL_ENERGY The gravitational potential
    % energy that one string has.
    arguments
        y double
        % The height of a particular string.
        m double
        % The mass, in kilograms, applied to a particular string.
        g double
        % Gravity, in m/s^2.
    end

    U_g_i = y * m * g;
end

function U_g_total = total_gravitational_potential_energy(coords, params_struct)
    % TOTAL_GRAVITATIONAL_POTENTIAL_ENERGY The total gravitational
    % potential energy applied to all strings in the bridge.
    arguments
        coords (1, :) double
        % The coordinates of all of the strings in the string bridge.
        params_struct struct
        % A struct of all of the parameters required for the string bridge.
        %   .r0 The initial position in the string bridge.
        %   .rn The final position in the string bridge.
        %   .num_links The number of strings.
        %   .len_list The length of each string in a list.
        %   .m_list The list of masses between each string.
        %   .g Gravity, in m/s^2.
    end

    U_g_total = 0;
    for i = 1:params_struct.num_links-1
        y_val = coords((i * 2));
        m = params_struct.m_list(i);
        g = params_struct.g;

        U_g_total = U_g_total + single_gravitational_potential_energy(y_val, m, g);
    end
end
