function return_val = approximate_gradient(fun, vec)
    % APPROXIMATE_GRADIENT Computes the gradient over a vector numerically.
    arguments
        fun function_handle
        % The function to run the gradient over.
        vec (:, 1) double
        % The vector in which you are applying the gradient function to.
        % The gradient is applied over the whole vector and returns a whole
        % vector.
    end

    STEP_SIZE = 1e-6;
    gradient = zeros(length(vec), 1);
    delta_vec = zeros(length(vec), 1);
    for i = 1:length(vec)
        delta_vec(i) = STEP_SIZE;     
        f_minus = fun(vec - (delta_vec));
        f_plus = fun(vec + (delta_vec));
        gradient(i) = (f_plus - f_minus) / (2 * STEP_SIZE);
        delta_vec(i) = 0;
    end
    
    return_val = gradient;
end
