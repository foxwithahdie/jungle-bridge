function jungle_bridge_sim()
    load("../data/rubber_band_values.mat", "rubber_band_xy_pos");
    params_struct_val = params_struct();
    
    rubber_band_xy_pos = [params_struct_val.r0.', rubber_band_xy_pos, params_struct_val.rn.'];

    [x_list, y_list] = generate_shape_prediction(params_struct_val);
    plot(x_list, y_list, Color="r"); hold on
        for i = 1:params_struct_val.num_links - 1
            x = rubber_band_xy_pos((i * 2) - 1);
            y = rubber_band_xy_pos((i * 2));
            plot(x, y, "-o", Color=[1, 0.5, 0]);
        end
        title("Jungle Bridge Simulation")
        xlabel("X (m)"); ylabel("Y (m)")
    hold off
end

function params = params_struct()
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
    arguments
        x_1 double
        y_1 double
        x_2 double
        y_2 double
        k   double
        l0  double
    end
    stretched_length = sqrt((x_2 - x_1)^2 + (y_2 - y_1)^2);
    U_RB_i = 1/2 * k * max(stretched_length, l0)^2;
end

function U_RB_total = total_RB_potential_energy(coords, params_struct)
    arguments
        coords (:, :) double
        params_struct struct
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
    arguments
        y double
        m double
        g double
    end

    U_g_i = y * m * g;
end

function U_g_total = total_gravitational_potential_energy(coords, params_struct)
    arguments
        coords (:, :) double
        params_struct struct
    end

    U_g_total = 0;
    coords = [params_struct.r0; coords; params_struct.rn];
    for i = 1:params_struct.num_links
        y_val = coords((i * 2));
        m = params_struct.m_list(i);
        g = params_struct.g;

        U_g_total = U_g_total + single_gravitational_potential_energy(y_val, m, g);
    end
end

function U_total = total_potential_energy(coords, params_struct)
    arguments
        coords (:, :) double
        params_struct struct
    end
    U_total = total_RB_potential_energy(coords, params_struct) + total_gravitational_potential_energy(coords, params_struct);
end

function [x_list, y_list] = generate_shape_prediction(params_struct)
    arguments
        params_struct struct
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
