%% Plot KHS Port1 & 2
% 20260908
clear; close all; clc;

%% Path
main_folder = 'C:\Users\adm\Desktop\Kaohsiung';
station = 'Kaohsiung';
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
P1 = load("C:\Users\adm\Desktop\Kaohsiung\一港口\ProcessedData_p1.mat");
P2 = load("C:\Users\adm\Desktop\Kaohsiung\二港口\ProcessedData_p2.mat");
load("C:\Users\adm\Desktop\Kaohsiung\wind\ProcessedData.mat");

period_Krathon = datetime(2024, 9, 15):datetime(2024, 10, 16);
saving_time = sprintf("%s_%s", datestr(period_Krathon(1), 'yyyymmdd'), datestr(period_Krathon(end), 'mmdd'));
plot_time = sprintf("%s~%s", datestr(period_Krathon(1), 'yyyy/mm/dd'), datestr(period_Krathon(end), 'mm/dd'));

%% Figure setting
figset_linefont = @(ax) set(ax, 'fontsize', 15, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day

%% Wind statistics
ig = find(Wind.ddatetime >= period_Krathon(1) & Wind.ddatetime <= period_Krathon(end));
W_time = Wind.ddatetime(ig);
WSm = Wind.WSm(ig);
WDm = Wind.WDm(ig);
WSmax = Wind.WSmax(ig);
WDmax = Wind.WDmax(ig);
WSmax_time = Wind.WSmax_time(ig);
[D, counts] = find_main_direction(WDm);

df_name = fullfile(p_data, sprintf("%s_wind_statistics.csv", saving_time));
fid = fopen(df_name, "w", "n", "UTF-8");
fwrite(fid, [239 187 191], 'uint8'); 
[~, idx] = max(WSmax);
fprintf(fid, "期間平均風速(m/s),%.2f\n", mean(WSm, "omitmissing"));
fprintf(fid, "期間主要風向,%.1f(%s)\n", mean(WDm), D);
fprintf(fid, "期間最大風速(m/s),%.2f\n", max(WSmax));
fprintf(fid, "最大風速對應風向,%.1f(%s)\n", WDmax(idx), find_main_direction(WDmax(idx)));
fprintf(fid, "最大風速發生時間,%s\n", WSmax_time{idx});
fclose(fid);


fig = figure;
title_str = sprintf("%s~%s", datestr(Wind.ddatetime(ig(1)), 'yyyy/mm/dd'), datestr(Wind.ddatetime(ig(end)), 'mm/dd'));
ax = nexttile;
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1.2;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 30;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'jet';
% gg = app.WindRose_all_MaxFrequency/app.WindRose_all_nfreq;
% Options.vWinds          = 0:gg:app.WindRose_all_MaxFrequency;
Options.LabLegend       = 'Wind speed (m/s)';
Options.LegendVariable  = 'V';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

valid_idx = ~isnan(WDm) & ~isnan(WSm);
Rose_dir = WDm(valid_idx);
Rose_WS = WSm(valid_idx);
% fprintf('原始資料筆數: %d, 過濾後剩餘筆數: %d %d\n', length(all_Dirm), length(Rose_dir), length(Rose_WS));
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'northwestoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 12)
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end

% saving_str = sprintf("%s\\%s_WS_DIR_statistics_rose.png", pic_wind, station);
% exportgraphics(gcf, saving_str)
file_ext = ".png";
saving_str = fullfile(pic_wind, sprintf("%s_%s_WS_DIR_statistics_rose%s", saving_time, station, file_ext));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)       
% close(fig);


%% Wave statistics
ig = find(P1.W.ddatetime >= period_Krathon(1) & P1.W.ddatetime <= period_Krathon(end));
p1.Hs = P1.W.H(ig)/100;
p1.T = P1.W.T(ig);
p1.Tmean = P1.W.Tmean(ig);
p1.Dir = P1.W.Dir(ig);
p1.dday = P1.W.ddatetime(ig);


ig = find(P2.W.ddatetime >= period_Krathon(1) & P2.W.ddatetime <= period_Krathon(end));
p2.Hs = P2.W.H(ig)/100;
p2.T = P2.W.T(ig);
p2.Tmean = P2.W.Tmean(ig);
p2.Dir = P2.W.Dir(ig);
p2.dday = P2.W.ddatetime(ig);


fid = fopen(fullfile(p_data, sprintf("%s_wave_statistics.csv", saving_time)), "w", "n", "UTF-8");
fwrite(fid, [239 187 191], "uint8");
fprintf(fid, "一港口波高統計資料\n");
fprintf(fid, "期間平均波高(cm),%.2f\n", mean(p1.Hs, "omitmissing"));
fprintf(fid, "期間平均週期(s),%.1f\n", mean(p1.T, "omitmissing"));
fprintf(fid, "期間最大週期(s),%.1f\n", max(p1.T, [], "omitmissing"));
fprintf(fid, "期間主要波向,%s\n", find_main_direction(p1.Dir));
[mm, idx] = max(p1.Hs, [], "omitmissing");
fprintf(fid, "期間最大波高(cm),%.2f\n", mm);
fprintf(fid, "最大波高對應週期(s),%.1f\n", p1.T(idx));
fprintf(fid, "最大波高對應波向,%.1f(%s)\n", p1.Dir(idx), find_main_direction(p1.Dir(idx)));
fprintf(fid, "最大波高發生時間,%s\n", datestr(p1.dday(idx), 'yyyy/MM/dd HH:mm'));

fprintf(fid, "\n二港口波高統計資料\n");
fprintf(fid, "期間平均波高(cm),%.2f\n", mean(p2.Hs, "omitmissing"));
fprintf(fid, "期間平均週期(s),%.1f\n", mean(p2.T, "omitmissing"));
fprintf(fid, "期間最大週期(s),%.1f\n", max(p2.T, [], "omitmissing"));
fprintf(fid, "期間主要波向,%s\n", find_main_direction(p2.Dir));
[mm, idx] = max(p2.Hs, [], "omitmissing");
fprintf(fid, "期間最大波高(cm),%.2f\n", mm);
fprintf(fid, "最大波高對應週期(s),%.1f\n", p2.T(idx));
fprintf(fid, "最大波高對應波向,%.1f(%s)\n", p2.Dir(idx), find_main_direction(p2.Dir(idx)));
fprintf(fid, "最大波高發生時間,%s\n", datestr(p2.dday(idx), 'yyyy/MM/dd HH:mm'));
% fclose(fid);

% fid = fopen(fullfile(p_data, sprintf("%s_wave_monthly_statistics.csv", saving_time)), "w", "n", "UTF-8");
% fwrite(fid, [239 187 191], "uint8");
fprintf(fid, "\n測站,Hmax,Tmax,Dmax,發生時間,H1/10,T1/10,H1/3,T1/3,Hmean,Tmean,波向\n");
[mm, idx] = max(p1.Hs, [], "omitmissing");
[H_sort, n_sort] = sort(p1.Hs, "descend");
T_sort = p1.T(n_sort);
H_10 = mean(H_sort(1:round(length(p1.Hs)/10)), "omitmissing");
T_10 = mean(T_sort(1:round(length(p1.T)/10)), "omitmissing");
H_3 = mean(H_sort(1:round(length(p1.Hs)*3/10)), "omitmissing");
T_3 = mean(T_sort(1:round(length(p1.T)*3/10)), "omitmissing");
fprintf(fid, "一港口,%.2f,%.2f,%s,%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n", ...
    mm, p1.T(idx), find_main_direction(p1.Dir(idx)), datestr(p1.dday(idx), 'yyyy/mm/dd HH:MM'), ...
    H_10, T_10, H_3, T_3, mean(p1.Hs, "omitmissing"), mean(p1.T, "omitmissing"), mean(p1.Dir, "omitmissing"));

[mm, idx] = max(p2.Hs, [], "omitmissing");
[H_sort, n_sort] = sort(p2.Hs, "descend");
T_sort = p2.T(n_sort);
H_10 = mean(H_sort(1:round(length(p2.Hs)/10)), "omitmissing");
T_10 = mean(T_sort(1:round(length(p2.T)/10)), "omitmissing");
H_3 = mean(H_sort(1:round(length(p2.Hs)*3/10)), "omitmissing");
T_3 = mean(T_sort(1:round(length(p2.T)*3/10)), "omitmissing");
fprintf(fid, "二港口,%.2f,%.2f,%s,%s,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f,%.2f\n", ...
    mm, p2.T(idx), find_main_direction(p2.Dir(idx)), datestr(p2.dday(idx), 'yyyy/mm/dd HH:MM'), ...
    H_10, T_10, H_3, T_3, mean(p2.Hs, "omitmissing"), mean(p2.T, "omitmissing"), mean(p2.Dir, "omitmissing"));
fclose(fid);



fig = figure;
title_str = sprintf("KHS-Port 1, %s", plot_time);
ax = nexttile;
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1.2;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 40;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'jet';
% gg = app.WindRose_all_MaxFrequency/app.WindRose_all_nfreq;
% Options.vWinds          = 0:gg:app.WindRose_all_MaxFrequency;
Options.LabLegend       = 'Wave height (m)';
Options.LegendVariable  = 'Hs';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

valid_idx = ~isnan(p1.Hs) & ~isnan(p1.Dir);
Rose_dir = p1.Dir(valid_idx);
Rose_WS = p1.Hs(valid_idx);
% fprintf('原始資料筆數: %d, 過濾後剩餘筆數: %d %d\n', length(all_Dirm), length(Rose_dir), length(Rose_WS));
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'northwestoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 10)
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end

% saving_str = sprintf("%s\\%s_WS_DIR_statistics_rose.png", pic_wind, station);
% exportgraphics(gcf, saving_str)
% file_ext = ".png";
saving_str = fullfile(pic_w, sprintf("%s_%s_Hs_DIR_p1_statistics_rose.png", saving_time, station));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)  




fig = figure;
title_str = sprintf("KHS-Port 2, %s", plot_time);
ax = nexttile;
% clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1.2;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 40;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'jet';
% gg = app.WindRose_all_MaxFrequency/app.WindRose_all_nfreq;
% Options.vWinds          = 0:gg:app.WindRose_all_MaxFrequency;
Options.LabLegend       = 'Wave height (m)';
Options.LegendVariable  = 'Hs';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

valid_idx = ~isnan(p2.Hs) & ~isnan(p2.Dir);
Rose_dir = p2.Dir(valid_idx);
Rose_WS = p2.Hs(valid_idx);
% fprintf('原始資料筆數: %d, 過濾後剩餘筆數: %d %d\n', length(all_Dirm), length(Rose_dir), length(Rose_WS));
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'northwestoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 10)
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end

% saving_str = sprintf("%s\\%s_WS_DIR_statistics_rose.png", pic_wind, station);
% exportgraphics(gcf, saving_str)
file_ext = ".png";
saving_str = fullfile(pic_w, sprintf("%s_%s_Hs_DIR_p2_statistics_rose%s", saving_time, station, file_ext));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)  

%% 
fig = figure("OuterPosition", [1 1 1920/2 1080]);
tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
Hs_interval = [0, 0.1, 0.2, 0.6, 1, 2, 3, 4, 6, 7, 9, 11.5, 14, 16, 18, 20, 25, 30, 40, Inf];
Hs_stas = [];
for ii = 1:length(Hs_interval)-1
    ig = find(p1.Hs >= Hs_interval(ii) & p1.Hs < Hs_interval(ii+1));
    Hs_stas(ii) = length(ig)/numel(p1.Hs)*100;
end
plot(1:length(Hs_interval)-1, Hs_stas, 'LineWidth', 2, 'Marker', '*', 'Color', 'k');
XTicklabels_str = {'<0.1 m', '0.1~0.2 m', '0.2~0.6 m', '0.6~1 m', '1~2 m', '2~3 m', '3~4 m', '4~6 m', ...
    '6~7 m', '7~9 m', '9~11.5 m', '11.5~14 m', '14~16 m', '16~18 m', '18~20 m', '20~25 m', '25~30 m', '30~40 m', '>40 m'};
set(ax, 'Xtick', 1:length(Hs_interval)-1, 'XTicklabels', XTicklabels_str)
ylabel("(%)")
xlabel("Hs (m)")
ylim([0 50])
xlim([1 length(Hs_interval)-1])
grid on
title_str = sprintf("\\bfPort 1 Wave Stastistics Diagram\n\\rm%s", plot_time);
title(ax, title_str)
text(-0.07, 1.1, "(a)", "FontSize", 18, "Units", "normalized")
figset_linefont(ax)


ax = nexttile;
Tp_interval = [0, 3:10, 12, 16, 20, 40, 60, Inf];
Tp_stas = [];
for ii = 1:length(Tp_interval)-1
    ig = find(p1.T >= Tp_interval(ii) & p1.T < Tp_interval(ii+1));
    Tp_stas(ii) = length(ig)/numel(p1.Hs)*100;
end
plot(1:length(Tp_interval)-1, Tp_stas, 'LineWidth', 2, 'Marker', '*', 'Color', 'k');
XTicklabels_str = {'<3 s', '3~4 s', '4~5 s', '5~6 s', '6~7 s', '7~8 s', '8~9 s', '9~10 s', ...
    '10~12 s', '12~16 s', '16~20 s', '20~40 s', '40~60 s', '>60 s'};
set(ax, 'Xtick', 1:length(Tp_interval)-1, 'XTicklabels', XTicklabels_str)
ylabel("(%)")
xlabel("T_p (s)")
ylim([0 40])
xlim([1 length(Tp_interval)-1])
grid on
text(-0.07, 1.1, "(b)", "FontSize", 18, "Units", "normalized")
figset_linefont(ax)


ax = nexttile;
[~, Dir_stas] = find_main_direction(p1.Dir);
load("directions_str.mat")
plot(1:16, Dir_stas/numel(p1.Dir)*100, 'LineWidth', 2, 'Marker', '*', 'Color', 'k');
XTicklabels_str = directions_str;
set(ax, 'Xtick', 1:16, 'XTicklabels', XTicklabels_str)
ylabel("(%)")
xlabel("wave direction")
ylim([0 40])
xlim([1 16])
grid on
text(-0.07, 1.1, "(c)", "FontSize", 18, "Units", "normalized")
figset_linefont(ax)

saving_str = fullfile(pic_w, sprintf("%s_%s_Hs_Tp_DIR_p1_statistics_rose.png", saving_time, station));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)  




fig = figure("OuterPosition", [1 1 1920/2 1080]);
tt = tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
Hs_interval = [0, 0.1, 0.2, 0.6, 1, 2, 3, 4, 6, 7, 9, 11.5, 14, 16, 18, 20, 25, 30, 40, Inf];
Hs_stas = [];
for ii = 1:length(Hs_interval)-1
    ig = find(p2.Hs >= Hs_interval(ii) & p2.Hs < Hs_interval(ii+1));
    Hs_stas(ii) = length(ig)/numel(p2.Hs)*100;
end
plot(1:length(Hs_interval)-1, Hs_stas, 'LineWidth', 2, 'Marker', '*', 'Color', 'k');
XTicklabels_str = {'<0.1 m', '0.1~0.2 m', '0.2~0.6 m', '0.6~1 m', '1~2 m', '2~3 m', '3~4 m', '4~6 m', ...
    '6~7 m', '7~9 m', '9~11.5 m', '11.5~14 m', '14~16 m', '16~18 m', '18~20 m', '20~25 m', '25~30 m', '30~40 m', '>40 m'};
set(ax, 'Xtick', 1:length(Hs_interval)-1, 'XTicklabels', XTicklabels_str)
ylabel("(%)")
xlabel("Hs (m)")
ylim([0 50])
xlim([1 length(Hs_interval)-1])
grid on
title_str = sprintf("\\bfPort 2 Wave Stastistics Diagram\n\\rm%s", plot_time);
title(ax, title_str)
text(-0.07, 1.1, "(a)", "FontSize", 18, "Units", "normalized")
figset_linefont(ax)


ax = nexttile;
Tp_indterval = [0, 3:10, 12, 16, 20, 40, 60, Inf];
Tp_stas = [];
for ii = 1:length(Tp_interval)-1
    ig = find(p2.T >= Tp_interval(ii) & p2.T < Tp_interval(ii+1));
    Tp_stas(ii) = length(ig)/numel(p2.Hs)*100;
end
plot(1:length(Tp_interval)-1, Tp_stas, 'LineWidth', 2, 'Marker', '*', 'Color', 'k');
XTicklabels_str = {'<3 s', '3~4 s', '4~5 s', '5~6 s', '6~7 s', '7~8 s', '8~9 s', '9~10 s', ...
    '10~12 s', '12~16 s', '16~20 s', '20~40 s', '40~60 s', '>60 s'};
set(ax, 'Xtick', 1:length(Tp_interval)-1, 'XTicklabels', XTicklabels_str)
ylabel("(%)")
xlabel("T_p (s)")
ylim([0 40])
xlim([1 length(Tp_interval)-1])
grid on
text(-0.07, 1.1, "(b)", "FontSize", 18, "Units", "normalized")
figset_linefont(ax)


ax = nexttile;
[D, Dir_stas] = find_main_direction(p2.Dir);
load("directions_str.mat")
plot(1:16, Dir_stas/numel(p2.Dir)*100, 'LineWidth', 2, 'Marker', '*', 'Color', 'k');
XTicklabels_str = directions_str;
set(ax, 'Xtick', 1:16, 'XTicklabels', XTicklabels_str)
ylabel("(%)")
xlabel("wave direction")
ylim([0 40])
xlim([1 16])
grid on
text(-0.07, 1.1, "(c)", "FontSize", 18, "Units", "normalized")
figset_linefont(ax)

saving_str = fullfile(pic_w, sprintf("%s_%s_Hs_Tp_DIR_p2_statistics_rose.png", saving_time, station));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)  

%% Current statistics
ig = find(P1.C.ddatetime >= period_Krathon(1) & P1.C.ddatetime <= period_Krathon(end));
p1.Vel = P1.C.Cur(ig);
p1.CDir = P1.C.Dir(ig);
p1.c_dday = P1.C.ddatetime(ig);
p1.u = P1.C.u(ig);
p1.v = P1.C.v(ig);

ig = find(P2.C.ddatetime >= period_Krathon(1) & P2.C.ddatetime <= period_Krathon(end));
p2.Vel = P2.C.Cur(ig);
p2.CDir = P2.C.Dir(ig);
p2.c_dday = P2.C.ddatetime(ig);
p2.u = P2.C.u(ig);
p2.v = P2.C.v(ig);


fid = fopen(fullfile(p_data, sprintf("%s_current_statistics.csv", saving_time)), "w", "n", "UTF-8");
fwrite(fid, [239 187 191], "uint8");
fprintf(fid, "一港口海流統計資料\n");
fprintf(fid, "期間平均流速(cm/s),%.2f\n", mean(p1.Vel, "omitmissing")*100);
fprintf(fid, "期間主要流向,%s\n", find_main_direction(p1.CDir));
[mm, idx] = max(p1.Vel, [], "omitmissing");
fprintf(fid, "期間最大流速(cm/s),%.2f\n", mm*100);
fprintf(fid, "最大流速對應流向,%.1f(%s)\n", p1.CDir(idx), find_main_direction(p1.CDir(idx)));
fprintf(fid, "最大流速發生時間,%s\n", datestr(p1.c_dday(idx), 'yyyy/MM/dd HH:mm'));

fprintf(fid, "\n二港口海流統計資料\n");
fprintf(fid, "期間平均流速(cm/s),%.2f\n", mean(p2.Vel, "omitmissing")*100);
fprintf(fid, "期間主要流向,%s\n", find_main_direction(p2.CDir));
[mm, idx] = max(p2.Vel, [], "omitmissing");
fprintf(fid, "期間最大流速(cm/s),%.2f\n", mm*100);
fprintf(fid, "最大流速對應流向,%.1f(%s)\n", p2.CDir(idx), find_main_direction(p2.CDir(idx)));
fprintf(fid, "最大流速發生時間,%s\n", datestr(p2.c_dday(idx), 'yyyy/MM/dd HH:mm'));
fclose(fid);


filename = sprintf('%s\\%s_port1_%s_Cur_Dir.txt', p_data, saving_time, station);
Vanalyis(p1.u*100, p1.v*100, p1.Vel*100, p1.CDir, filename, p_data);   %輸出流速流向聯合機率分布統計表

filename = sprintf('%s\\%s_port2_%s_Cur_Dir.txt', p_data, saving_time, station);
Vanalyis(p2.u*100, p2.v*100, p2.Vel*100, p2.CDir, filename, p_data);   %輸出流速流向聯合機率分布統計表



fig = figure;
title_str = sprintf("KHS-Port 1\n%s", plot_time);
ax = nexttile;
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1.2;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 40;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'jet';
% gg = app.WindRose_all_MaxFrequency/app.WindRose_all_nfreq;
% Options.vWinds          = 0:gg:app.WindRose_all_MaxFrequency;
Options.LabLegend       = 'Current speed (m/s)';
Options.LegendVariable  = 'Vel.';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

valid_idx = ~isnan(p1.Vel) & ~isnan(p1.CDir);
Rose_dir = p1.CDir(valid_idx);
Rose_WS = p1.Vel(valid_idx);
% fprintf('原始資料筆數: %d, 過濾後剩餘筆數: %d %d\n', length(all_Dirm), length(Rose_dir), length(Rose_WS));
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'northwestoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 10)
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end

% saving_str = sprintf("%s\\%s_WS_DIR_statistics_rose.png", pic_wind, station);
% exportgraphics(gcf, saving_str)
file_ext = ".png";
saving_str = fullfile(pic_c, sprintf("%s_%s_Cur_DIR_p1_statistics_rose%s", saving_time, station, file_ext));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)  




fig = figure;
title_str = sprintf("KHS-Port 2\n%s", plot_time);
ax = nexttile;
clear Options % 清除舊變數確保乾淨
Options.nDirections     = 16;
Options.AngleNorth      = 0;
Options.AngleEast       = 90;
Options.labels          = {'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'};
Options.gridstyle       = ':';
Options.radialgridstyle = ':';
Options.gridcolor       = 'k';
Options.gridwidth       = 1.2;
Options.gridalpha       = 0.5;
Options.MaxFrequency    = 40;
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'jet';
% gg = app.WindRose_all_MaxFrequency/app.WindRose_all_nfreq;
% Options.vWinds          = 0:gg:app.WindRose_all_MaxFrequency;
Options.LabLegend       = 'Current speed (m/s)';
Options.LegendVariable  = 'Vel.';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

valid_idx = ~isnan(p2.CDir) & ~isnan(p2.Vel);
Rose_dir = p2.CDir(valid_idx);
Rose_WS = p2.Vel(valid_idx);
% fprintf('原始資料筆數: %d, 過濾後剩餘筆數: %d %d\n', length(all_Dirm), length(Rose_dir), length(Rose_WS));
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'northwestoutside', 'Box', 'off')
set(ax, 'TitleHorizontalAlignment', 'left', 'fontsize', 10)
all_text = findall(ax, 'Type', 'text');
for ii = 1:length(all_text)
    txt_str = all_text(ii).String;
    
    % 如果文字中包含 '%'，代表它是頻率標籤
    if contains(txt_str, '%')
        set(all_text(ii), ...
            'HorizontalAlignment', 'center', ...   % 水平對齊：left, center, right
            'VerticalAlignment', 'bottom', ...   % 垂直對齊：top, middle, bottom
            'FontSize', 10, ...                  % 字體大小
            'FontWeight', 'bold', ...            % 加粗
            'Color', [0.2 0.2 0.2], ...          % 深灰色
            'FontName', 'Helvetica');            % 字體名稱
            
        % 如果你想讓文字稍微「位移」一點點，不要貼在線上面：
        % pos = all_text(i).Position;
        % all_text(i).Position = pos + [0.5 0 0]; % 往右位移 0.5 單位
    end
end

% saving_str = sprintf("%s\\%s_WS_DIR_statistics_rose.png", pic_wind, station);
% exportgraphics(gcf, saving_str)
file_ext = ".png";
saving_str = fullfile(pic_c, sprintf("%s_%s_Cur_DIR_p2_statistics_rose%s", saving_time, station, file_ext));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)  


%% Wave plot
% ======================= P1 ========================
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(5, 1, "TileSpacing", "compact", "Padding", "tight");
% title_str = sprintf("")
% title(tt, "")
ax = nexttile;
Wu = -WSm.*sind(WDm);
Wv = -WSm.*cosd(WDm);
quiver_f(datenum(W_time), Wu, Wv)
ylabel('Wind speed (m s^{-1})')
title(ax, "Wind")
figset_linefont(ax)
figset_date(ax, datenum(W_time))
figset_date_minorticks(ax, datenum(W_time))
ylim([-40 40])
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
grid on
text(0, 1.1, "(a)", "FontSize", 18, "Units", "normalized")

ax = nexttile;
% wave_day = datenum(p1.dday(1)):datenum(hours(1)):datenum(p1.dday(end));
% gg = find(wave_day == datenum(p1.dday));
wave_day = datenum(p1.dday);
f = Test1(datenum(p1.dday), 1, 0.1, 0.5);
ig = find(f == 1);
wdday = NaN(size(p1.dday));
ipt = NaN(size(p1.Hs));
wdday(ig) = wave_day(ig);
ipt(ig) = p1.Hs(ig);
plot(wave_day, p1.Hs, 'r', "DisplayName", "Port 1_{raw}", "LineWidth", 2); hold on
plot(wdday, ipt, "k", "DisplayName", "Port 1_{QC}", "LineWidth", 2)



% wave_day = datenum(p2.dday);
% plot(wave_day, p2.Hs, 'b', "DisplayName", "Port 2", "LineWidth", 2)
grid on
legend
ylabel('Height (m)')
title(ax, "Wave")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)

ax = nexttile;
% wave_day = datenum(p1.dday);
plot(wave_day, p1.Tmean, 'r', "DisplayName", "Port 1_{raw}", "LineWidth", 2); hold on
ipt(ig) = p1.Tmean(ig);
plot(wdday, ipt, "k", "DisplayName", "Port 1_{QC}", "LineWidth", 2)
% wave_day = datenum(p2.dday);
% plot(wave_day, p2.T, 'b', "DisplayName", "Port 2", "LineWidth", 2)
grid on
legend
ylabel('T_{mean} (s)')
% title(ax, "Period")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)


ax = nexttile;
% wave_day = datenum(p1.dday);
plot(wave_day, p1.T, 'r', "DisplayName", "Port 1_{raw}", "LineWidth", 2); hold on
ipt(ig) = p1.T(ig);
plot(wdday, ipt, "k", "DisplayName", "Port 1_{QC}", "LineWidth", 2)
% wave_day = datenum(p2.dday);
% plot(wave_day, p2.T, 'b', "DisplayName", "Port 2", "LineWidth", 2)
grid on
legend
ylabel('T_p (s)')
% title(ax, "Period")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)


ax = nexttile;
% wave_day = datenum(p1.dday);
plot(wave_day, p1.Dir, 'r.', "DisplayName", "Port 1_{raw}", "LineWidth", 2, "MarkerSize", 10); hold on
ipt(ig) = p1.Dir(ig);
plot(wdday, ipt, "k.", "DisplayName", "Port 1_{QC}", "LineWidth", 2, "MarkerSize", 10)
% wave_day = datenum(p2.dday);
% plot(wave_day, p2.Dir, 'b.', "DisplayName", "Port 2", "LineWidth", 2, "MarkerSize", 10)
grid on
legend
set(ax, 'YTick', 0:90:360)
ylim([0 360])
ylabel('Direction (degree)')
% title(ax, "Direction")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)

xlabel(tt, "Data (mm/dd)", "Fontweight", "bold", "FontSize", 15)

saving_str = fullfile(pic_w, sprintf("%s_%s_Hs_P1_plot.png", saving_time, station));
exportgraphics(gcf, saving_str)



% ======================= P2 =======================
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(5, 1, "TileSpacing", "compact", "Padding", "tight");
% title_str = sprintf("")
% title(tt, "")
ax = nexttile;
Wu = -WSm.*sind(WDm);
Wv = -WSm.*cosd(WDm);
quiver_f(datenum(W_time), Wu, Wv)
ylabel('Wind speed (m s^{-1})')
title(ax, "Wind")
figset_linefont(ax)
figset_date(ax, datenum(W_time))
figset_date_minorticks(ax, datenum(W_time))
ylim([-40 40])
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
grid on

ax = nexttile;
% wave_day = datenum(p2.dday(1)):datenum(hours(1)):datenum(p2.dday(end));
% gg = find(wave_day == datenum(p2.dday));
wave_day = datenum(p2.dday);
f = Test1(datenum(p2.dday), 1, 0.1, 0.5);
ig = find(f == 1);
wdday = NaN(size(p2.dday));
ipt = NaN(size(p2.Hs));
wdday(ig) = wave_day(ig);
ipt(ig) = p2.Hs(ig);
plot(wave_day, p2.Hs, 'r', "DisplayName", "Port 2_{raw}", "LineWidth", 2); hold on
plot(wdday, ipt, "k", "DisplayName", "Port 2_{QC}", "LineWidth", 2)



% wave_day = datenum(p2.dday);
% plot(wave_day, p2.Hs, 'b', "DisplayName", "Port 2", "LineWidth", 2)
grid on
legend
ylabel('Height (m)')
title(ax, "Wave")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)


ax = nexttile;
% wave_day = datenum(p2.dday);
plot(wave_day, p2.Tmean, 'r', "DisplayName", "Port 2_{raw}", "LineWidth", 2); hold on
ipt(ig) = p2.Tmean(ig);
plot(wdday, ipt, "k", "DisplayName", "Port 2_{QC}", "LineWidth", 2)
% wave_day = datenum(p2.dday);
% plot(wave_day, p2.T, 'b', "DisplayName", "Port 2", "LineWidth", 2)
grid on
legend
ylabel('T_{mean} (s)')
% title(ax, "Period")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)


ax = nexttile;
% wave_day = datenum(p2.dday);
plot(wave_day, p2.T, 'r', "DisplayName", "Port 2_{raw}", "LineWidth", 2); hold on
ipt(ig) = p2.T(ig);
plot(wdday, ipt, "k", "DisplayName", "Port 2_{QC}", "LineWidth", 2)
% wave_day = datenum(p2.dday);
% plot(wave_day, p2.T, 'b', "DisplayName", "Port 2", "LineWidth", 2)
grid on
legend
ylabel('T_p (s)')
% title(ax, "Period")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)


ax = nexttile;
% wave_day = datenum(p2.dday);
plot(wave_day, p2.Dir, 'r.', "DisplayName", "Port 2_{raw}", "LineWidth", 2, "MarkerSize", 10); hold on
ipt(ig) = p2.Dir(ig);
plot(wdday, ipt, "k.", "DisplayName", "Port 2_{QC}", "LineWidth", 2, "MarkerSize", 10)
% wave_day = datenum(p2.dday);
% plot(wave_day, p2.Dir, 'b.', "DisplayName", "Port 2", "LineWidth", 2, "MarkerSize", 10)
grid on
legend
set(ax, 'YTick', 0:90:360)
ylim([0 360])
ylabel('Direction (degree)')
% title(ax, "Direction")
xlim([floor(datenum(W_time(1))) ceil(datenum(W_time(end)))])
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)
xlabel(tt, "Data (mm/dd)", "Fontweight", "bold", "FontSize", 15)

saving_str = fullfile(pic_w, sprintf("%s_%s_Hs_P2_plot.png", saving_time, station));
exportgraphics(gcf, saving_str)



%% Wave plot
figure("OuterPosition", [1 1 1920/2 1080])
% figure
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");

ax = nexttile;
f = Test1(datenum(p1.c_dday), 1, 0.1, 0.5);
c_dday = NaN(size(p1.c_dday));
ipt = NaN(size(p1.Vel));
ig = find(f == 1);
c_dday(ig) = datenum(p1.c_dday(ig));
ipt(ig) = p1.Vel(ig);
plot(datenum(p1.c_dday), p1.Vel*100, 'r', "DisplayName", "Port 1_{raw}", "LineWidth", 2); hold on
plot(c_dday, ipt*100, 'k', "DisplayName", "Port 1_{QC}", "LineWidth", 2)
% plot(datenum(p2.c_dday), p2.Vel*100, 'b', "DisplayName", "Port 2", "LineWidth", 2)
grid on
legend
ylabel('Speed (cm s^{-1})')
xlim([floor(datenum(p1.c_dday(1))) ceil(datenum(p1.c_dday(end)))])
title(ax, "Current Port 1")
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)


ax = nexttile;
ipt_u = [];
ipt_v = [];
ipt_u(ig, 1) = p1.u(ig);
ipt_v(ig, 1) = p1.v(ig);
quiver_f(datenum(p1.c_dday), p1.u*100, p1.v*100, "Color", "r"); hold on
quiver_f(c_dday, ipt_u*100, ipt_v*100, "Color", "k"); hold on
% quiver_f(datenum(p2.c_dday), p2.u*100, p2.v*100, "Color", "b")
grid on
legend("Port 1_{raw}", "Port 1_{QC}")
ylim([-80 80])
xlim([floor(datenum(p1.c_dday(1))) ceil(datenum(p1.c_dday(end)))])
ylabel('Speed (cm s^{-1})')
% title(ax, "Current")
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)

ax = nexttile;
% plot(datenum(p1.c_dday), p1.Vel*100, 'k', "DisplayName", "Port 1", "LineWidth", 2); hold on
f = Test1(datenum(p2.c_dday), 1, 0.1, 0.5);
c_dday = NaN(size(p2.c_dday));
ipt = NaN(size(p2.Vel));
ig = find(f == 1);
c_dday(ig) = datenum(p2.c_dday(ig));
ipt(ig) = p2.Vel(ig);
plot(datenum(p2.c_dday), p2.Vel*100, 'r', "DisplayName", "Port 2_{raw}", "LineWidth", 2); hold on
plot(c_dday, ipt*100, 'k', "DisplayName", "Port 2_{QC}", "LineWidth", 2)
grid on
legend
xlim([floor(datenum(p2.c_dday(1))) ceil(datenum(p2.c_dday(end)))])
ylabel('Speed (cm s^{-1})')
title(ax, "Current Port 2")
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)


ax = nexttile;
% quiver_f(datenum(p1.c_dday), p1.u*100, p1.v*100, "Color", "k"); hold on
ipt_u = [];
ipt_v = [];
ipt_u(ig, 1) = p2.u(ig);
ipt_v(ig, 1) = p2.v(ig);
quiver_f(datenum(p2.c_dday), p2.u*100, p2.v*100, "Color", "r"); hold on
quiver_f(c_dday, ipt_u*100, ipt_v*100, "Color", "k"); hold on
grid on
legend("Port 2_{raw}", "Port 2_{QC}")
ylim([-120 120])
xlim([floor(datenum(p2.c_dday(1))) ceil(datenum(p2.c_dday(end)))])
ylabel('Speed (cm s^{-1})')
% title(ax, "Current")
figset_linefont(ax)
figset_date(ax, wave_day)
figset_date_minorticks(ax, wave_day)

saving_str = fullfile(pic_c, sprintf("%s_%s_Cur_plot.png", saving_time, station));
exportgraphics(gcf, saving_str)

%% Ellipse
figure
cc = complex(p1.u, p1.v);
Tidecon = t_tide(cc, 1);
K1 = find(strcmp(Tidecon.name, "K1"));
M2 = find(strcmp(Tidecon.name, "M2"));
O1 = find(strcmp(Tidecon.name, "O1"));
S2 = find(strcmp(Tidecon.name, "S2"));

ellipse(Tidecon.tidecon(K1, 1), Tidecon.tidecon(K1, 3), Tidecon.tidecon(K1, 5), 1, 0); hold on
ellipse(Tidecon.tidecon(O1, 1), Tidecon.tidecon(O1, 3), Tidecon.tidecon(O1, 5), 2, 0); hold on
ellipse(Tidecon.tidecon(M2, 1), Tidecon.tidecon(M2, 3), Tidecon.tidecon(M2, 5), 3, 0); hold on
ellipse(Tidecon.tidecon(S2, 1), Tidecon.tidecon(S2, 3), Tidecon.tidecon(S2, 5), 4, 0); hold on


cc = complex(p2.u, p2.v);
Tidecon = t_tide(cc, 1);
K1 = find(strcmp(Tidecon.name, "K1"));
M2 = find(strcmp(Tidecon.name, "M2"));
O1 = find(strcmp(Tidecon.name, "O1"));
S2 = find(strcmp(Tidecon.name, "S2"));

ellipse(Tidecon.tidecon(K1, 1), Tidecon.tidecon(K1, 3), Tidecon.tidecon(K1, 5), 1, 0, "b"); hold on
ellipse(Tidecon.tidecon(O1, 1), Tidecon.tidecon(O1, 3), Tidecon.tidecon(O1, 5), 2, 0, "b"); hold on
ellipse(Tidecon.tidecon(M2, 1), Tidecon.tidecon(M2, 3), Tidecon.tidecon(M2, 5), 3, 0, "b"); hold on
ellipse(Tidecon.tidecon(S2, 1), Tidecon.tidecon(S2, 3), Tidecon.tidecon(S2, 5), 4, 0, "b"); hold on

ylabel("Amplitude (m)")
legend("Port 1", "", "", "", "Port 2", "", "", "")

xlim([0 5])
grid on
set(gca, 'Xtick', 1:4, 'XTickLabel', {"K1", "O1", "M2", "S2"}, 'FontSize', 18, 'linewidth', 2)

saving_str = fullfile(pic_c, sprintf("%s_%s_Tide_Ellipse.png", saving_time, station));
exportgraphics(gcf, saving_str)


%% Spectrum
fs = 24;
window = 512;
noverlap = window/2;
nfft = 1024;
alpha = 0.95;
% [psd1, ff1] = pwelch(detrend(p1.Vel), window, noverlap, nfft, 24);
% [psd2, ff2] = pwelch(detrend(p2.Vel), window, noverlap, nfft, 24);
[psd1, ff1, psd1c] = pwelch(detrend(p1.Vel), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
[psd2, ff2, psd2c] = pwelch(detrend(p2.Vel), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);


figure("OuterPosition", [1 1 800 600])
ax = nexttile;
h = fill([ff1(2:end); flipud(ff1(2:end))], [psd1c(2:end, 1); flipud(psd1c(2:end, 2))], 'k', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
set(h, 'FaceAlpha', 0.3)
set(ax, 'Xscale', 'log', 'Yscale', 'log')
h = fill([ff2(2:end); flipud(ff2(2:end))], [psd2c(2:end, 1); flipud(psd2c(2:end, 2))], 'b', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
set(h, 'FaceAlpha', 0.3)
loglog(ff1, psd1, 'Color', 'k', 'DisplayName', 'Port 1', 'linewidth', 2); hold on
loglog(ff2, psd2, 'Color', 'b', 'DisplayName', 'Port 2', 'linewidth', 2); hold on
xline(1.93, 'Color', 'r', 'LineStyle', '--', 'Label', 'M2', 'HandleVisibility', 'off'); % M2 潮汐 (~1.93 cpd)
xline(24/23.93447, 'Color', 'r', 'LineStyle', '--', 'Label', 'K1', 'HandleVisibility', 'off'); % K1 潮汐
legend
figset_linefont(ax)
title_str = sprintf("%s", plot_time);
title(ax, title_str)
ylabel('PSD')
xlabel('Frequency (cpd)')
xlim([1e-1 1e1])
saving_str = fullfile(pic_c, sprintf("%s_%s_Tide_Spectrum.png", saving_time, station));
exportgraphics(gcf, saving_str)


%% PVD
PVD_x = cumsum(p1.u);
PVD_y = cumsum(p1.v);

total_distance = cumsum(p1.Vel);


figure
tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(PVD_x, PVD_y, 'k', 'LineWidth', 2); hold on
txt_str = sprintf("Displacement distance: %.2f m\nTotal distance: %.2f m\nDisplacement velocity: %.2f m/day\nTotal velocity: %.2f m/day", ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2), ...
    total_distance(end), ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2)/length(period_Krathon), ...
    total_distance(end)/length(period_Krathon));
scatter(PVD_x(1), PVD_y(1), 100, 'red', 'filled', '^'); hold on
text(PVD_x(1), PVD_y(1), "  start", "FontSize", 12, "Color", "r"); hold on
scatter(PVD_x(end), PVD_y(end), 300, 'red', 'filled', 'square');
text(PVD_x(end), PVD_y(end)+10, "end", "FontSize", 12, "Color", "r", "HorizontalAlignment", "Center"); hold on

text(0.005, .85, txt_str, "Units", "Normal", "Fontsize", 12)
xlim([floor(min(PVD_x)/2)*2 ceil(max(PVD_x)/2)*2])
ylim([floor(min(PVD_y)/2)*2 ceil(max(PVD_y)/2)*2+20])
ylabel("Distance (m)")
xlabel("Distance (m)")
title_str = sprintf("\\bfKSH Port 1 PVD\n\\rm%s", plot_time);
title(ax, title_str)
figset_linefont(ax)
grid on

saving_str = fullfile(pic_c, sprintf("%s_%s_P1_PVD.png", saving_time, station));
exportgraphics(gcf, saving_str)



PVD_x = cumsum(p2.u);
PVD_y = cumsum(p2.v);
total_distance = cumsum(p2.Vel);

figure
tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(PVD_x, PVD_y, 'k', 'LineWidth', 2); hold on
txt_str = sprintf("Displacement distance: %.2f m\nTotal distance: %.2f m\nDisplacement velocity: %.2f m/day\nTotal velocity: %.2f m/day", ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2), ...
    total_distance(end), ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2)/length(period_Krathon), ...
    total_distance(end)/length(period_Krathon));
scatter(PVD_x(1), PVD_y(1), 100, 'red', 'filled', '^'); hold on
text(PVD_x(1), PVD_y(1), "  start", "FontSize", 12, "Color", "r"); hold on
scatter(PVD_x(end), PVD_y(end), 300, 'red', 'filled', 'square');
text(PVD_x(end), PVD_y(end)+10, "end", "FontSize", 12, "Color", "r", "HorizontalAlignment", "Center"); hold on

text(0.005, .85, txt_str, "Units", "Normal", "Fontsize", 12)
xlim([floor(min(PVD_x)/2)*2 ceil(max(PVD_x)/2)*2])
ylim([floor(min(PVD_y)/2)*2 ceil(max(PVD_y)/2)*2+20])
ylabel("Distance (m)")
xlabel("Distance (m)")
title_str = sprintf("\\bfKSH Port 2 PVD\n\\rm%s", plot_time);
title(ax, title_str)
figset_linefont(ax)
grid on

saving_str = fullfile(pic_c, sprintf("%s_%s_P2_PVD.png", saving_time, station));
exportgraphics(gcf, saving_str)
