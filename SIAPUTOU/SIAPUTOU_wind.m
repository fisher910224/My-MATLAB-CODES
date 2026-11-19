%% Siaputou Wind
% 20260825 edited
clear; close all; clc;

%% Path
% main_folder = 'C:\Users\adm\Desktop\Siaputou';
% dd = dir(fullfile(main_folder, '天氣資料\*_hourly.txt'));
% SPT_wind = struct();
% for ii = 1:length(dd)
%     df = readmatrix(fullfile(dd(ii).folder, dd(ii).name));
%     ig = find(~isnan(df(:, 2)));
%     rawTimeStr = string(df(ig, 2));
%     is24Hour = extractBetween(rawTimeStr, 9, 10) == "24";
%     tempTimeStr = rawTimeStr;
%     tempTimeStr(is24Hour) = replaceBetween(tempTimeStr(is24Hour), 9, 10, "00");
%     SPT_wind.((dd_name)).winddday = datetime(tempTimeStr, 'InputFormat', 'yyyyMMddHH');
%     SPT_wind.((dd_name)).winddday(is24Hour) = SPT_wind.((dd_name)).winddday(is24Hour) + days(1);
%     SPT_wind.((dd_name)).wi = df(ig, 3);
%     SPT_wind.((dd_name)).wDir = df(ig, 4);
%     SPT_wind.((dd_name)).rainfall = df(ig, 5);
%     SPT_wind.((dd_name)).wu = -SPT_wind.((dd_name)).wi.*sind(SPT_wind.((dd_name)).wDir);
%     SPT_wind.((dd_name)).wv = -SPT_wind.((dd_name)).wi.*cosd(SPT_wind.((dd_name)).wDir);
% end
% 
% save C:\Users\adm\Desktop\Siaputou\SPT_wind.mat SPT_wind dd

main_folder = 'C:\Users\adm\Desktop\Siaputou';
dd = dir(fullfile(main_folder, '天氣資料\*_hourly_0806.txt'));
SPT_wind = struct();
for ii = 1:length(dd)
    df = readmatrix(fullfile(dd(ii).folder, dd(ii).name));
    ig = find(~isnan(df(:, 2)));
    rawTimeStr = string(df(ig, 2));
    is24Hour = extractBetween(rawTimeStr, 9, 10) == "24";
    tempTimeStr = rawTimeStr;
    tempTimeStr(is24Hour) = replaceBetween(tempTimeStr(is24Hour), 9, 10, "00");
    dd_name = dd(ii).name(1:end-16);
    SPT_wind.((dd_name)).winddday = datetime(tempTimeStr, 'InputFormat', 'yyyyMMddHH');
    SPT_wind.((dd_name)).winddday(is24Hour) = SPT_wind.((dd_name)).winddday(is24Hour) + days(1);
    SPT_wind.((dd_name)).wi = df(ig, 3);
    SPT_wind.((dd_name)).wDir = df(ig, 4);
    SPT_wind.((dd_name)).rainfall = df(ig, 5);
    SPT_wind.((dd_name)).wu = -SPT_wind.((dd_name)).wi.*sind(SPT_wind.((dd_name)).wDir);
    SPT_wind.((dd_name)).wv = -SPT_wind.((dd_name)).wi.*cosd(SPT_wind.((dd_name)).wDir);
end

save C:\Users\adm\Desktop\Siaputou\SPT_wind.mat SPT_wind dd


%% Path
% main_folder = 'C:\Users\adm\Desktop\Siaputou';
% dd = dir(fullfile(main_folder, '天氣資料\*_daily.txt'));
% SPT_wind_daily = struct();
% for ii = 1:length(dd)
%     df = readmatrix(fullfile(dd(ii).folder, dd(ii).name));
%     ig = find(~isnan(df(:, 2)));
%     SPT_wind_daily.([dd(ii).name(1:end-10)]).winddday = datetime(string(df(ig, 2)), 'InputFormat', 'yyyyMMdd');
%     % SPT_wind_daily.([dd(ii).name(1:end-4)]).winddday(is24Hour) = SPT_wind_daily.([dd(ii).name(1:end-4)]).winddday(is24Hour) + days(1);
%     SPT_wind_daily.([dd(ii).name(1:end-10)]).wi = df(ig, 3);
%     SPT_wind_daily.([dd(ii).name(1:end-10)]).wDir = df(ig, 4);
%     SPT_wind_daily.([dd(ii).name(1:end-10)]).rainfall = df(ig, 5);
%     SPT_wind_daily.([dd(ii).name(1:end-10)]).wu = -SPT_wind_daily.([dd(ii).name(1:end-10)]).wi.*sind(SPT_wind_daily.([dd(ii).name(1:end-10)]).wDir);
%     SPT_wind_daily.([dd(ii).name(1:end-10)]).wv = -SPT_wind_daily.([dd(ii).name(1:end-10)]).wi.*cosd(SPT_wind_daily.([dd(ii).name(1:end-10)]).wDir);
% end
% 
% save C:\Users\adm\Desktop\Siaputou\SPT_wind_daily.mat SPT_wind_daily


main_folder = 'C:\Users\adm\Desktop\Siaputou';
dd = dir(fullfile(main_folder, '天氣資料\*_daily_0806.txt'));
SPT_wind_daily = struct();
for ii = 1:length(dd)
    df = readmatrix(fullfile(dd(ii).folder, dd(ii).name));
    ig = find(~isnan(df(:, 2)));
    SPT_wind_daily.([dd(ii).name(1:end-15)]).winddday = datetime(string(df(ig, 2)), 'InputFormat', 'yyyyMMdd');
    % SPT_wind_daily.([dd(ii).name(1:end-4)]).winddday(is24Hour) = SPT_wind_daily.([dd(ii).name(1:end-4)]).winddday(is24Hour) + days(1);
    SPT_wind_daily.([dd(ii).name(1:end-15)]).wi = df(ig, 3);
    SPT_wind_daily.([dd(ii).name(1:end-15)]).wDir = df(ig, 4);
    SPT_wind_daily.([dd(ii).name(1:end-15)]).rainfall = df(ig, 5);
    SPT_wind_daily.([dd(ii).name(1:end-15)]).wu = -SPT_wind_daily.([dd(ii).name(1:end-15)]).wi.*sind(SPT_wind_daily.([dd(ii).name(1:end-15)]).wDir);
    SPT_wind_daily.([dd(ii).name(1:end-15)]).wv = -SPT_wind_daily.([dd(ii).name(1:end-15)]).wi.*cosd(SPT_wind_daily.([dd(ii).name(1:end-15)]).wDir);
end

save C:\Users\adm\Desktop\Siaputou\SPT_wind_daily.mat SPT_wind_daily

%% load data
load("C:\Users\adm\Desktop\Siaputou\SPT_wind.mat")

for ii = 1:length(dd)
    file_name = sprintf('C:\\Users\\adm\\Desktop\\Siaputou\\processed_data\\%s_wind_stastics_8-17.txt', dd(ii).name(1:end-4));
    fid = fopen(file_name, 'w');
    fprintf(fid, '每日上午8點至下午17點(08:00~17:00)平均之風速風向、降雨量\n')
    fprintf(fid, '年年年年月月日日, 風速(m/s), 風向(degree), 降雨量(mm)\n');
    dd_name = dd(ii).name(1:end-16);
    for jj = 1:24:length(SPT_wind.((dd_name)).winddday)-23
        fprintf(fid, '%8s, %11.1f, %12.0f, %12.1f\n', ...
            datestr(SPT_wind.((dd_name)).winddday(jj), 'yyyymmdd'), ...
            mean(SPT_wind.((dd_name)).wi(jj+7:jj+16)), ...
            mean(SPT_wind.((dd_name)).wDir(jj+7:jj+16)), ...
            sum(SPT_wind.((dd_name)).rainfall(jj+7:jj+16)));
    end
    fclose(fid);
end


load("C:\Users\adm\Desktop\Siaputou\SPT_wind_daily.mat")

for ii = 1:length(dd)
    file_name = sprintf('C:\\Users\\adm\\Desktop\\Siaputou\\processed_data\\%s_wind_stastics.txt', dd(ii).name(1:end-4));
    fid = fopen(file_name, 'w');
    fprintf(fid, 'yyyymmdd, WSpeed(m/s), WDir(degree), Rainfall(mm)\n');
    dd_name = dd(ii).name(1:end-16);
    for jj = 1:length(SPT_wind_daily.((dd_name)).winddday)
        fprintf(fid, '%8s, %11.1f, %12.0f, %12.1f\n', ...
            datestr(SPT_wind_daily.((dd_name)).winddday(jj), 'yyyymmdd'), ...
            SPT_wind_daily.((dd_name)).wi(jj), ...
            SPT_wind_daily.((dd_name)).wDir(jj), ...
            SPT_wind_daily.((dd_name)).rainfall(jj));
    end
    fclose(fid);
end

%% plot
figset_linefont = @(ax) set(ax, 'fontsize', 15, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day

station_str = {"東港", "枋寮", "佳冬", "塭仔", "下寮"};
load("C:\Users\adm\Desktop\Siaputou\SPT_wind.mat");

figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(5, 1, "TileSpacing", "compact", "Padding", "tight");
for ii = 1:length(station_str)
    ax = nexttile;
    yyaxis left
    quiver_f(datenum(SPT_wind.((dd_name)).winddday), SPT_wind.((dd_name)).wu, SPT_wind.((dd_name)).wv); hold on
    ylim([-10 10])
    set(ax, 'ytick', -10:5:10, 'ycolor', 'k')
    ylabel('風速 (m s^{-1})')

    yyaxis right
    bar(datenum(SPT_wind.((dd_name)).winddday), SPT_wind.((dd_name)).rainfall, 0.75, 'stacked', 'blue')
    ylim([0 100])
    set(ax, 'ytick', 0:20:100, 'ycolor', 'b')
    grid on
    xlim([floor(datenum(SPT_wind.((dd_name)).winddday(1))) ceil(datenum(SPT_wind.((dd_name)).winddday(end)))])
    ylabel('降雨量 (mm)')

    figset_linefont(ax)
    figset_date(ax, datenum(SPT_wind.((dd_name)).winddday))
    figset_date_minorticks(ax, datenum(SPT_wind.((dd_name)).winddday))
    title(ax, station_str{ii}, 'FontSize', 18, 'FontWeight', 'bold')
end

exportgraphics(gcf, 'C:\Users\adm\Desktop\Siaputou\processed_data\daily_windspeed_rainfall.png')




% figure("OuterPosition", [1 1 1920/2 1080])
% tt = tiledlayout(5, 1, "TileSpacing", "compact", "Padding", "tight");
% for ii = 1:length(station_str)
%     ax = nexttile;
%     WS_8_17 = [];
%     for jj = 1:length(SPT_wind.((dd_name)).wi)/24
%         ig = (jj-1)*24+8:(jj-1)*24+17;
%         WS_8_17(jj, 1) = mean(SPT_wind.((dd_name)).wi(ig), 'omitmissing');
%     end
%     plot(SPT_wind_daily.((dd_name)).winddday, SPT_wind_daily.((dd_name)).wi, 'Color', 'r', 'DisplayName', '日平均'); hold on
%     plot(SPT_wind_daily.((dd_name)).winddday, WS_8_17, 'Color', 'b', 'DisplayName', '8~17點平均'); hold on
% 
%     figset_linefont(ax)
%     % figset_date(ax, datenum(SPT_wind_daily.((dd_name)).winddday))
%     % figset_date_minorticks(ax, datenum(SPT_wind_daily.((dd_name)).winddday))
%     title(ax, station_str{ii}, 'FontSize', 18, 'FontWeight', 'bold')
%     legend('Box', 'off', 'NumColumns', 2)
%     ylabel('風速(m s^{-1})')
%     ylim([0 10])
% end
% 
% exportgraphics(gcf, 'C:\Users\adm\Desktop\Siaputou\processed_data\daily_windspeed_compare.png')
