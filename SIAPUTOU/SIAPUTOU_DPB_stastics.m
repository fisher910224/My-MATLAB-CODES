%% PROCESSED DATA
clear; close all; clc;

%% PATH
main_folder = 'C:\Users\adm\Desktop\Siaputou';
station = 'DapengBay';
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
load("C:\Users\adm\Desktop\浮標資料原始資料\DapengBay\DPB.mat")

%% Figure setting
figset_linefont = @(ax) set(ax, 'fontsize', 12, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day


%% DPB Stastics
% ============================= Temperature ===============================
max_values = [];
mean_values = [];
min_values = [];
for ii = 1:length(DPB.temp)
    for month_number = 1:12
        try
            ig = find(DPB.temp(ii).ddatetime.Month == month_number);
            max_values(ii, month_number) = max(DPB.temp(ii).temp(ig));
            mean_values(ii, month_number) = mean(DPB.temp(ii).temp(ig));
            min_values(ii, month_number) = min(DPB.temp(ii).temp(ig));
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

file_name = sprintf("%s\\%s_temp_stastics.txt", p_data, station);
fid = fopen(file_name, "w");
fprintf(fid, "最大,  %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f\n", max_max_values);
fprintf(fid, "平均,  %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f\n", mean_mean_values);
fprintf(fid, "最小,  %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f, %5.1f\n", min_min_values);
fclose(fid);


% ================================= Wind ==================================
all_Beaufort_scale = [];
all_WSm = [];
all_Dirm = [];
all_WSmax = [];
all_dday_datetime = [];
for ii = 1:length(DPB.wind)
    all_Beaufort_scale = [all_Beaufort_scale; DPB.wind(ii).Beaufort_scale];
    all_WSm = [all_WSm; DPB.wind(ii).WSm];
    all_Dirm = [all_Dirm; DPB.wind(ii).Dirm];
    all_WSmax = [all_WSmax; DPB.wind(ii).WSmax];
    all_dday_datetime = [all_dday_datetime; DPB.wind(ii).ddatetime];
end
file_name = sprintf("%s\\%s_BS_dir_stastics.txt", p_data, station);
Wind_Beaufort_scale_stastics(all_Beaufort_scale, all_Dirm, file_name);

months_max = struct();
max_values = [];
max_idx = [];
for month_number = 1:12
    ig = find(all_dday_datetime.Month == month_number);
    dday_idx = all_dday_datetime(ig);
    ang = all_Dirm(ig);
    [max_values, max_idx] = max(all_WSm(ig));
    months_max(month_number).month = datestr(dday_idx(1), 'mmm');
    months_max(month_number).dday = datestr(dday_idx(max_idx), 'yyyy/mm/dd HH:MM');
    months_max(month_number).WSmax = max_values;
    months_max(month_number).Dirmax = ang(max_idx);
    months_max(month_number).WSm = mean(all_WSm(ig));
    months_max(month_number).Dirmain = find_main_direction(ang);
end

ig = find(all_dday_datetime.Month >= 4 & all_dday_datetime.Month <= 9);
dday_idx = all_dday_datetime(ig);
ang = all_Dirm(ig);
[max_values, max_idx] = max(all_WSm(ig));
months_max(13).month = 'summer';
months_max(13).dday = datestr(dday_idx(max_idx), 'yyyy/mm/dd HH:MM');
months_max(13).WSmax = max_values;
months_max(13).Dirmax = ang(max_idx);
months_max(13).WSm = mean(all_WSm(ig));
months_max(13).Dirmain = find_main_direction(ang);


ig = find(all_dday_datetime.Month >= 10 | all_dday_datetime.Month <= 3);
dday_idx = all_dday_datetime(ig);
ang = all_Dirm(ig);
[max_values, max_idx] = max(all_WSm(ig));
months_max(14).month = 'winter';
months_max(14).dday = datestr(dday_idx(max_idx), 'yyyy/mm/dd HH:MM');
months_max(14).WSmax = max_values;
months_max(14).Dirmax = ang(max_idx);
months_max(14).WSm = mean(all_WSm(ig));
months_max(14).Dirmain = find_main_direction(ang);

[max_values, max_idx] = max(all_WSm);
months_max(15).month = 'All';
months_max(15).dday = datestr(all_dday_datetime(max_idx), 'yyyy/mm/dd HH:MM');
months_max(15).WSmax = max_values;
months_max(15).Dirmax = all_Dirm(max_idx);
months_max(15).WSm = mean(all_WSm(ig));
months_max(15).Dirmain = find_main_direction(all_Dirm);

file_name = sprintf("%s\\%s_wind_monthly_stastics.txt", p_data, station);
fid = fopen(file_name, "w");
for ii = 1:length(months_max)
    fprintf(fid, '%+6s, %+s, %5.1f, %5.0f, %5.1f, %+3s\n', months_max(ii).month, months_max(ii).dday, months_max(ii).WSmax, months_max(ii).Dirmax, months_max(ii).WSm, months_max(ii).Dirmain);
end
fclose(fid);


%% Seasonal prob. cont
file_name = sprintf("%s\\%s_BS_dir_stastics.txt", p_data, station);
prob_table = readtable(file_name, "Delimiter", ",", "ReadVariableNames", false);

pp = table2array(prob_table(1:18, 2:17));
% prob_cont = flipud(pp);
load('directions_str.mat')

% figure("OuterPosition", [1 1 1920 1080])
figure
% tt = tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
% ax = nexttile;
ax = gca;
contourf(1:16, 1:18, pp, 0:0.05:7, 'LineStyle', 'none')
ylabel('wind speed(Bearfort scale)')
xlabel('wind direction')
cc = colorbar;
cc.Label.String = 'probability(%)';
cc.Label.FontSize = 12;
set(ax, 'YTick', 1:18, 'YTicklabels', [num2str((1:17)'); ">17"], ...
    'Xtick', 1:16, 'XTickLabels', directions_str)
shading interp

saving_str = sprintf("%s\\%s_BFT_DIR_stastics_contourf_orig.png", pic_wind, station);
exportgraphics(gcf, saving_str)


load('purorg.mat')
figure
% tt = tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
% ax = nexttile;
ax = gca;
contourf(1:16, 1:18, pp, 0:0.05:7, 'LineStyle', 'none')
ylabel('wind speed(Bearfort scale)')
xlabel('wind direction')
% colormap(purorg)
colormap(jet)
cc = colorbar;
cc.Label.String = 'probability(%)';
cc.Label.FontSize = 12;
set(ax, 'YTick', 1:18, 'YTicklabels', [num2str((1:17)'); ">17"], ...
    'Xtick', 1:16, 'XTickLabels', directions_str)
shading interp

saving_str = sprintf("%s\\%s_BFT_DIR_stastics_contourf.png", pic_wind, station);
exportgraphics(gcf, saving_str)

%% Seasonal prob. plot
[~, all_p] = find_main_direction(all_Dirm);
all_prob = all_p./sum(all_p)*100;
seasonal_prob = [];
sp = [];
month_number = [3, 6, 9, 12];
for ii = 1:4
    if ii == 4
        ig = find(all_dday_datetime.Month >= month_number(ii) | all_dday_datetime.Month < 3);
    else
        ig = find(all_dday_datetime.Month >= month_number(ii) & all_dday_datetime.Month < month_number(ii)+1);
    end
    ddir = all_Dirm(ig);
    ddir(ddir >= 348.75) = ddir(ddir >= 348.75) - 360;
    [~, sp] = find_main_direction(ddir);
    seasonal_prob(ii, :) = sp./sum(sp)*100;
end

markers = {"square", "o", "^", "v"};
seasons_str = {"Spring", "Summer", "Autumn", "Winter"};

figure
tiledlayout(2, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(1:16, all_prob, 'LineStyle', '-', 'Marker', '*', 'Color', 'k', 'DisplayName', 'All'); hold on
for ii = 1:4
    plot(1:16, seasonal_prob(ii, :), 'LineStyle', '--', 'Marker', markers{ii}, 'Color', 'k', 'DisplayName', seasons{ii})
end
set(ax, 'xtick', 1:16, 'xticklabels', directions_str)
xlim([1 16])
legend
xlabel('wind direction')
ylabel('(%)')


bf = [];
% [~, all_p] = find_main_direction(all_Dirm);
for jj = 0:17
    if jj == 17
        ig = all_Beaufort_scale > 17;
    else
        ig = all_Beaufort_scale >= jj & all_Beaufort_scale < jj+1;
    end
    all_p(jj+1) = sum(ig);
end
all_prob = all_p./sum(all_p)*100;
seasonal_prob = [];
sp = [];
month_number = [3, 6, 9, 12];
for ii = 1:4
    if ii == 4
        ig = find(all_dday_datetime.Month >= month_number(ii) | all_dday_datetime.Month < 3);
    else
        ig = find(all_dday_datetime.Month >= month_number(ii) & all_dday_datetime.Month < month_number(ii)+1);
    end
    bf = all_Beaufort_scale(ig);
    % [~, sp] = find_main_direction(all_Dirm(ig));
    for jj = 0:17
        if jj == 17
            ig = bf > 17;
        else
            ig = bf >= jj & bf < jj+1;
        end
        sp(jj+1) = sum(ig);
    end

    seasonal_prob(ii, :) = sp./sum(sp)*100;
end


ax = nexttile;
plot(1:18, all_prob, 'LineStyle', '-', 'Marker', '*', 'Color', 'k', 'DisplayName', 'All'); hold on
for ii = 1:4
    plot(1:18, seasonal_prob(ii, :), 'LineStyle', '--', 'Marker', markers{ii}, 'Color', 'k', 'DisplayName', seasons{ii})
end
set(ax, 'xtick', 1:18, 'xticklabels', [num2str((1:17)'); ">17"])
xlim([1 18])
legend
xlabel('wind speed(Beaufort scale)')
ylabel('(%)')

saving_str = sprintf("%s\\%s_BFT_DIR_stastics_seasonal_plot.png", pic_wind, station);
exportgraphics(gcf, saving_str)

%% Rose
figure
title_str = sprintf("%s~%s", datestr(all_dday_datetime(1), 'yyyy/mm/dd'), datestr(all_dday_datetime(end), 'yyyy/mm/dd'));
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
Options.MaxFrequency    = 20;
Options.nfreq           = 4;
Options.FreqLabelAngle  = 270;
Options.zeroAndNegative = true;
Options.cMap            = 'jet';
Options.vWinds          = [0, 5, 10, 15, 20];
Options.LabLegend       = 'Wind speed (m/s)';
Options.LegendVariable  = 'V';
Options.scalefactor     = 0.9;
Options.TitleString     = title_str;
Options.axes            = ax;

Rose_dir = all_Dirm(~isnan(all_Dirm));
Rose_WS = all_WSm(~isnan(all_WSm));
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'northwestoutside', 'Box', 'off')
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

saving_str = sprintf("%s\\%s_WS_DIR_stastics_rose.png", pic_wind, station);
exportgraphics(gcf, saving_str)


figure
% title_str = sprintf("%s~%s", datestr(all_dday_datetime(1), 'yyyy/mm/dd'), datestr(all_dday_datetime(end), 'yyyy/mm/dd'));
title_str = sprintf("Winter");
ax = nexttile;

Options.TitleString     = title_str;
Options.axes            = ax;

ig = find(all_dday_datetime.Month >= 10 | all_dday_datetime.Month <= 3);
dday_idx = all_dday_datetime(ig);
Rose_dir = all_Dirm(ig);
Rose_WS = all_WSm(ig);
WindRose(Rose_dir, Rose_WS, Options);
figset_linefont(ax)
set(ax.Legend, 'Location', 'northwestoutside', 'Box', 'off')
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

saving_str = sprintf("%s\\%s_WS_DIR_stastics_winter_rose.png", pic_wind, station);
exportgraphics(gcf, saving_str)
