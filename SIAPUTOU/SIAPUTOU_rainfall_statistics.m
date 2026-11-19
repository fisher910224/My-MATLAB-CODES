%% RAINFALL STATISTICS
% 20260914
clear; close all; clc;

%% LOAD DATA
% opts.NumHeaderLines = 121;
% opts = detectImportOptions("C:\Users\adm\Desktop\Siaputou\天氣資料\塭仔\LotsDataReports.txt");
opts = fixedWidthImportOptions('NumVariables', 3);
opts.DataLines = [121, Inf];
opts.MissingRule = 'fill';
opts.VariableTypes = {'string', 'string', 'double'};
opts.VariableWidths = [7, 7, 8];
opts.VariableNamesLine = 120;
opts.VariableNamingRule = 'preserve';
WZ_data = readtable("C:\Users\adm\Desktop\Siaputou\天氣資料\塭仔\LotsDataReports.txt", opts);
df.WZ.ddatetime = datetime(WZ_data.yyyymm, "InputFormat", "yyyyMM");
df.WZ.rainfall = WZ_data.PP01;

DG_data = readtable("C:\Users\adm\Desktop\Siaputou\天氣資料\東港640\LotsDataReports.txt", opts);
df.DG.ddatetime = datetime(DG_data.yyyymm, "InputFormat", "yyyyMM");
df.DG.rainfall = DG_data.PP01;

FL_data = readtable("C:\Users\adm\Desktop\Siaputou\天氣資料\枋寮660\LotsDataReports.txt", opts);
df.FL.ddatetime = datetime(FL_data.yyyymm, "InputFormat", "yyyyMM");
df.FL.rainfall = FL_data.PP01;

JD_data = readtable("C:\Users\adm\Desktop\Siaputou\天氣資料\佳冬\LotsDataReports.txt", opts);
df.JD.ddatetime = datetime(JD_data.yyyymm, "InputFormat", "yyyyMM");
df.JD.rainfall = JD_data.PP01;

%% OUTPUT STATISTICS TABLE
stations = {"WZ", "DG", "JD", "FL"};
sta_str = {"塭仔", "東港", "佳冬", "枋寮"};
for jj = 1:length(stations)
    for month_time = 1:12
        ig = find(df.([stations{jj}]).ddatetime.Month == month_time);
        df.([stations{jj}]).monthly(month_time) = mean(df.([stations{jj}]).rainfall(ig), "omitmissing");
    end
    df.([stations{jj}]).yearly = sum(df.([stations{jj}]).monthly);
    df.([stations{jj}]).monthmean = mean(df.([stations{jj}]).monthly);
end


outputdatafolder_path = "C:\Users\adm\Desktop\Siaputou\processed_data";
filename = "rainfall_statistics.csv";
fid = fopen(fullfile(outputdatafolder_path, filename), "w", "n", "UTF-8");
fwrite(fid, [239 187 191], 'uint8'); 
fprintf(fid, "測站/月份,%s年均,月均\n", num2str(1:12, "%d,"));
another_table = [];
for ii = 1:length(sta_str)
    fprintf(fid, "%s", sta_str{ii});
    fid_fprintf_str = sprintf("%s", repmat(",%.1f", 14, 1));
    fprintf(fid, fid_fprintf_str, df.([stations{ii}]).monthly, df.([stations{ii}]).yearly, df.([stations{ii}]).monthmean);
    fprintf(fid, "\n");
    another_table(ii, :) = [df.([stations{ii}]).monthly, df.([stations{ii}]).yearly, df.([stations{ii}]).monthmean];
end
fprintf(fid, "平均");
fprintf(fid, fid_fprintf_str, mean(another_table));


fclose(fid);







