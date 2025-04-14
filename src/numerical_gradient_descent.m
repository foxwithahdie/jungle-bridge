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
    end
    % Return: The final iteration of the gradient descent, believed to be
    % most accurate or as accurate as can be with the amount of given
    % iterations.

    array = array.';
    
    alpha = 1;
    beta = opt_params.alpha;
    gamma = opt_params.beta;
    vec = array;
    curr_iter = 1;

    current_gradient = approximate_gradient(func, vec);
    function_output = func(vec);


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

        curr_iter = curr_iter + 1;
    end

    return_val = vec;
end
