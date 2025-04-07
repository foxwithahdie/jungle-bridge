function return_val = numerical_gradient_descent(func, array, opt_params)
    arguments
        func function_handle
        array (1, :) double
        opt_params struct
    end

    array = array.';
    
    alpha = 1;
    beta = opt_params.alpha;
    gamma = opt_params.beta;
    vec = array;
    curr_iter = 1;

    new_coords = approximate_gradient(func, vec);
    function_output = func(vec);


    while (curr_iter < opt_params.max_iterations && norm(new_coords) > opt_params.min_gradient)
        scare_norm_gradient = sum(new_coords.^2);

        while (func(vec - alpha * new_coords) < function_output - beta * alpha * scare_norm_gradient)
            alpha = alpha / gamma;
        end

        while (func(vec - alpha * new_coords) < function_output - beta * alpha * scare_norm_gradient)
            alpha = alpha * gamma;
        end

        vec = vec - alpha * new_coords;
        new_coords = approximate_gradient(func, vec);
        function_output = func(vec);

        curr_iter = curr_iter + 1;
    end

    return_val = vec;
end
