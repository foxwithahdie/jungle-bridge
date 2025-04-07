function table = rubber_band_data()
    [table_data, ~] = load_excel_file();
    table = table_data;
end