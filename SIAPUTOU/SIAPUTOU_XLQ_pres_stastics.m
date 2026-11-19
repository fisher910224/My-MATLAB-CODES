%% PROCESSED DATA
clear; close all; clc;

%% PATH
main_folder = 'C:\Users\adm\Desktop\Siaputou';
station = 'Xialiuqiu';
pic_c = [main_folder, '\picture\current'];
pic_w = [main_folder, '\picture\wave'];
pic_wind = [main_folder, '\picture\wind'];
p_data = [main_folder, '\processed_data\', station];
if ~isfolder(pic_c)
    mkdir(pic_c)
end
if ~isfolder(pic_w)
    mkdir(pic_w)
end
if ~isfolder(pic_wind)
    mkdir(pic_wind)
end
if ~isfolder(p_data)
    mkdir(p_data)
end

%% load data
load("C:\Users\adm\Desktop\浮標資料原始資料\Xiaoliuqiu\XLQ.mat")

%% Figure setting
figset_linefont = @(ax) set(ax, 'fontsize', 12, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day

%% XLQ Stastics
% =============================== Pressure ================================
max_values = [];
mean_values = [];
min_values = [];
for ii = 1:length(XLQ.pres)
    for month_number = 1:12
        try
            ig = find(XLQ.pres(ii).ddatetime.Month == month_number);
            max_values(ii, month_number) = max(XLQ.pres(ii).pres(ig));
            mean_values(ii, month_number) = mean(XLQ.pres(ii).pres(ig));
            min_values(ii, month_number) = min(XLQ.pres(ii).pres(ig));
        catch ME
            fprintf('Error: %.0f %s\n', ii, ME.message)
            continue
        end
    end
end
mean_values(mean_values == 0) = NaN;
min_values(min_values == 0) = NaN;

max_max_values = max(max_values);
mean_mean_values = mean(mean_values, 'omitmissing');
min_min_values = min(min_values);

file_name = sprintf("%s\\%s_pres_stastics.txt", p_data, station);
fid = fopen(file_name, "w");
fprintf(fid, "最大,  %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f\n", max_max_values);
fprintf(fid, "平均,  %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f\n", mean_mean_values);
fprintf(fid, "最小,  %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f\n", min_min_values);
fclose(fid);








