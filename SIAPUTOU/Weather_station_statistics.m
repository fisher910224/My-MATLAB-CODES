% function Statistics_wind_plots(ipt, ipt_dir, ipt_time, ipt_range, item, unit_str, station_name, saving_path)
filename1 = {"塭仔", "下寮", "佳冬"};
filename2 = {"Wenzai", "Sialiao", "Jiadong"};

for ii = 1:3
file_path = "C:\Users\adm\Desktop\Siaputou\processed_data\" + filename1(ii);
station_name = filename2{ii};
outputdatafolder_path = "C:\Users\adm\Desktop\Siaputou\processed_data\" + filename1(ii);


cd(file_path)
dd = dir("*alldata*.csv");
tt = readtable(fullfile(dd.folder, dd.name));
ipt = tt.WD01;
ipt_dir = tt.WD02;
ipt_time = datetime(string(tt.yyyymmddhh(1:end-1)), "Inputformat", "yyyyMMddHH");
idx = find(isnat(ipt_time));
ipt_time(idx) = ipt_time(idx-1) + hours(1);
ipt_range = [0, .2, 1.5, 3.3, 5.4, 7.9, 10.7, 13.8, 17.1, 20.7, 24.4, 28.4, 32.6, 36.9, 41.4, 46.1, 50.9, 56, 61.2];

ipt_dir(ipt_dir > 348.75) = ipt_dir(ipt_dir > 348.75) - 360;

unit_str = "m/s";

directions_str = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", ...
        "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];


ipt_interval_str = {};
for ii = 1:length(ipt_range)
    if ii == 1
        ipt_interval_str{ii} = sprintf("<%.1f %s", ipt_range(2), unit_str);
    elseif ii <= length(ipt_range)-1
        ipt_interval_str{ii} = sprintf("%.1f~%.1f %s", ipt_range(ii), ipt_range(ii+1), unit_str);
    else
        ipt_interval_str{ii} = sprintf(">%.1f %s", ipt_range(end), unit_str);
    end
end
% ================================== HsDir =============================== 
percent_table = struct();
filename = station_name + "_" + "wind" + "_Dir_statistics.csv";
fid = fopen(fullfile(outputdatafolder_path, filename), "w", "n", "UTF-8");
percentbot = Vanalyis_Hsdir(ipt, ipt_dir, ipt_range);
percent_table.HsDir = percentbot';
num_cols = size(percent_table.HsDir, 2);
val_format = [repmat(',%.1f', 1, num_cols), '\n'];
fprintf(fid, ',%s,Total(%%)\n', strjoin(directions_str, ','));
for ii = 1:length(ipt_interval_str)
    % if d.CancelRequested, userCancelled = true; break; end
    fprintf(fid, ['%s', val_format], ipt_interval_str{ii}, percent_table.HsDir(ii, :));
end
fprintf(fid, ['Total(%%)', val_format], percent_table.HsDir(end, :));
fclose(fid);


% ======================== Seasonal prob. contourf ========================
% percent_table = Wind_Beaufort_scale_statistics(all_Beaufort_scale, ipt_dir, fullfile(outputdatafolder_path, filename));
% percent_table = Vanalyis_Hsdir(ipt, ipt_dir, ipt_range);
percent_table = percent_table.HsDir;
pp = percent_table(1:end-1, 1:end-1);
% pp = [pp; zeros(1, width(pp))];


fig = figure("Visible", "off");
% fig = figure;
ax = nexttile;
contourf(1:16, 0:height(pp)-1, pp, 0:0.05:7, 'LineStyle', 'none')
ylabel('wind speed (Bearfort scale)')
xlabel('wind direction')
colormap(flipud(gray))
cc = colorbar;
cc.Label.String = 'probability(%)';
cc.Label.FontSize = 12;
set(ax, 'YTick', 0:18, 'YTicklabels', [num2str((0:17)'); ">17"], ...
    'Xtick', 1:16, 'XTickLabels', directions_str)
shading interp

saving_str = fullfile(outputdatafolder_path, sprintf("%s_BFT_DIR_statistics_contourf.png", station_name));
exportgraphics(fig, saving_str)
close(fig)

% ========================= Seasonal prob. plot ===========================
[~, all_p] = find_main_direction(ipt_dir);
all_prob = all_p./sum(all_p)*100;
seasonal_prob = [];
% sp = [];
% month_number = [3, 6, 9, 12];
month_number = [4, 9];
for ii = 1:length(month_number)
    if ii == length(month_number)
        ig = find(ipt_time.Month >= month_number(ii) | ipt_time.Month < month_number(1));
    else
        ig = find(ipt_time.Month >= month_number(ii) & ipt_time.Month < month_number(ii)+1);
    end
    ddir = ipt_dir(ig);
    ddir(ddir >= 348.75) = ddir(ddir >= 348.75) - 360;
    [~, sp] = find_main_direction(ddir);
    seasonal_prob(ii, :) = sp./sum(sp)*100;
end

if length(month_number) == 4
    markers = {"square", "o", "^", "v"};
    seasons_str = {"Spring", "Summer", "Autumn", "Winter"};
elseif length(month_number) == 2
    markers = {"o", "v"};
    seasons_str = {"Summer", "Winter"};
end


fig = figure("Visible", "off");
% fig = figure;
tiledlayout(2, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
bar_color = [];
for ii = 1:length(month_number)+1
    bar_color(ii, :) = repmat(ii/(length(month_number)+1), 3, 1);
end
bar(1:16, [all_prob; seasonal_prob], 0.7, "grouped"); hold on
colororder(bar_color)
set(ax, 'xtick', 1:16, 'xticklabels', directions_str, 'ytick', 0:5:50)
xlim([0 17])
ylim([0 20])
legend(["All", seasons_str], "Location", "best", "NumColumns", 3)
xlabel('wind direction')
ylabel('(%)')

for jj = 0:length(ipt_range)-1
    if jj == length(ipt_range)-1
        ig = ipt > ipt_range(end);
    else
        ig = ipt >= ipt_range(jj+1) & ipt < ipt_range(jj+2);
    end
    all_p(jj+1) = sum(ig);
end

all_prob = all_p./sum(all_p)*100;
seasonal_prob = [];
sp = [];
% month_number = [3, 6, 9, 12];
for ii = 1:length(month_number)

    if ii == length(month_number)
        ig = find(ipt_time.Month >= month_number(ii) | ipt_time.Month < month_number(1));
    else
        ig = find(ipt_time.Month >= month_number(ii) & ipt_time.Month < month_number(ii)+1);
    end
    bf = ipt(ig);
    % [~, sp] = find_main_direction(ipt_dir(ig));
    for jj = 0:length(ipt_range)-1
        if jj == length(ipt_range)-1
            ig = bf > ipt_range(end);
        else
            ig = bf >= ipt_range(jj+1) & bf < ipt_range(jj+2);
        end
        sp(jj+1) = sum(ig);
    end

    seasonal_prob(ii, :) = sp./sum(sp)*100;
end


ax = nexttile;
% plot(1:18, all_prob, 'LineStyle', '-', 'Marker', '*', 'Color', 'k', 'DisplayName', 'All'); hold on
% for ii = 1:length(month_number)
%     plot(1:18, seasonal_prob(ii, :), 'LineStyle', '--', 'Marker', markers{ii}, 'Color', 'k', 'DisplayName', seasons_str{ii})
% end
bar(1:length(all_prob), [all_prob; seasonal_prob], 0.7, "grouped"); hold on
colororder(bar_color)
set(ax, 'xtick', 1:18, 'xticklabels', [num2str((1:17)'); ">17"], 'ytick', 0:10:100)
xlim([0 19])
ylim([0 ceil(max(max([all_prob; seasonal_prob]))/10)*10])
legend(["All", seasons_str], "Location", "best", "NumColumns", 3)
xlabel('wind speed(Beaufort scale)')
ylabel('(%)')


% file_ext = app.wind_statistics_colormap_format;
saving_str = fullfile(outputdatafolder_path, sprintf("%s_BFT_DIR_statistics_seasonal_plot.png", station_name));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)       
close(fig);


% ========================= WindRose ===========================
figset_linefont = @(ax) set(ax, 'fontsize', 12, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day
[~, dir_prob] = find_main_direction(ipt_dir);


fig = figure("Visible", "off");
% fig = figure;
title_str = sprintf("%s~%s", datestr(ipt_time(1), 'yyyy/mm/dd'), datestr(ipt_time(end), 'yyyy/mm/dd'));
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
Options.MaxFrequency    = [];
Options.nfreq           = 5;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = flipud(gray(64)); 
% gg = app.WindRose_all_MaxFrequency/app.WindRose_all_nfreq;
Options.vWinds          = 0:5:20;
Options.LabLegend       = 'Wind speed (m/s)';
Options.LegendVariable  = 'V';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;
Options.figcolor        = 'w';

valid_idx = ~isnan(ipt_dir) & ~isnan(ipt);
Rose_dir = ipt_dir(valid_idx);
Rose_WS = ipt(valid_idx);
% if isempty(app.WindRose_all_MaxFrequency)
    [~, Dir_stas] = find_main_direction(Rose_dir);
    Options.MaxFrequency    = ceil(max(Dir_stas)/numel(Rose_dir)*100/10)*10;
% end
% fprintf('原始資料筆數: %d, 過濾後剩餘筆數: %d %d\n', length(ipt_dir), length(Rose_dir), length(Rose_WS));
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeast', 'Box', 'off', 'fontsize', 8, 'ItemTokenSize', [12, 6])
lgd_pos = ax.Legend.Position;
lgd_pos(1) = lgd_pos(1) + 0.16; % 數值調大 = 往右移
lgd_pos(2) = lgd_pos(2) - 0.03; % 數值調小 = 往下移
ax.Legend.Position = lgd_pos;
set(ax, 'TitleHorizontalAlignment', 'left')
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
% file_ext = app.wind_statistics_colormap_format;
saving_str = fullfile(outputdatafolder_path, sprintf("%s_WS_DIR_statistics_rose.png", station_name));
% saving_str = sprintf("%s\\%s_BFT_DIR_statistics_seasonal_plot.png", pic_wind, station);
exportgraphics(fig, saving_str)       
close(fig);


% ========================= Winter WindRose ===========================

fig = figure("Visible", "off");
% title_str = sprintf("%s~%s", datestr(ipt_time(1), 'yyyy/mm/dd'), datestr(ipt_time(end), 'yyyy/mm/dd'));
title_str = sprintf("Winter");
ax = nexttile;

Options.TitleString     = title_str;
Options.axes            = ax;
% Options.MaxFrequency    = app.WindRose_mon_MaxFrequency;
% Options.nfreq           = app.WindRose_mon_nfreq;

ig = find(ipt_time.Month >= 10 | ipt_time.Month <= 3);
dday_idx = ipt_time(ig);
Rose_dir = ipt_dir(ig);
Rose_WS = ipt(ig);
% if isempty(app.WindRose_all_MaxFrequency)
    [~, Dir_stas] = find_main_direction(Rose_dir);
    Options.MaxFrequency    = ceil(max(Dir_stas)/numel(Rose_dir)*100/10)*10;
% end
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeast', 'Box', 'off', 'fontsize', 8, 'ItemTokenSize', [12, 6])
lgd_pos = ax.Legend.Position;
lgd_pos(1) = lgd_pos(1) + 0.16; % 數值調大 = 往右移
lgd_pos(2) = lgd_pos(2) - 0.03; % 數值調小 = 往下移
ax.Legend.Position = lgd_pos;
set(ax, 'TitleHorizontalAlignment', 'left')
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

% saving_str = sprintf("%s\\%s_WS_DIR_statistics_winter_rose.png", pic_wind, station);
% exportgraphics(gcf, saving_str)
% file_ext = app.wind_statistics_colormap_format;
saving_str = fullfile(outputdatafolder_path, sprintf("%s_WS_DIR_statistics_winter_rose.png", station_name));
exportgraphics(fig, saving_str)       
close(fig);


fig = figure("Visible", "off");
% title_str = sprintf("%s~%s", datestr(ipt_time(1), 'yyyy/mm/dd'), datestr(ipt_time(end), 'yyyy/mm/dd'));
title_str = sprintf("Summer");
ax = nexttile;

Options.TitleString     = title_str;
Options.axes            = ax;
% Options.MaxFrequency    = app.WindRose_mon_MaxFrequency;
% Options.nfreq           = app.WindRose_mon_nfreq;

ig = find(ipt_time.Month >= 4 & ipt_time.Month <= 9);
dday_idx = ipt_time(ig);
Rose_dir = ipt_dir(ig);
Rose_WS = ipt(ig);
% if isempty(app.WindRose_all_MaxFrequency)
    [~, Dir_stas] = find_main_direction(Rose_dir);
    Options.MaxFrequency    = ceil(max(Dir_stas)/numel(Rose_dir)*100/10)*10;
% end
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'southeast', 'Box', 'off', 'fontsize', 8, 'ItemTokenSize', [12, 6])
lgd_pos = ax.Legend.Position;
lgd_pos(1) = lgd_pos(1) + 0.16; % 數值調大 = 往右移
lgd_pos(2) = lgd_pos(2) - 0.03; % 數值調小 = 往下移
ax.Legend.Position = lgd_pos;
set(ax, 'TitleHorizontalAlignment', 'left')
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

% saving_str = sprintf("%s\\%s_WS_DIR_statistics_summer_rose.png", pic_wind, station);
% exportgraphics(gcf, saving_str)
% file_ext = app.wind_statistics_colormap_format;
saving_str = fullfile(outputdatafolder_path, sprintf("%s_WS_DIR_statistics_summer_rose.png", station_name));
exportgraphics(fig, saving_str)       
close(fig);

for jj = 1:12
    % if d.CancelRequested, userCancelled = true; break; end
    % d.Value = (jj + 6) / 18; 
    % d.Message = sprintf('Saving wind-rose figure ...(%d/15)', jj+3);
    fig = figure("Visible", "off");
    ig = find(ipt_time.Month == jj);
    % title_str = sprintf("%s~%s", datestr(ipt_time(1), 'yyyy/mm/dd'), datestr(ipt_time(end), 'yyyy/mm/dd'));
    title_str = sprintf("%s", datestr(ipt_time(ig(1)), 'mmm'));
    ax = nexttile;
    % clear Options.MaxFrequency
    % clear Options.nfreq 
    Options.TitleString     = title_str;
    Options.axes            = ax;
    
    % ig = find(ipt_time.Month == jj);
    dday_idx = ipt_time(ig);
    Rose_dir = ipt_dir(ig);
    Rose_WS = ipt(ig);

    % if jj == 1 || jj == 2 || jj == 12; gg = 30; 
    % elseif jj >=3 && jj <= 7; gg = 20;
    % elseif jj == 8; gg = 10;
    % else; gg = 20;
    % end
    % Options.MaxFrequency    = gg;
    % Options.nfreq           = 5;
    % Options.MaxFrequency    = app.WindRose_mon_MaxFrequency;
    % Options.nfreq           = app.WindRose_mon_nfreq;
    % if isempty(app.WindRose_all_MaxFrequency)
        [~, Dir_stas] = find_main_direction(Rose_dir);
        Options.MaxFrequency    = ceil(max(Dir_stas)/numel(Rose_dir)*100/10)*10;
    % end
    WindRose(Rose_dir, Rose_WS, Options);
    figset_linefont(ax)
    set(ax.Legend, 'Location', 'southeast', 'Box', 'off', 'fontsize', 8, 'ItemTokenSize', [12, 6])
    lgd_pos = ax.Legend.Position;
    lgd_pos(1) = lgd_pos(1) + 0.16; % 數值調大 = 往右移
    lgd_pos(2) = lgd_pos(2) - 0.03; % 數值調小 = 往下移
    ax.Legend.Position = lgd_pos;
    set(ax, 'TitleHorizontalAlignment', 'left')
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
    
    % saving_str = sprintf("%s\\%s_WS_DIR_statistics_%d_rose.png", pic_wind, station, jj);
    % exportgraphics(gcf, saving_str)
    % file_ext = app.wind_statistics_colormap_format;
    saving_str = fullfile(outputdatafolder_path, sprintf("%s_WS_DIR_statistics_%d_rose.png", station_name, jj));
    exportgraphics(fig, saving_str)       
    close(fig);
end
end