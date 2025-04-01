
%specify the path of the folder where the excel file is saved
%make sure either the path string ends in \
%or the file name string begins with \
fpath = 'C:\Users\mdetezanospinto\Documents\';
%specify the file name of the excel file we want to load
fname = 'jungle_bridge.xlsx';

%use read table to load excel file into variable my_table
%note that my_table is a MATLAB table
%which is different from the usual MATLAB matrix data type
my_table = readtable([fpath,fname]);

%print entire table to the command line
disp(my_table);

%specify the row and column range of the numeric values
%we want to extract from the table
row_range = 1:12;
col_range = 4:7;

%print the block of the table specfied by row_range and col_range
disp(my_table(row_range,col_range));
%use table2array to convert desired portion of table into matrix
%make sure that the specified cells only contain numeric values!
data_mat = table2array(my_table(row_range,col_range));

%display the matrix extracted from the excel file
disp(data_mat);

mass_vals = data_mat(1, 1:4).' ./1000;
Y = 9.8 * mass_vals;

A = cell(6, 1);
mb = cell(6, 1);
k = [];
l_0 = [];
for i = 1:6
    A{i} = [data_mat(i*2, 1:4).' ./ 100, ones(4, 1)];
    mb{i} = (A{i}'*A{i})\(A{i}'*Y) ;
    m = mb{i}(1, 1);
    b = mb{i}(2, 1);
    k = [k, m];
    l_0 = [l_0, -b/m];
end

T = array2table([k;l_0], 'VariableNames', {'Band_1', 'Band_2', 'Band_3', 'Band_4', 'Band_5', 'Band_6'}, 'RowName', {'k', 'l_0'}); 
disp(T)

gb_measured_l = A{1}(:, 1).';
gb_measured_F = Y.';
l_values = linspace(gb_measured_l(:, 1), gb_measured_l(:, 4), 201);
green_band_F = k(1,1) * l_values + (l_0(1, 1) * -k(1, 1));

figure()
hold on
scatter(gb_measured_l, gb_measured_F, 'o', 'LineWidth', 2)
plot(l_values, green_band_F, '-', 'LineWidth', 2)
xlabel('Length (m)')
ylabel('Force (N)')
title('Force vs. Length')
subtitle('(green rubber band)')
legend('Measured', 'Line of best fit')
grid on
hold off

m_vals = linspace(mb{1}(1, 1) - 50,mb{1}(1, 1) + 50, 201);
b_vals = linspace(mb{1}(2, 1) - 5, mb{1}(2, 1) + 5, 201);
[M_vals, B_vals] = meshgrid(m_vals, b_vals);
total_cost = [];

figure();
contourf(M_vals, B_vals, total_cost);

function total_cost = run_cost(A, Y, mb)
    m = mb(1, 1); 
    b = mb(2, 1);
    total_cost = 0;
    for n = 1:4
      cost = (m .* A{1}(n, 1) + b - Y(n)).^2;
      total_cost = total_cost + cost;
    end
end



