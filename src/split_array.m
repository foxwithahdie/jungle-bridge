function [x_list, y_list] = split_array(array)
    arguments
        array (1, :) double
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
