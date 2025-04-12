function jungle_bridge_sim()
    % JUNGLE_BRIDGE_SIM Simulates a rubber band jungle bridge.
    % Compares measured data to a predicted version of what that measured
    % data would look like using gradient descent.
    load("../data/rubber_band_values.mat", "rubber_band_xy_pos");
    params_struct_val = params_struct();
    
    rubber_band_xy_pos = [params_struct_val.r0.', rubber_band_xy_pos, params_struct_val.rn.'];

    rubber_band_xy_pos(2:2:end) = -rubber_band_xy_pos(2:2:end);

    [x_measured, y_measured] = split_array(rubber_band_xy_pos);

    [x_list, y_list] = generate_shape_prediction(params_struct_val);
    
    figure;
    measured_data = plot(x_measured,y_measured, Color='k', LineWidth=2); hold on
        plot(x_measured, y_measured,'o', Color='r', MarkerFaceColor='r', MarkerSize=5);
        generated_data = plot(x_list, y_list, "--", Color='b', LineWidth=2);
        plot(x_list,y_list,'o', Color='g', MarkerFaceColor='g', MarkerSize=5);
        axis equal
        legend([measured_data, generated_data], ["Measured Data", "Generated Prediction"]);
        title("Jungle Bridge Simulation");
        subtitle("Predicted Shape vs Measured Shape");
        xlabel("X (m)"); ylabel("Y (m)");
    hold off
end

function params = params_struct()
    % PARAMS_STRUCT Constructs a struct full of parameters for Jungle Bridge.
    load("../data/rubber_band_values.mat", "k_list", "l0_list", "m_list", "GRAVITY");
    params = struct();
    params.r0 = [0, 0].' ./ 100; % Starting position of the rubber bands
    params.rn = [31.4, 0].' ./ 100; % Final Position of the rubber bands
    params.num_links = 6; % Number of Rubber Bands
    params.k_list = k_list;
    params.l0_list = l0_list;
    params.m_list = m_list;
    params.g = GRAVITY;
end

function U_RB_i = single_RB_potential_energy(x_1, y_1, x_2, y_2, k, l0)
    % SINGLE_RB_POTENTIAL_ENERGY The calculated potential energy for one rubber band.
    arguments
        x_1 double
        % The starting x position.
        y_1 double
        % The starting y position.
        x_2 double
        % The ending x position.
        y_2 double
        % The ending y position.
        k   double
        % The spring constant for the particular rubber band.
        l0  double
        % The original length of the rubber band, unstretched.
    end
    stretched_length = sqrt((x_2 - x_1)^2 + (y_2 - y_1)^2);
    U_RB_i = 1/2 * k * max(stretched_length-l0, 0)^2;
end

function U_RB_total = total_RB_potential_energy(coords, params_struct)
    % TOTAL_RB_POTENTIAL_ENERGY The total potential energy across the
    % bridge of all of the rubber bands, in terms of the stretching of the
    % rubber bands.
    arguments
        coords (1, :) double
        % The list of coordinates where the rubber bands start and end.
        params_struct struct
        % The important parameters struct that holds all of the important
        % values.
    end
    U_RB_total = 0;
    coords = [params_struct.r0; coords; params_struct.rn];
    PAIR_SIZE = 2;
    for i = 1:params_struct.num_links
        l0 = params_struct.l0_list(i);
        k = params_struct.k_list(i);
        x_1 = coords(i * PAIR_SIZE - 1);
        y_1 = coords(i * PAIR_SIZE);
        x_2 = coords(i * PAIR_SIZE + 1);
        y_2 = coords(i * PAIR_SIZE + 2);
        U_RB_total = U_RB_total + single_RB_potential_energy(x_1, y_1, x_2, y_2, k, l0);
    end
end

function U_g_i = single_gravitational_potential_energy(y, m, g)
    % SINGLE_GRAVITATIONAL_POTENTIAL_ENERGY The gravitational potential
    % energy that one rubber band has.
    arguments
        y double
        % The height of a particular rubber band.
        m double
        % The mass, in kilograms, applied to a particular rubber band.
        g double
        % Gravity, in m/s^2.
    end

    U_g_i = y * m * g;
end

function U_g_total = total_gravitational_potential_energy(coords, params_struct)
    % TOTAL_GRAVITATIONAL_POTENTIAL_ENERGY The total gravitational
    % potential energy applied to all rubber bands in the bridge.
    arguments
        coords (1, :) double
        % The list of coordinates where the rubber bands start and end.
        params_struct struct
        % The important parameters struct that holds all of the important
        % values.
    end

    U_g_total = 0;
    for i = 1:params_struct.num_links-1
        y_val = coords((i * 2));
        m = params_struct.m_list(i);
        g = params_struct.g;

        U_g_total = U_g_total + single_gravitational_potential_energy(y_val, m, g);
    end
end

function U_total = total_potential_energy(coords, params_struct)
    % TOTAL_POTENTIAL_ENERGY The total potential energy applied to the
    % entire jungle bridge.
    arguments
        coords (1, :) double
        % The list of coordinates where the rubber bands start and end.
        params_struct struct
        % The important parameters struct that holds all of the important
        % values.
    end
    U_total = total_RB_potential_energy(coords, params_struct) + total_gravitational_potential_energy(coords, params_struct);
end

function [x_list, y_list] = generate_shape_prediction(params_struct)
    % GENERATE_SHAPE_PREDICTION Generates a list of x and y values that
    % make a prediction using gradient descent of what a jungle bridge
    % would look like, based on its first and last values.
    arguments
        params_struct struct
        % The important parameters struct that holds all of the important
        % values.
    end

    opt_params = struct();
    opt_params.alpha = .5;
    opt_params.beta = .9;
    opt_params.max_iterations = 500;
    opt_params.min_gradient = 1e-7;

    f_cost = @(V_in) total_potential_energy(V_in, params_struct);
    x_guess = linspace(params_struct.r0(1), params_struct.rn(1), params_struct.num_links - 1);
    y_guess = linspace(params_struct.r0(2), params_struct.rn(2), params_struct.num_links - 1);
    coords_guess = reshape([x_guess; y_guess], 1, []).';

    coords_sol = numerical_gradient_descent(f_cost, coords_guess, opt_params);

    V_list = [params_struct.r0; coords_sol; params_struct.rn];
    [x_list, y_list] = split_array(V_list);
end
