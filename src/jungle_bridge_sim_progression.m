function jungle_bridge_sim_progression()
    % JUNGLE_BRIDGE_SIM_PROGRESSION Produces a progression of all of the
    % different iterations of the gradient descent produced by the jungle
    % bridge simulation.
    
    % Loads the rubber band x and y positions across the rubber band
    % bridge.
    load("../data/rubber_band_values.mat", "rubber_band_xy_pos");

    params_struct_val = params_struct();
    
    rubber_band_xy_pos = [params_struct_val.r0.', rubber_band_xy_pos, params_struct_val.rn.'];

    rubber_band_xy_pos(2:2:end) = -rubber_band_xy_pos(2:2:end);

    [x, y] = split_array(rubber_band_xy_pos);

    [a, b] = generate_shape_prediction(params_struct_val, 500);
    
    hold on
    hold off
end

function plot_iteration(values, params_struct, iteration)
    arguments
        values (1, :) double
        % The current values of the ongoing gradient descent.
        params_struct struct
        % A list of optimizing parameters in a struct.
        %   .r0 The initial point of the rubber bands.
        %   .rn The final point of the rubber bands.
        %   .num_links The number of rubber bands.
        %   .k_list The list of all of the stiffness constants of the rubber bands.
        %   .l0_list The list of all of the original lengths of the rubber bands.
        %   .m_list The list of all of the weights between the rubber bands.
        %   .g Gravity, in m/s^2.
        iteration double
        % The current iteration.
    end

    values = [params_struct.init; values.'; params_struct.final];
    
    [x_list, y_list] = split_array(values);

    hold on
    axis equal
    plot(x_list, y_list, "--", LineWidth=2, DisplayName="Iteration " + iteration);
    plot(x_list, y_list, 'o', Color='r', MarkerFaceColor='r', MarkerSize=5, HandleVisibility="off");
    title("Progression of Jungle Bridge Gradient Descent")
    xlabel("X (m)"); ylabel("Y (m)")
    legend();
end

function params = params_struct()
    % PARAMS_STRUCT Constructs a struct full of parameters for
    % Jungle Bridge.

    load("../data/rubber_band_values.mat", ...
        "k_list", ...
        "l0_list", ...
        "m_list", ...
        "GRAVITY" ...
     );

    params = struct();
    params.r0 = [0, 0].' ./ 100; % Starting position of the rubber bands
    params.rn = [31.4, 0].' ./ 100; % Final Position of the rubber bands
    params.num_links = 6; % Number of Rubber Bands
    params.k_list = k_list; % Stiffness constants of each rubber band
    params.l0_list = l0_list; % Original length of each rubber band
    params.m_list = m_list; % All of the masses between the rubber bands
    params.g = GRAVITY; % Gravity, in m/s^2
end

function U_RB_i = single_RB_potential_energy(x_1, y_1, x_2, y_2, k, l0)
    % SINGLE_RB_POTENTIAL_ENERGY The calculated potential energy for one
    % rubber band.
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
    % Return: The potential energy in a single rubber band.

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
        %   .r0 The initial point of the rubber bands.
        %   .rn The final point of the rubber bands.
        %   .num_links The number of rubber bands.
        %   .k_list The list of all of the stiffness constants of the rubber bands.
        %   .l0_list The list of all of the original lengths of the rubber bands.
        %   .m_list The list of all of the weights between the rubber bands.
        %   .g Gravity, in m/s^2.
    end
    % Return: The potential energy from rubber bands across the entire
    % rubber band bridge.

    U_RB_total = 0;
    coords = [params_struct.r0; coords.'; params_struct.rn];
    PAIR_SIZE = 2;

    for i = 1:params_struct.num_links
        l0 = params_struct.l0_list(i);
        k = params_struct.k_list(i);
        x_1 = coords(i * PAIR_SIZE - 1);
        y_1 = coords(i * PAIR_SIZE);
        x_2 = coords(i * PAIR_SIZE + 1);
        y_2 = coords(i * PAIR_SIZE + 2);

        U_RB_total = U_RB_total + single_RB_potential_energy(x_1, y_1, ...
                                                          x_2, y_2, k, l0);
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
    % Return: The gravitational potential energy that a single rubber band
    % has.

    U_g_i = y * m * g;
end

function U_g_total = total_gravitational_potential_energy(coords, ...
                                                            params_struct)
    % TOTAL_GRAVITATIONAL_POTENTIAL_ENERGY The total gravitational
    % potential energy applied to all rubber bands in the bridge.
    arguments
        coords (1, :) double
        % The list of coordinates where the rubber bands start and end.
        params_struct struct
        % The important parameters struct that holds all of the important
        % values.
        %   .r0 The initial point of the rubber bands.
        %   .rn The final point of the rubber bands.
        %   .num_links The number of rubber bands.
        %   .k_list The list of all of the stiffness constants of the rubber bands.
        %   .l0_list The list of all of the original lengths of the rubber bands.
        %   .m_list The list of all of the weights between the rubber bands.
        %   .g Gravity, in m/s^2.
    end
    % Return: The gravitational potential energy across the entire rubber
    % band bridge.

    U_g_total = 0;

    for i = 1:params_struct.num_links-1
        y_val = coords((i * 2));
        m = params_struct.m_list(i);
        g = params_struct.g;

        U_g_total = U_g_total + single_gravitational_potential_energy( ...
                                                              y_val, m, g);
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
        %   .r0 The initial point of the rubber bands.
        %   .rn The final point of the rubber bands.
        %   .num_links The number of rubber bands.
        %   .k_list The list of all of the stiffness constants of the rubber bands.
        %   .l0_list The list of all of the original lengths of the rubber bands.
        %   .m_list The list of all of the weights between the rubber bands.
        %   .g Gravity, in m/s^2.
    end
    % Return: The total potential energy across the entire rubber band
    % bridge.

    U_total = total_RB_potential_energy(coords, params_struct) + ...
               total_gravitational_potential_energy(coords, params_struct);
end

function return_val = numerical_gradient_descent(func, array, opt_params)
    % NUMERICAL_GRADIENT_DESCENT Runs a numerical gradient descent for a
    % given number of times.
    arguments
        func function_handle
        % The function you want to apply the gradient with.
        array (1, :) double
        % The initial vector of values that you want to apply the gradient
        % on.
        opt_params struct
        % The initial optimization parameters used for the gradient descent.
        % The initial optimization parameters used for the gradient descent.
        %   .alpha The alpha value used in gradient descent.
        %   .beta A value used to decrease alpha in gradient descent.
        %   .max_iterations The number of iterations that the gradient descent
        %                   should take, at MAX.
        %   .min_gradient The minimum possible difference in error that the
        %                 gradient can have. If below this, the iterations
        %                 should end early.
        %   .init The initial points of the rubber band coordinates. Used
        %   for plotting.
        %   .final The final points of the rubber band coordinates. Used
        %   for plotting.
    end

    array = array.';
    
    alpha = 1;
    beta = opt_params.alpha;
    gamma = opt_params.beta;
    vec = array;
    curr_iter = 1;

    current_gradient = approximate_gradient(func, vec);
    function_output = func(vec);

    plot_iteration(vec, opt_params, curr_iter);

    random_plots = [2, 9, 23, 57, 499];

    while (curr_iter < opt_params.max_iterations && norm(current_gradient) > opt_params.min_gradient)
        square_norm_gradient = sum(current_gradient.^2);

        while (func(vec - alpha * current_gradient) < function_output - beta * alpha * square_norm_gradient)
            alpha = alpha / gamma;
        end

        while (func(vec - alpha * current_gradient) > function_output - beta * alpha * square_norm_gradient)
            alpha = alpha * gamma;
        end

        vec = vec - alpha * current_gradient;
        current_gradient = approximate_gradient(func, vec);
        function_output = func(vec);
        
        if (ismember(curr_iter, random_plots))
            plot_iteration(vec, opt_params, curr_iter);
        end

        curr_iter = curr_iter + 1;
    end

    return_val = vec;
end


function [x_list, y_list] = generate_shape_prediction(params_struct, ...
                                                                iterations)
    % GENERATE_SHAPE_PREDICTION Generates a list of x and y values that
    % make a prediction using gradient descent of what a jungle bridge
    % would look like, based on its first and last values.
    arguments
        params_struct struct
        % The important parameters struct that holds all of the important
        % values.
        iterations double
        % The amount of times you want to iterate to generate your shape.
    end
    
    % Optimization parameters for the gradient descent.
    opt_params = struct();
    opt_params.alpha = .5;
    opt_params.beta = .9;
    opt_params.max_iterations = iterations;
    opt_params.min_gradient = 1e-14;
    opt_params.init = params_struct.r0;
    opt_params.final = params_struct.rn;

    f_cost = @(V_in) total_potential_energy(V_in, params_struct);
    x_guess = linspace(params_struct.r0(1), params_struct.rn(1), params_struct.num_links - 1);
    y_guess = linspace(params_struct.r0(2), params_struct.rn(2), params_struct.num_links - 1);
    coords_guess = reshape([x_guess; y_guess], 1, []).';

    coords_sol = numerical_gradient_descent(f_cost, coords_guess, opt_params);

    V_list = [params_struct.r0; coords_sol; params_struct.rn];
    [x_list, y_list] = split_array(V_list);
end
