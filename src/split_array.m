function [x_list, y_list] = split_array(array)
    % SPLIT_ARRAY Utility function. Splits an array of structure [x, y, x,
    % y...] into two arrays, [x, x, ...] and [y, y, ...].
    arguments
        array (1, :) double
        % The [x, y, x, y...] array.
    end

    x_list = [];
    y_list = [];
    size_of_array = size(array);
    array_length = 0;
    if (size_of_array(1) ~= 1)
        array_length = size_of_array(1);
    else
        array_length = size_of_array(2);
    end

    PAIR_SIZE = 2;
    
    for i = 1:array_length / 2
        x_list(end+1) = array((i * PAIR_SIZE) - 1);
        y_list(end+1) = array((i * PAIR_SIZE));
    end
end
