%% Plot KHS Port1 & 2
% 20260908
clear; close all; clc;

%% Path
main_folder = 'C:\Users\adm\Desktop\Kaohsiung';
station = 'Kaohsiung';
pic_c = [main_folder, '\picture\current'];
pic_w = [main_folder, '\picture\wave'];
pic_tph = [main_folder, '\picture\typhoon'];
pic_wind = [main_folder, '\picture\wind'];
p_data = [main_folder, '\processed_data'];
if ~isfolder(pic_c)
    mkdir(pic_c)
end
if ~isfolder(pic_w)
    mkdir(pic_w)
end
if ~isfolder(pic_tph)
    mkdir(pic_tph)
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
load("C:\Users\adm\Desktop\Kaohsiung\TidalStationData\ProcessedData_KSH_tide.mat");

% for year_time = 2018:2026
% for year_time = 2024
    close all;
    % for month_time = 1:12
    % for month_time = 9
    year_time = 2024;
    month_time = 9;
        close all;
        % try
            % period_Krathon = datetime(year_time, month_time, 1):datetime(year_time, month_time+1, 1)-days(1);
            period_Krathon = datetime(year_time, month_time, 15):datetime(year_time, month_time+1, 17)-days(1);
            saving_time = sprintf("%s_%s", datestr(period_Krathon(1), 'yyyymmdd'), datestr(period_Krathon(end), 'mmdd'));
            plot_time = sprintf("%s~%s", datestr(period_Krathon(1), 'yyyy/mm/dd'), datestr(period_Krathon(end), 'mm/dd'));
            
            %% Figure setting
            figset_linefont = @(ax) set(ax, 'fontsize', 15, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
            figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
                'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
            figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day

            %% find data in period
            ig = find(Wind.ddatetime >= period_Krathon(1) & Wind.ddatetime <= period_Krathon(end));
            W_time = Wind.ddatetime(ig);
            WSm = Wind.WSm(ig);
            WDm = Wind.WDm(ig);
            WSmax = Wind.WSmax(ig);
            WDmax = Wind.WDmax(ig);
            WSmax_time = Wind.WSmax_time(ig);
            WSu = -WSm.*sind(WDm);
            WSv = -WSm.*cosd(WDm);

            ig_dday = find(P1.W.ddatetime >= period_Krathon(1) & P1.W.ddatetime <= period_Krathon(end));
            Hs_raw = P1.W.H(ig_dday)/100;
            T_raw = P1.W.T(ig_dday);
            Tm_raw = P1.W.Tmean(ig_dday);
            Dir_raw = P1.W.Dir(ig_dday);
            [orig_dday, p1.Hs] = find_missing_data(P1.W.ddatetime(ig_dday), Hs_raw, hours(1));
            [~, p1.T] = find_missing_data(P1.W.ddatetime(ig_dday), T_raw, hours(1));
            [~, p1.Tmean] = find_missing_data(P1.W.ddatetime(ig_dday), Tm_raw, hours(1));
            [~, p1.Dir] = find_missing_data(P1.W.ddatetime(ig_dday), Dir_raw, hours(1));

            p1.T(p1.T < 0) = NaN;
            p1.Tmean(p1.Tmean < 0) = NaN;
            p1.dday = orig_dday';


            ig_dday = find(P2.W.ddatetime >= period_Krathon(1) & P2.W.ddatetime <= period_Krathon(end));
            Hs_raw = P2.W.H(ig_dday)/100;
            T_raw = P2.W.T(ig_dday);
            Tm_raw = P2.W.Tmean(ig_dday);
            Dir_raw = P2.W.Dir(ig_dday);
            [orig_dday, p2.Hs] = find_missing_data(P2.W.ddatetime(ig_dday), Hs_raw, hours(1));
            [~, p2.T] = find_missing_data(P2.W.ddatetime(ig_dday), T_raw, hours(1));
            [~, p2.Tmean] = find_missing_data(P2.W.ddatetime(ig_dday), Tm_raw, hours(1));
            [~, p2.Dir] = find_missing_data(P2.W.ddatetime(ig_dday), Dir_raw, hours(1));

            p2.T(p2.T < 0) = NaN;
            p2.Tmean(p2.Tmean < 0) = NaN;
            p2.dday = orig_dday';

            % ig = find(P2.W.ddatetime >= period_Krathon(1) & P2.W.ddatetime <= period_Krathon(end));
            % p2.Hs = P2.W.H(ig)/100;
            % p2.T = P2.W.T(ig);
            % p2.T(p2.T < 0) = NaN;
            % p2.Tmean = P2.W.Tmean(ig);
            % p2.Tmean(p2.Tmean < 0) = NaN;
            % p2.Dir = P2.W.Dir(ig);
            % p2.dday = P2.W.ddatetime(ig);

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

            for ii = 1:length(tide)
                dd = tide(ii).ddatetime(1);
                if dd.Year == year_time
                    % return;
                    break
                end
            end
            ig = find(tide(ii).dday >= datenum(period_Krathon(1)) & tide(ii).dday <= datenum(period_Krathon(end)));
            SL_dday = tide(ii).dday(ig);
            SL_raw = tide(ii).SL(ig);
            n_mean = 10;
            % SLm_dday = zeros(floor(length(SL_dday)/n_mean), 1);
            SLm = zeros(floor(length(SL_dday)/n_mean), 1);
            SLm_dday = SL_dday(1:n_mean:end-n_mean);
            for ii = 1:floor(length(SL_dday)/n_mean)
                intv = (ii-1)*n_mean+1 : ii*n_mean;
                % SLm_dday(ii, 1) = mean(SL_dday(intv), "omitmissing");
                SLm(ii, 1) = mean(SL_raw(intv), "omitmissing");
            end
            

            TPH_name = "Krathon";
            dd = dir(sprintf("C:\\Users\\adm\\Desktop\\Kaohsiung\\Typhoon_track\\*_%s.xlsx", TPH_name));
            TPH_track_data = readtable(fullfile(dd(1).folder, dd(1).name), "VariableNamingRule", "preserve");
            TPH.ddatetime = datetime(TPH_track_data.Year, TPH_track_data.Month, TPH_track_data.Day, TPH_track_data.Hour, 0, 0);
            TPH.lon = TPH_track_data.("Long.");
            TPH.lat = TPH_track_data.("Lat.");
            TPH.pres = TPH_track_data.("Pressure (hPa)");
            TPH.class = TPH_track_data.Class;
            coastline = load("C:\Users\adm\Desktop\INTERTIDAL\代婷與的PDF們\NMMBA\Coastline\World_coastline_i.dat");


            %% Filtering the tide
            dt = 1;
            fs = 1/dt;
            T_cutoff = 40; % filter tide under 40 hr
            f_cutoff = 1/T_cutoff;

            f_nyquist = fs/2;
            Wn = f_cutoff / f_nyquist; % normalized frequency

            order = 4; 
            [b, a] = butter(order, Wn, "low");

            p1.u_fillmissing = fillmissing(p1.u, "linear");
            p1.v_fillmissing = fillmissing(p1.v, "linear");
            p1.u_lowpass = filtfilt(b, a, p1.u_fillmissing);
            p1.v_lowpass = filtfilt(b, a, p1.v_fillmissing);

            p2.u_fillmissing = fillmissing(p2.u, "linear");
            p2.v_fillmissing = fillmissing(p2.v, "linear");
            p2.u_lowpass = filtfilt(b, a, p2.u_fillmissing);
            p2.v_lowpass = filtfilt(b, a, p2.v_fillmissing);

            SL_lowpass = filtfilt(b, a, SLm);

            [b, a] = butter(order, 1/8/f_nyquist, "low");
            u_8hr = filtfilt(b, a, p1.u_fillmissing);
            v_8hr = filtfilt(b, a, p1.v_fillmissing);
            p1.u_highpass = p1.u_fillmissing - u_8hr;
            p1.v_highpass = p1.v_fillmissing - v_8hr;

            u_8hr = filtfilt(b, a, p2.u_fillmissing);
            v_8hr = filtfilt(b, a, p2.v_fillmissing);
            p2.u_highpass = p2.u_fillmissing - u_8hr;
            p2.v_highpass = p2.v_fillmissing - v_8hr;

            n_cut = round(T_cutoff / dt);
            filter_data = (n_cut + 1) : (length(p1.c_dday) - n_cut);
            
            p1.location = [120.255113, 22.621059];
            p2.location = [120.283895, 22.543741];
            TPH.p1_distance = sqrt((TPH.lon - p1.location(1)).^2 + (TPH.lat - p1.location(2)).^2)*111;
            TPH.p2_distance = sqrt((TPH.lon - p2.location(1)).^2 + (TPH.lat - p2.location(2)).^2)*111;


%% 
            fig = figure("OuterPosition", [1 1 1000 800]);
            tt = tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
            ax = nexttile;
            plot(coastline(:, 1), coastline(:, 2), 'LineWidth', 1, 'Color', 'k', "HandleVisibility", "off"); hold on
            grid on
            filg = fillseg(coastline);
            set(filg, "HandleVisibility", "off", "edgecolor", "none")
            axis equal
            axis([118 129 18 25])

            ig = find(TPH.class <= 2);
            TropicalCyclone = NaN(length(TPH.lon), 2);
            TropicalCyclone(ig, 1) = TPH.lon(ig);
            TropicalCyclone(ig, 2) = TPH.lat(ig);

            ig = find(TPH.class <= 3);
            Mild = NaN(length(TPH.lon), 2);
            Mild(ig, 1) = TPH.lon(ig);
            Mild(ig, 2) = TPH.lat(ig);

            ig = find(TPH.class <= 4);
            Moderate = NaN(length(TPH.lon), 2);
            Moderate(ig, 1) = TPH.lon(ig);
            Moderate(ig, 2) = TPH.lat(ig);

            ig = find(TPH.class <= 5);
            Severe = NaN(length(TPH.lon), 2);
            Severe(ig, 1) = TPH.lon(ig);
            Severe(ig, 2) = TPH.lat(ig);

            plot(Severe(:, 1), Severe(:, 2), 'LineStyle', '-', 'Color', 'r', 'LineWidth', 2, 'Marker', 'o', 'MarkerFaceColor', 'r', "DisplayName", "Severe")
            plot(Moderate(:, 1), Moderate(:, 2), 'LineStyle', '-', 'Color', 'g', 'LineWidth', 2, 'Marker', 'o', 'MarkerFaceColor', 'g', "DisplayName", "Moderate")
            plot(Mild(:, 1), Mild(:, 2), 'LineStyle', '-', 'Color', 'b', 'LineWidth', 2, 'Marker', 'o', 'MarkerFaceColor', 'b', "DisplayName", "Mild")
            plot(TropicalCyclone(:, 1), TropicalCyclone(:, 2), 'LineStyle', '-', 'Color', 'm', 'LineWidth', 2, 'Marker', 'o', 'MarkerFaceColor', 'm', "DisplayName", "Tropical Cyclone")

            ig = find(TPH.ddatetime.Hour == 0);
            text(TPH.lon(ig)+.1, TPH.lat(ig), datestr(TPH.ddatetime(ig), 'mm/dd'), "FontSize", 18)

            set(ax, 'XTick', 118:2:130, 'YTick', 10:2:26)

            xtickformat('%d^{\\circ}E')
            ytickformat('%d^{\\circ}N')

            figset_linefont(ax)
            legend
            title(ax, 'Track of Krathon', 'FontSize', 24)
            saving_str = sprintf("%s\\%s_track.png", pic_tph, TPH_name);
            exportgraphics(fig, saving_str)


%% 
fig = figure("OuterPosition", [1 1 1000 1000]);
tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
plot(datenum(TPH.ddatetime), TPH.p1_distance, 'Color', 'k', 'LineWidth', 2, 'DisplayName', 'Distance of Typhoon to Port 1'); hold on
ylabel("Distance (km)")
set(ax, 'YColor', 'k')
yyaxis right
plot(datenum(TPH.ddatetime), TPH.pres, 'Color', 'r', 'LineWidth', 2, 'DisplayName', 'Pressure'); hold on
set(ax, 'YColor', 'r')
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylabel("Pressure (hPa)")
% xlabel("Date (mm/dd)")
grid on
legend
title_str = sprintf("\\bfInformation of Krathon & Port 1\n\\rm%s", plot_time);
title(ax, title_str)
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday))
figset_date_minorticks(ax, datenum(p1.c_dday))


ax = nexttile;
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
quiver_f(datenum(W_time), WSu, WSv)
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylim([-30 30])
ylabel("Speed (m s^{-1})")
% xlabel("Date (mm/dd)")
grid on
title_str = sprintf("\\bfWind");
title(ax, title_str)
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday))
figset_date_minorticks(ax, datenum(p1.c_dday))

ax = nexttile;
% xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
% quiver_f(datenum(p1.c_dday), p1.u_lowpass, p1.v_lowpass, 'Color', 'r'); hold on
plot(datenum(p1.c_dday(filter_data)), sqrt(p1.u_lowpass(filter_data).^2 + p1.v_lowpass(filter_data).^2), 'LineWidth', 1.2, 'Color', [.5 .5 .5]); hold on
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
quiver_f(datenum(p1.c_dday(filter_data)), p1.u_lowpass(filter_data), p1.v_lowpass(filter_data), 'Color', 'k')
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylim([-.6 .6])
ylabel("Speed (m s^{-1})")
% xlabel("Date (mm/dd)")
title_str = sprintf("\\bfFiltering tide for 40 hr low-pass current");
title(ax, title_str)
grid on
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday))
figset_date_minorticks(ax, datenum(p1.c_dday))


ax = nexttile;
% xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
% quiver_f(datenum(p1.c_dday), p1.u_lowpass, p1.v_lowpass, 'Color', 'r'); hold on
plot(datenum(p1.c_dday(filter_data)), sqrt(p1.u_highpass(filter_data).^2 + p1.v_highpass(filter_data).^2), 'LineWidth', 1.2, 'Color', [.5 .5 .5]); hold on
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
quiver_f(datenum(p1.c_dday(filter_data)), p1.u_highpass(filter_data), p1.v_highpass(filter_data), 'Color', 'k'); hold on
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylim([-.6 .6])
ylabel("Speed (m s^{-1})")
xlabel("Date (mm/dd)")
title_str = sprintf("\\bfFiltering tide for 8 hr high-pass current");
title(ax, title_str)
grid on

figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday))
figset_date_minorticks(ax, datenum(p1.c_dday))

saving_str = sprintf("%s\\%s_P1_Low_and_Highpass.png", pic_tph, TPH_name);
exportgraphics(fig, saving_str)


%% 
fig = figure("OuterPosition", [1 1 1000 1000]);
tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
plot(datenum(TPH.ddatetime), TPH.p2_distance, 'Color', 'k', 'LineWidth', 2, 'DisplayName', 'Distance of Typhoon to Port 2'); hold on
ylabel("Distance (km)")
set(ax, 'YColor', 'k')
yyaxis right
plot(datenum(TPH.ddatetime), TPH.pres, 'Color', 'r', 'LineWidth', 2, 'DisplayName', 'Pressure'); hold on
set(ax, 'YColor', 'r')
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylabel("Pressure (hPa)")
% xlabel("Date (mm/dd)")
grid on
legend
title_str = sprintf("\\bfInformation of Krathon & Port 2\n\\rm%s", plot_time);
title(ax, title_str)
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday))
figset_date_minorticks(ax, datenum(p2.c_dday))


ax = nexttile;
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
quiver_f(datenum(W_time), WSu, WSv)
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylim([-30 30])
ylabel("Speed (m s^{-1})")
% xlabel("Date (mm/dd)")
grid on
title_str = sprintf("\\bfWind");
title(ax, title_str)
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday))
figset_date_minorticks(ax, datenum(p2.c_dday))

ax = nexttile;
% xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
% quiver_f(datenum(p2.c_dday), p2.u_lowpass, p2.v_lowpass, 'Color', 'r'); hold on
plot(datenum(p2.c_dday(filter_data)), sqrt(p2.u_lowpass(filter_data).^2 + p2.v_lowpass(filter_data).^2), 'LineWidth', 1.2, 'Color', [.5 .5 .5]); hold on
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
quiver_f(datenum(p2.c_dday(filter_data)), p2.u_lowpass(filter_data), p2.v_lowpass(filter_data), 'Color', 'k')
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylim([-.6 .6])
ylabel("Speed (m s^{-1})")
% xlabel("Date (mm/dd)")
title_str = sprintf("\\bfFiltering tide for 40 hr low-pass current");
title(ax, title_str)
grid on
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday))
figset_date_minorticks(ax, datenum(p2.c_dday))


ax = nexttile;
% xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
% quiver_f(datenum(p2.c_dday), p2.u_lowpass, p2.v_lowpass, 'Color', 'r'); hold on
plot(datenum(p2.c_dday(filter_data)), sqrt(p2.u_highpass(filter_data).^2 + p2.v_highpass(filter_data).^2), 'LineWidth', 1.2, 'Color', [.5 .5 .5]); hold on
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
quiver_f(datenum(p2.c_dday(filter_data)), p2.u_highpass(filter_data), p2.v_highpass(filter_data), 'Color', 'k'); hold on
xlim([floor(datenum(period_Krathon(1))) ceil(datenum(period_Krathon(end)))])
ylim([-.6 .6])
ylabel("Speed (m s^{-1})")
xlabel("Date (mm/dd)")
title_str = sprintf("\\bfFiltering tide for 8 hr high-pass current");
title(ax, title_str)
grid on

figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday))
figset_date_minorticks(ax, datenum(p2.c_dday))

saving_str = sprintf("%s\\%s_P2_Low_and_Highpass.png", pic_tph, TPH_name);
exportgraphics(fig, saving_str)


%% 
% fs = 24;
% window = hann(256);
% noverlap = length(window)/2;
% nfft = 1024;
% alpha = 0.95;
% 
% % figure
% [u_psd1, u_ff1, u_psd1c] = pwelch(detrend(p1.u_highpass(filter_data)), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
% [v_psd1, v_ff1, v_psd1c] = pwelch(detrend(p1.v_highpass(filter_data)), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
% fig = figure("OuterPosition", [1 1 800 600]);
% ax = nexttile;
% h = fill([u_ff1(2:end); flipud(u_ff1(2:end))], [u_psd1c(2:end, 1); flipud(u_psd1c(2:end, 2))], 'b', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
% set(ax, 'Xscale', 'log', 'Yscale', 'log')
% set(h, 'FaceAlpha', 0.3)
% loglog(u_ff1, u_psd1, 'Color', 'b', 'DisplayName', 'Port 1 u', 'linewidth', 2); hold on
% 
% h = fill([v_ff1(2:end); flipud(v_ff1(2:end))], [v_psd1c(2:end, 1); flipud(v_psd1c(2:end, 2))], 'r', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
% set(ax, 'Xscale', 'log', 'Yscale', 'log')
% set(h, 'FaceAlpha', 0.3)
% loglog(v_ff1, v_psd1, 'Color', 'r', 'DisplayName', 'Port 1 v', 'linewidth', 2); hold on
% 
% xlim([1 10])
% xline(24/6.21, '--', 'M_4')
% xline(24/6, '--', 'S_4')
% xline(24/8.177, '--', 'MK_3')

%% 
figure("OuterPosition", [1 1 1920 1080])
yyaxis left
plot(datenum(W_time(filter_data)), WSm(filter_data)); hold on

yyaxis right
plot(datenum(p1.dday(filter_data)), sqrt(p1.u_highpass(filter_data).^2 + p1.v_highpass(filter_data).^2))



%% 
figure("OuterPosition", [1 1 1920/2 1080])
tiledlayout(3, 1, "TileSpacing", "compact", "Padding", "tight")
ax = nexttile;
scatter(normalize(WSm(filter_data), "norm"), normalize(sqrt(p1.u_highpass(filter_data).^2 + p1.v_highpass(filter_data).^2), "norm"))
axis square
axis([-.2 .2 -.2 .2])


ax = nexttile;
scatter(normalize(WSu(filter_data), "norm"), normalize(p1.u_highpass(filter_data), "norm"))
axis square
axis([-.2 .2 -.2 .2])


ax = nexttile;
scatter(normalize(WSv(filter_data), "norm"), normalize(p1.v_highpass(filter_data), "norm"))
axis square
axis([-.2 .2 -.2 .2])


%%
figure
tiledlayout(2, 1, "TileSpacing", "compact", "Padding", "tight")
% scatter(WSm(filter_data), sqrt(p1.u_lowpass(filter_data).^2 + p1.v_lowpass(filter_data).^2))
ax = nexttile;
scatter(WSu(filter_data), p2.u_lowpass(filter_data))
axis square

ax = nexttile;
scatter(WSv(filter_data), p2.v_lowpass(filter_data))
axis square