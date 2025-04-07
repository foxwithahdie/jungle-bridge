function [table, data] = load_excel_file()
    filename = '..\data\RubberBandTemplate.xlsx';
    
    my_table = readtable(filename);

    % Specify the row and column range of the numeric values we want to extract from the table
    row_range = 1:12;
    col_range = 4:8;

    data_mat = table2array(my_table(row_range, col_range));

    table = my_table;
    data = data_mat;
end
