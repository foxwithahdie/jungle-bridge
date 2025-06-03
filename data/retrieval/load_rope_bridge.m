function [table_1, table_2, table_3, matrices] = load_rope_bridge()
    % LOAD_ROPE_BRIDGE Loads the string bridge data from
    % '..\RopeBridgeTemplate.xlsx' into data MATLAB can understand.

    matrices = {};

    excel_table = readtable("data/RopeBridgeTemplate.xlsx");
    % Read ranges for each of the tables.
    coords_row_range = 1:7;
    coords_col_range = 2:3;
    weight_row_range = 1:5;
    weight_col_range = 6;
    string_len_row_range = 1:6;
    string_len_col_range = 9;
    
    % Input all of the matrices of numbers from the tables into a cell.
    matrices{end+1} = table2array(excel_table(coords_row_range, coords_col_range));
    matrices{end+1} = table2array(excel_table(weight_row_range, weight_col_range));
    matrices{end+1} = table2array(excel_table(string_len_row_range, string_len_col_range));
    
    % Return all of the table values individually.
    table_1 = excel_table(coords_row_range, coords_col_range);
    table_2 = excel_table(weight_row_range, weight_col_range);
    table_3 = excel_table(string_len_row_range, string_len_col_range);
end