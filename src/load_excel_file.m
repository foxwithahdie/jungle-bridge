function [table, data] = load_excel_file()
    % Specify the path of the folder where the excel file is saved
    % Make sure either the path string ends in or the file name string begins with
    % Specify the file name of the excel file we want to load
    filename = '..\data\RubberBandTemplate.xlsx';
    % Use `readtable` to load excel file into variable my_table
    % Note: my_table of type `table` which is different from the usual MATLAB matrix data type
    my_table = readtable(filename);
    % Print entire table to the command line
    % disp(my_table);
    % Specify the row and column range of the numeric values we want to extract from the table
    row_range = 1:12;
    col_range = 4:8;
    % Print the block of the table specfied by row_range and col_range
    % disp(my_table(row_range, col_range));
    % Use table2array to convert desired portion of table into matrix
    % Make sure that the specified cells only contain numeric values!
    data_mat = table2array(my_table(row_range, col_range));
    % Display the matrix extracted from the excel file
    % disp(data_mat);
    table = my_table;
    data = data_mat;
end