function [table, data] = load_rubber_band_file()
    % LOAD_RUBBER_BAND_FILE Loads the rubber band data from '..\RubberBandTemplate.xlsx' into
    % data MATLAB can understand.

    filename = '..\RubberBandTemplate.xlsx';

    my_table = readtable(filename);

    % Specify the row and column range of the numeric values we want to extract from the table
    row_range = 1:12;
    col_range = 4:8;

    data_mat = table2array(my_table(row_range, col_range));
    
    table = my_table;
    data = data_mat;
end