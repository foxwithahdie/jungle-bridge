function table = rubber_band_data()
    % RUBBER_BAND_DATA Displays a table of all of the rubber band data.
    
    [table_data, ~] = load_excel_file();
    table = table_data;
end
