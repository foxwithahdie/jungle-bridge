function gather_string_data()
    % GATHER_STRING_DATA Gathers the existing string bridge data and
    % converts it into data MATLAB can understand.
    [~, data] = load_rope_bridge();
    
    save('..\string_bridge_data.mat');
end