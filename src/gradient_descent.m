function [x, y] = gradient_descent(func, prev_x, prev_y, alpha)
    arguments
        func function_handle
        prev_x double
        prev_y double
        alpha double
    end
    gradient_descent_val = func(prev_x, prev_y);
    
    x = prev_x - alpha * gradient_descent_val(1);
    y = prev_y - alpha * gradient_descent_val(2);
end
