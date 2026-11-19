%% PROCESSED DATA
clear; close all; clc;

%% PATH
main_folder = 'C:\Users\adm\Desktop\Siaputou';
station = 'Xialiuqiu';
pic_c = [main_folder, '\picture\current'];
pic_w = [main_folder, '\picture\wave'];
pic_wind = [main_folder, '\picture\wind'];
p_data = [main_folder, '\processed_data'];
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
% load("C:\Users\adm\Desktop\浮標資料原始資料\Xiaoliuqiu\XLQ.mat")
XLQ = load("C:\Users\adm\Desktop\Processed_data\ProcessedData_XLQ_wave.mat");
%% Figure setting
figset_linefont = @(ax) set(ax, 'fontsize', 12, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day

%% plot(08/06~08/26)
ig = find(XLQ.wave(24).dday >= datenum(2026, 08, 06));
dday = XLQ.wave(24).dday(ig);
Hs = XLQ.wave(24).H(ig);
Tmean = XLQ.wave(24).T(ig);
Dir = XLQ.wave(24).Dir(ig);

saving_time = sprintf("%s_%s", datestr(dday(1), 'yyyymmdd'), datestr(dday(end), 'mmdd'));
file_name = sprintf("%s\\%s_%s_waveheight.txt", p_data, station, saving_time);
fid = fopen(file_name, 'w');
fprintf(fid, "yyyymmdd,   Hs, Tmean, Dir\n");
for ii = 1:length(ig)
    fprintf(fid, "%+8s, %4.1f, %5.1f, %3.0f\n", datestr(dday(ii), 'yyyymmdd'), Hs(ii), Tmean(ii), Dir(ii));
end
fclose(fid);






