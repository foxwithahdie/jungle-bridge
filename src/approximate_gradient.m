function return_val = approximate_gradient(fun, vec)
    arguments
        fun function_handle
        vec (:, 1) double
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
