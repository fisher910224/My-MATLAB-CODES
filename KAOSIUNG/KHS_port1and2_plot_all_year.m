%% Plot KHS Port1 & 2
% 20260917
clear; close all; clc;

%% Path
main_folder = 'C:\Users\adm\Desktop\Kaohsiung';
station = 'Kaohsiung';
pic_c = [main_folder, '\picture\current'];
pic_w = [main_folder, '\picture\wave'];
pic_wind = [main_folder, '\picture\wind'];
pic_ty = [main_folder, '\picture\typhoon'];
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


%% Figure setting
figset_linefont = @(ax) set(ax, 'fontsize', 15, 'linewidth', 1.5, "TickLength", [0.005 0.02], 'TickDir', 'out'); % setting of font size, frame line size, tick length and size
figset_date = @(ax, wave_day) set(ax, 'XTick', floor(wave_day(1)):4:ceil(wave_day(end)), ...
    'Xticklabel', datestr(floor(wave_day(1)):4:ceil(wave_day(end)), 'mm/dd')); % Major ticks which means 4 days
figset_date_minorticks = @(ax, wave_day) set(ax.XAxis, 'Minortick', 'on', 'MinorTickValues', floor(wave_day(1)):1:ceil(wave_day(end))); % Minor ticks which means one day

%% load data
P1 = load("C:\Users\adm\Desktop\Kaohsiung\一港口\ProcessedData_p1.mat");
P2 = load("C:\Users\adm\Desktop\Kaohsiung\二港口\ProcessedData_p2.mat");
load("C:\Users\adm\Desktop\Kaohsiung\wind\ProcessedData.mat");
load("QCsettings.mat")


period_Krathon = datetime(2018, 9, 1):datetime(2026, 3, 1)-days(1);
% period_Krathon = datetime(year_time, month_time, 15):datetime(year_time, month_time+1, 17)-days(1);
saving_time = sprintf("%s_%s", datestr(period_Krathon(1), 'yyyymmdd'), datestr(period_Krathon(end), 'yyyymmdd'));
plot_time = sprintf("%s~%s", datestr(period_Krathon(1), 'yyyy/mm/dd'), datestr(period_Krathon(end), 'yyyy/mm/dd'));

ig = find(Wind.ddatetime >= period_Krathon(1) & Wind.ddatetime <= period_Krathon(end));
W_time = Wind.ddatetime(ig);
WSm = Wind.WSm(ig);
WDm = Wind.WDm(ig);
WSmax = Wind.WSmax(ig);
WDmax = Wind.WDmax(ig);
WSmax_time = Wind.WSmax_time(ig);


ig_dday = find(P1.W.ddatetime >= period_Krathon(1) & P1.W.ddatetime <= period_Krathon(end));
Hs_raw = P1.W.H(ig_dday)/100;
T_raw = P1.W.T(ig_dday);
Tm_raw = P1.W.Tmean(ig_dday);
Dir_raw = P1.W.Dir(ig_dday);


if ~isempty(ig_dday)
    [orig_dday, p1.Hs] = find_missing_data(P1.W.ddatetime(ig_dday), Hs_raw, hours(1));
    [~, p1.Tp] = find_missing_data(P1.W.ddatetime(ig_dday), T_raw, hours(1));
    [~, p1.Tmean] = find_missing_data(P1.W.ddatetime(ig_dday), Tm_raw, hours(1));
    [~, p1.Dir] = find_missing_data(P1.W.ddatetime(ig_dday), Dir_raw, hours(1));
    p1.Tp(p1.Tp < 0) = NaN;
    p1.Tmean(p1.Tmean < 0) = NaN;
    p1.dday = orig_dday;
else
    p1.Hs = [];
    p1.dday = [];
    p1.Tp = [];
    p1.Tmean = [];
    p1.Dir = [];
end





ig_dday = find(P2.W.ddatetime >= period_Krathon(1) & P2.W.ddatetime <= period_Krathon(end));
Hs_raw = P2.W.H(ig_dday)/100;
T_raw = P2.W.T(ig_dday);
Tm_raw = P2.W.Tmean(ig_dday);
Dir_raw = P2.W.Dir(ig_dday);
if ~isempty(ig_dday)
    [orig_dday, p2.Hs] = find_missing_data(P2.W.ddatetime(ig_dday), Hs_raw, hours(1));
    [~, p2.Tp] = find_missing_data(P2.W.ddatetime(ig_dday), T_raw, hours(1));
    [~, p2.Tmean] = find_missing_data(P2.W.ddatetime(ig_dday), Tm_raw, hours(1));
    [~, p2.Dir] = find_missing_data(P2.W.ddatetime(ig_dday), Dir_raw, hours(1));
    p2.Tp(p2.Tp < 0) = NaN;
    p2.Tmean(p2.Tmean < 0) = NaN;
    p2.dday = orig_dday;
else
    p2.Hs = [];
    p2.dday = [];
    p2.Tp = [];
    p2.Tmean = [];
    p2.Dir = [];
end

ig_dday = find(P1.C.ddatetime >= period_Krathon(1) & P1.C.ddatetime <= period_Krathon(end));
if ~isempty(ig_dday)
    [orig_dday, p1.Vel] = find_missing_data(P1.C.ddatetime(ig_dday), P1.C.Cur(ig_dday), hours(1));
    [~, p1.CDir] = find_missing_data(P1.C.ddatetime(ig_dday), P1.C.Dir(ig_dday));
    % p1.Vel = P1.C.Cur(ig);
    % p1.CDir = P1.C.Dir(ig);
    % p1.c_dday = P1.C.ddatetime(ig);
    % p1.c_dday = orig_dday';
    p1.c_dday = orig_dday;
    [~, p1.u] = find_missing_data(P1.C.ddatetime(ig_dday), P1.C.u(ig_dday));
    [~, p1.v] = find_missing_data(P1.C.ddatetime(ig_dday), P1.C.v(ig_dday));
    % p1.u = P1.C.u(ig);
    % p1.v = P1.C.v(ig);
else
    p1.c_dday = [];
    p1.Vel = [];
    p1.CDir = [];
    p1.u = [];
    p1.v = [];
end

ig_dday = find(P2.C.ddatetime >= period_Krathon(1) & P2.C.ddatetime <= period_Krathon(end));
% diff(P2.C.ddatetime(ig_dday))
% sr = mode()
if ~isempty(ig_dday)
    [orig_dday, p2.Vel] = find_missing_data(P2.C.ddatetime(ig_dday), P2.C.Cur(ig_dday), hours(1));
    [~, p2.CDir] = find_missing_data(P2.C.ddatetime(ig_dday), P2.C.Dir(ig_dday));
    % p2.c_dday = orig_dday';
    p2.c_dday = orig_dday;
    [~, p2.u] = find_missing_data(P2.C.ddatetime(ig_dday), P2.C.u(ig_dday));
    [~, p2.v] = find_missing_data(P2.C.ddatetime(ig_dday), P2.C.v(ig_dday));
% p2.Vel = P2.C.Cur(ig);
% p2.CDir = P2.C.Dir(ig);
% p2.c_dday = P2.C.ddatetime(ig);
% p2.u = P2.C.u(ig);
% p2.v = P2.C.v(ig);
else
    p2.c_dday = [];
    p2.Vel = [];
    p2.CDir = [];
    p2.u = [];
    p2.v = [];
end

% ====================== QC test =======================
% ========================= P1 ============================
[p1.Hs_flags, f] = QC_TEST(p1.dday, p1.Hs, mode(diff(p1.dday)), WV_QCsettings);
p1.Hs(f >= 4) = NaN;

[p1.Tp_flags, f] = QC_TEST(p1.dday, p1.Tp, 1, TP_QCsettings, "Test1", "off");
p1.Tp(f >= 4) = NaN;

[p1.Tm_flags, f] = QC_TEST(p1.dday, p1.Tmean, 1, TP_QCsettings, "Test1", "off");
p1.Tmean(f >= 4) = NaN;

[p1.WDir_flags, f] = QC_TEST(p1.dday, p1.Dir, 1, WVD_QCsettings, ...
    "Test1", "off", "Test6", "off", "Test7", "off", "Test8", "off", "Test10", "off");
p1.Dir(f >= 4) = NaN;

wave.Hs = p1.Hs;
wave.Tp = p1.Tp;
wave.Tmean = p1.Tmean;
wave.Dir = p1.Dir;
wave.ddatetime = p1.dday;

[p1.Cur_flags, f] = QC_TEST(p1.c_dday, p1.Vel, 1, CU_QCsettings, "Test1", "off");
p1.Vel(f >= 4) = NaN;

[p1.CDir_flags, f] = QC_TEST(p1.c_dday, p1.CDir, 1, CD_QCsettings, ...
    "Test1", "off", "Test6", "off", "Test7", "off", "Test8", "off", "Test10", "off");
p1.CDir(f >= 4) = NaN;

curr.Cur = p1.Vel;
curr.Dir = p1.CDir;
curr.ddatetime = p1.c_dday;

save("C:\Users\adm\Desktop\Kaohsiung\QCed_P1_wave.mat", "wave")
save("C:\Users\adm\Desktop\Kaohsiung\QCed_P1_curr.mat", "curr")


% ========================= P2 ============================
[p2.Hs_flags, f] = QC_TEST(p2.dday, p2.Hs, 1, WV_QCsettings, "Test1", "off");
p2.Hs(f >= 4) = NaN;

[p2.Tp_flags, f] = QC_TEST(p2.dday, p2.Tp, 1, TP_QCsettings, "Test1", "off");
p2.Tp(f >= 4) = NaN;

[p2.Tm_flags, f] = QC_TEST(p2.dday, p2.Tmean, 1, TP_QCsettings, "Test1", "off");
p2.Tmean(f >= 4) = NaN;

[p2.WDir_flags, f] = QC_TEST(p2.dday, p2.Dir, 1, WVD_QCsettings, ...
    "Test1", "off", "Test6", "off", "Test7", "off", "Test8", "off", "Test10", "off");
p2.Dir(f >= 4) = NaN;

wave.Hs = p2.Hs;
wave.Tp = p2.Tp;
wave.Tmean = p2.Tmean;
wave.Dir = p2.Dir;
wave.ddatetime = p2.dday;

[p2.Cur_flags, f] = QC_TEST(p2.c_dday, p2.Vel, 1, CU_QCsettings, "Test1", "off");
p2.Vel(f >= 4) = NaN;

[p2.CDir_flags, f] = QC_TEST(p2.c_dday, p2.CDir, 1, CD_QCsettings, ...
    "Test1", "off", "Test6", "off", "Test7", "off", "Test8", "off", "Test10", "off");
p2.CDir(f >= 4) = NaN;

curr.Cur = p2.Vel;
curr.Dir = p2.CDir;
curr.ddatetime = p2.c_dday;

save("C:\Users\adm\Desktop\Kaohsiung\QCed_P2_wave.mat", "wave")
save("C:\Users\adm\Desktop\Kaohsiung\QCed_P2_curr.mat", "curr")

p1.u = p1.Vel.*sind(p1.CDir);
p1.v = p1.Vel.*cosd(p1.CDir);

p2.u = p2.Vel.*sind(p2.CDir);
p2.v = p2.Vel.*cosd(p2.CDir);



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

% SL_lowpass = filtfilt(b, a, SLm);

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


%% Ellipse
fig = figure;
if ~isempty(p1.u)
    % try
    cc = complex(p1.u, p1.v);
    Tidecon = t_tide(cc, 1);
    K1 = find(strcmp(Tidecon.name, "K1"));
    M2 = find(strcmp(Tidecon.name, "M2"));
    O1 = find(strcmp(Tidecon.name, "O1"));
    S2 = find(strcmp(Tidecon.name, "S2"));

    if ~isempty(K1)
        ellipse(Tidecon.tidecon(K1, 1), Tidecon.tidecon(K1, 3), Tidecon.tidecon(K1, 5)*pi/180, .2, 0); hold on
        p1.amp_maj_K1 = Tidecon.tidecon(K1, 1);
        p1.amp_min_K1 = Tidecon.tidecon(K1, 3);
        p1.inc_K1 = Tidecon.tidecon(K1, 5);
        p1.pha_K1 = Tidecon.tidecon(K1, 7);
    end
    if ~isempty(O1)
        ellipse(Tidecon.tidecon(O1, 1), Tidecon.tidecon(O1, 3), Tidecon.tidecon(O1, 5)*pi/180, .4, 0); hold on
        p1.amp_maj_O1 = Tidecon.tidecon(O1, 1);
        p1.amp_min_O1 = Tidecon.tidecon(O1, 3);
        p1.inc_O1 = Tidecon.tidecon(O1, 5);
        p1.pha_O1 = Tidecon.tidecon(O1, 7);
    end
    if ~isempty(M2)
        ellipse(Tidecon.tidecon(M2, 1), Tidecon.tidecon(M2, 3), Tidecon.tidecon(M2, 5)*pi/180, .6, 0); hold on
        p1.amp_maj_M2 = Tidecon.tidecon(M2, 1);
        p1.amp_min_M2 = Tidecon.tidecon(M2, 3);
        p1.inc_M2 = Tidecon.tidecon(M2, 5);
        p1.pha_M2 = Tidecon.tidecon(M2, 7);
    end
    if ~isempty(S2)
        ellipse(Tidecon.tidecon(S2, 1), Tidecon.tidecon(S2, 3), Tidecon.tidecon(S2, 5)*pi/180, .8, 0); hold on
        p1.amp_maj_S2 = Tidecon.tidecon(S2, 1);
        p1.amp_min_S2 = Tidecon.tidecon(S2, 3);
        p1.inc_S2 = Tidecon.tidecon(S2, 5);
        p1.pha_S2 = Tidecon.tidecon(S2, 7);
    end
end

if ~isempty(p2.u)
    cc = complex(p2.u, p2.v);
    Tidecon = t_tide(cc, 1);
    K1 = find(strcmp(Tidecon.name, "K1"));
    M2 = find(strcmp(Tidecon.name, "M2"));
    O1 = find(strcmp(Tidecon.name, "O1"));
    S2 = find(strcmp(Tidecon.name, "S2"));
    
    if ~isempty(K1)
        ellipse(Tidecon.tidecon(K1, 1), Tidecon.tidecon(K1, 3), Tidecon.tidecon(K1, 5)*pi/180, .2, 0, 'b'); hold on
        p2.amp_maj_K1 = Tidecon.tidecon(K1, 1);
        p2.amp_min_K1 = Tidecon.tidecon(K1, 3);
        p2.inc_K1 = Tidecon.tidecon(K1, 5);
        p2.pha_K1 = Tidecon.tidecon(K1, 7);
    end
    if ~isempty(O1)
        ellipse(Tidecon.tidecon(O1, 1), Tidecon.tidecon(O1, 3), Tidecon.tidecon(O1, 5)*pi/180, .4, 0, 'b'); hold on
        p2.amp_maj_O1 = Tidecon.tidecon(O1, 1);
        p2.amp_min_O1 = Tidecon.tidecon(O1, 3);
        p2.inc_O1 = Tidecon.tidecon(O1, 5);
        p2.pha_O1 = Tidecon.tidecon(O1, 7);
    end
    if ~isempty(M2)
        ellipse(Tidecon.tidecon(M2, 1), Tidecon.tidecon(M2, 3), Tidecon.tidecon(M2, 5)*pi/180, .6, 0, 'b'); hold on
        p2.amp_maj_M2 = Tidecon.tidecon(M2, 1);
        p2.amp_min_M2 = Tidecon.tidecon(M2, 3);
        p2.inc_M2 = Tidecon.tidecon(M2, 5);
        p2.pha_M2 = Tidecon.tidecon(M2, 7);
    end
    if ~isempty(S2)
        ellipse(Tidecon.tidecon(S2, 1), Tidecon.tidecon(S2, 3), Tidecon.tidecon(S2, 5)*pi/180, .8, 0, 'b'); hold on
        p2.amp_maj_S2 = Tidecon.tidecon(S2, 1);
        p2.amp_min_S2 = Tidecon.tidecon(S2, 3);
        p2.inc_S2 = Tidecon.tidecon(S2, 5);
        p2.pha_S2 = Tidecon.tidecon(S2, 7);
    end
end

if ~isempty(p1.u) && ~isempty(p2.u)
    ylabel("Speed (m s^{-1})")
    legend("Port 1", "", "", "", "Port 2", "", "", "")

elseif ~isempty(p1.u) && isempty(p2.u)
    ylabel("Speed (m s^{-1})")
    legend("Port 1", "", "", "")
elseif isempty(p1.u) && ~isempty(p2.u)
    ylabel("Speed (m s^{-1})")
    legend("Port 2", "", "", "")
end

xlim([0 1])
grid on
axis equal
set(gca, 'Xtick', .2:.2:.8, 'XTickLabel', {"K1", "O1", "M2", "S2"}, 'FontSize', 18, 'linewidth', 2)

saving_str = fullfile(pic_c, sprintf("%s_%s_Tide_Ellipse.png", saving_time, station));
if ~isempty(p1.u) || ~isempty(p2.u)
    exportgraphics(fig, saving_str)  
end

fid = fopen("C:\Users\adm\Desktop\Kaohsiung\processed_data\Tidalinc_statistics.csv", "w");
fprintf(fid, "Port 1\nTide,Amp_maj,Amp_min,Inc.,Phase\n");
fprintf(fid, "K1,%.3f,%.3f,%.1f,%.1f\n", p1.amp_maj_K1, p1.amp_min_K1, p1.inc_K1, p1.pha_K1);
fprintf(fid, "O1,%.3f,%.3f,%.1f,%.1f\n", p1.amp_maj_O1, p1.amp_min_O1, p1.inc_O1, p1.pha_O1);
fprintf(fid, "M2,%.3f,%.3f,%.1f,%.1f\n", p1.amp_maj_M2, p1.amp_min_M2, p1.inc_M2, p1.pha_M2);
fprintf(fid, "S2,%.3f,%.3f,%.1f,%.1f\n", p1.amp_maj_S2, p1.amp_min_S2, p1.inc_S2, p1.pha_S2);

fprintf(fid, "Port 2\nTide,Amp_maj,Amp_min,Inc.,Phase\n");
fprintf(fid, "K1,%.3f,%.3f,%.1f,%.1f\n", p2.amp_maj_K1, p2.amp_min_K1, p2.inc_K1, p2.pha_K1);
fprintf(fid, "O1,%.3f,%.3f,%.1f,%.1f\n", p2.amp_maj_O1, p2.amp_min_O1, p2.inc_O1, p2.pha_O1);
fprintf(fid, "M2,%.3f,%.3f,%.1f,%.1f\n", p2.amp_maj_M2, p2.amp_min_M2, p2.inc_M2, p2.pha_M2);
fprintf(fid, "S2,%.3f,%.3f,%.1f,%.1f\n", p2.amp_maj_S2, p2.amp_min_S2, p2.inc_S2, p2.pha_S2);
fclose(fid);

%% Spectrum

fs = 24;
window = hann(256);
noverlap = length(window)/2;
nfft = 1024;
alpha = 0.95;
fig = figure("OuterPosition", [1 1 800 600]);
ax = nexttile;

if ~isempty(p1.Vel) & length(p1.Vel) > length(window)
    % [psd1, ff1] = pwelch(detrend(p1.Vel), window, noverlap, nfft, 24);
    % [psd2, ff2] = pwelch(detrend(p2.Vel), window, noverlap, nfft, 24);
    smooth_Vel = fillmissing(p1.Vel, "linear");
    [psd1, ff1, psd1c] = pwelch(detrend(smooth_Vel), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
    h = fill([ff1(2:end); flipud(ff1(2:end))], [psd1c(2:end, 1); flipud(psd1c(2:end, 2))], 'k', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
    set(ax, 'Xscale', 'log', 'Yscale', 'log')
    set(h, 'FaceAlpha', 0.3)
    loglog(ff1, psd1, 'Color', 'k', 'DisplayName', 'Port 1', 'linewidth', 2); hold on
end

if ~isempty(p2.Vel) & length(p2.Vel) > length(window)
    smooth_Vel = fillmissing(p2.Vel, "linear");
    [psd2, ff2, psd2c] = pwelch(detrend(smooth_Vel), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
    h = fill([ff2(2:end); flipud(ff2(2:end))], [psd2c(2:end, 1); flipud(psd2c(2:end, 2))], 'b', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
    set(h, 'FaceAlpha', 0.3)
    set(ax, 'Xscale', 'log', 'Yscale', 'log')
    loglog(ff2, psd2, 'Color', 'b', 'DisplayName', 'Port 2', 'linewidth', 2); hold on
end

smooth_Vel = fillmissing(WSm, "linear");
[psd1, ff1, psd1c] = pwelch(detrend(smooth_Vel), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
h = fill([ff1(2:end); flipud(ff1(2:end))], [psd1c(2:end, 1); flipud(psd1c(2:end, 2))], 'r', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
set(ax, 'Xscale', 'log', 'Yscale', 'log')
set(h, 'FaceAlpha', 0.3)
loglog(ff1, psd1, 'Color', 'r', 'DisplayName', 'Wind', 'linewidth', 2); hold on


xline(1.93, 'Color', 'r', 'LineStyle', '--', 'Label', 'M2', 'HandleVisibility', 'off'); % M2 潮汐 (~1.93 cpd)
xline(24/23.93447, 'Color', 'r', 'LineStyle', '--', 'Label', 'K1', 'HandleVisibility', 'off'); % K1 潮汐
legend
figset_linefont(ax)
title_str = sprintf("%s", plot_time);
title(ax, title_str)
ylabel('Power Spectral Density (m^2 s^{-2} cpd^{-1})')
xlabel('Frequency (cpd)')
xlim([1e-1 1e1])
% saving_str = fullfile(pic_c, sprintf("%s_%s_Tide_Spectrum.png", saving_time, station));
% if ~isempty(p1.Hs) || ~isempty(p2.Hs)
%     exportgraphics(fig, saving_str)  
% end

%% PVD
if ~isempty(p1.u)
PVD_x = cumsum(p1.u*3600/1000, "omitmissing");
PVD_y = cumsum(p1.v*3600/1000, "omitmissing");

total_distance = cumsum(p1.Vel*3600/1000, "omitmissing");


figure
tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
plot(PVD_x, PVD_y, 'k', 'LineWidth', 2); hold on
txt_str = sprintf("Displacement distance: %.2f km\nTotal distance: %.2f km\nDisplacement velocity: %.2f km/day\nTotal velocity: %.2f km/day", ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2), ...
    total_distance(end), ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2)/(sum(~isnan(p1.Vel)) / 24), ...
    total_distance(end)/(sum(~isnan(p1.Vel)) / 24));
    % total_distance(end)/sum(~isnan(p1.Hs)));
    % total_distance(end)/length(period_Krathon));
scatter(PVD_x(1), PVD_y(1), 100, 'red', 'filled', '^'); hold on
text(PVD_x(1), PVD_y(1), "start    ", "FontSize", 12, "Color", "r", "HorizontalAlignment", "right"); hold on
scatter(PVD_x(end), PVD_y(end), 300, 'red', 'filled', 'square');
text(PVD_x(end), PVD_y(end)+10, "end    ", "FontSize", 12, "Color", "r", "HorizontalAlignment", "right"); hold on

text(0.005, .85, txt_str, "Units", "Normal", "Fontsize", 12)
axis equal
xlim([floor(min(PVD_x)/2)*2-10000 ceil(max(PVD_x)/2)*2+10000])
ylim([floor(min(PVD_y)/2)*2 ceil(max(PVD_y)/2)*2+20])
ylabel("Distance (km)")
xlabel("Distance (km)")
title_str = sprintf("\\bfKSH Port 1 PVD\n\\rm%s", [datestr(p1.c_dday(1), 'yyyy/mm/dd'), '~', datestr(p1.c_dday(end), 'yyyy/mm/dd')]);
title(ax, title_str)
figset_linefont(ax)
grid on


saving_str = fullfile(pic_c, sprintf("%s_%s_P1_PVD.png", [datestr(p1.c_dday(1), 'yyyymmdd'), '_', datestr(p1.c_dday(end), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)

end

    if ~isempty(p2.u)
    PVD_x = cumsum(p2.u*3600/1000, "omitmissing");
    PVD_y = cumsum(p2.v*3600/1000, "omitmissing");
    total_distance = cumsum(p2.Vel*3600/1000, "omitmissing");
    
    figure
    tiledlayout(1, 1, "TileSpacing", "compact", "Padding", "tight");
    ax = nexttile;
    plot(PVD_x, PVD_y, 'k', 'LineWidth', 2); hold on
    txt_str = sprintf("Displacement distance: %.2f km\nTotal distance: %.2f km\nDisplacement velocity: %.2f km/day\nTotal velocity: %.2f km/day", ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2), ...
    total_distance(end), ...
    sqrt(PVD_x(end)^2 + PVD_y(end)^2)/(sum(~isnan(p2.Vel)) / 24), ...
    total_distance(end)/(sum(~isnan(p2.Vel)) / 24));
    scatter(PVD_x(1), PVD_y(1), 100, 'red', 'filled', '^'); hold on
    text(PVD_x(1), PVD_y(1), "start    ", "FontSize", 12, "Color", "r", "HorizontalAlignment", "right"); hold on
    scatter(PVD_x(end), PVD_y(end), 300, 'red', 'filled', 'square');
    text(PVD_x(end), PVD_y(end)+10, "end    ", "FontSize", 12, "Color", "r", "HorizontalAlignment", "right"); hold on
    
    text(0.005, .85, txt_str, "Units", "Normal", "Fontsize", 12)
    axis equal
    xlim([floor(min(PVD_x)/2)*2 ceil(max(PVD_x)/2)*2])
    ylim([floor(min(PVD_y)/2)*2 ceil(max(PVD_y)/2)*2+20])
    ylabel("Distance (km)")
    xlabel("Distance (km)")
    title_str = sprintf("\\bfKSH Port 2 PVD\n\\rm%s", [datestr(p2.c_dday(1), 'yyyy/mm/dd'), '~', datestr(p2.c_dday(end), 'yyyy/mm/dd')]);
    title(ax, title_str)
    figset_linefont(ax)
    grid on
    
    
    saving_str = fullfile(pic_c, sprintf("%s_%s_P2_PVD.png", [datestr(p2.c_dday(1), 'yyyymmdd'), '_', datestr(p2.c_dday(end), 'yyyymmdd')], station));
    exportgraphics(gcf, saving_str)
    
    


    end

%% Cross-flow
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
title_str = sprintf("\\bfKHS Port 1 Along-flow (with K1 incline: %.1f^{\\circ})\n\\rm%s~%s", p1.inc_K1, datestr(p1.c_dday(prd(1)), 'yyyy/mm/dd'), datestr(p1.c_dday(prd(end)), 'yyyy/mm/dd'));
p1.u_along = p1.u.*cosd(p1.inc_K1) + p1.v.*sind(p1.inc_K1);
plot(datenum(p1.c_dday(prd)), p1.u_along(prd), 'Color', 'k', 'LineWidth', 2)
grid on
ylabel("Velocity (m s^{-1})")
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))
title(ax, title_str)
xlim([floor(datenum(p1.c_dday(prd(1)))) ceil(datenum(p1.c_dday(prd(end))))])
ylim([-2 2])


ax = nexttile;
title_str = sprintf("KHS Port 1 Cross-flow (with K1 incline: %.1f^{\\circ})", p1.inc_K1);
p1.u_cross = -p1.u.*sind(p1.inc_K1) + p1.v.*cosd(p1.inc_K1);
plot(datenum(p1.c_dday(prd)), p1.u_cross(prd), 'Color', 'k', 'LineWidth', 2)
grid on
ylabel("Velocity (m s^{-1})")
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))
title(ax, title_str)
xlim([floor(datenum(p1.c_dday(prd(1)))) ceil(datenum(p1.c_dday(prd(end))))])
ylim([-2 2])


prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
ax = nexttile;
title_str = sprintf("KHS Port 2 Along-flow (with M2 incline: %.1f^{\\circ})", p2.inc_M2);
p2.u_along = p2.u.*cosd(p2.inc_K1) + p2.v.*sind(p2.inc_K1);
plot(datenum(p2.c_dday(prd)), p2.u_along(prd), 'Color', 'b', 'LineWidth', 2)
grid on
ylabel("Velocity (m s^{-1})")
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))
title(ax, title_str)
xlim([floor(datenum(p2.c_dday(prd(1)))) ceil(datenum(p2.c_dday(prd(end))))])
ylim([-2 2])


ax = nexttile;
title_str = sprintf("KHS Port 2 Cross-flow (with M2 incline: %.1f^{\\circ})", p2.inc_M2);
p2.u_cross = -p2.u.*sind(p2.inc_K1) + p2.v.*cosd(p2.inc_K1);
plot(datenum(p2.c_dday(prd)), p2.u_cross(prd), 'Color', 'b', 'LineWidth', 2)
grid on
ylabel("Velocity (m s^{-1})")
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))
title(ax, title_str)
xlim([floor(datenum(p2.c_dday(prd(1)))) ceil(datenum(p2.c_dday(prd(end))))])
ylim([-2 2])


saving_str = fullfile(pic_ty, sprintf("%s_%s_P1P2_AlongCrossFlow.png", [datestr(p2.c_dday(prd(1)), 'yyyymmdd'), '_', datestr(p2.c_dday(prd(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


%% spectrum of cross flow
fs = 24;
window = hann(256);
noverlap = length(window)/2;
nfft = 1024;
alpha = 0.95;

prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
title_str = sprintf("\\bfKHS Port 1 Along-flow (with K1 incline: %.1f^{\\circ})\n\\rm%s~%s", p1.inc_K1, datestr(p1.c_dday(prd(1)), 'yyyy/mm/dd'), datestr(p1.c_dday(prd(end)), 'yyyy/mm/dd'));
p1.u_along = p1.u.*cosd(p1.inc_K1) + p1.v.*sind(p1.inc_K1);
plot(datenum(p1.c_dday(prd)), p1.u_along(prd), 'Color', 'k', 'LineWidth', 2)
grid on
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))
title(ax, title_str)
xlim([floor(datenum(p1.c_dday(prd(1)))) ceil(datenum(p1.c_dday(prd(end))))])
ylim([-2 2])


ax = nexttile;
title_str = sprintf("KHS Port 1 Cross-flow (with K1 incline: %.1f^{\\circ})", p1.inc_K1);
p1.u_cross = -p1.u.*sind(p1.inc_K1) + p1.v.*cosd(p1.inc_K1);
plot(datenum(p1.c_dday(prd)), p1.u_cross(prd), 'Color', 'k', 'LineWidth', 2)
grid on
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))
title(ax, title_str)
xlim([floor(datenum(p1.c_dday(prd(1)))) ceil(datenum(p1.c_dday(prd(end))))])
ylim([-2 2])


ax = nexttile([2, 1]);
smooth_Vel = fillmissing(p1.u_along, "linear");
[psd1, ff1, psd1c] = pwelch(detrend(smooth_Vel), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
h = fill([ff1(2:end); flipud(ff1(2:end))], [psd1c(2:end, 1); flipud(psd1c(2:end, 2))], 'k', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
set(ax, 'Xscale', 'log', 'Yscale', 'log')
set(h, 'FaceAlpha', 0.3)
loglog(ff1, psd1, 'Color', 'k', 'DisplayName', 'Port 1 along-flow', 'linewidth', 2); hold on

smooth_Vel = fillmissing(p1.u_cross, "linear");
[psd1, ff1, psd1c] = pwelch(detrend(smooth_Vel), window, noverlap, nfft, fs, 'ConfidenceLevel', alpha);
h = fill([ff1(2:end); flipud(ff1(2:end))], [psd1c(2:end, 1); flipud(psd1c(2:end, 2))], 'b', 'EdgeColor', 'none', 'HandleVisibility', 'off'); hold on
set(ax, 'Xscale', 'log', 'Yscale', 'log')
set(h, 'FaceAlpha', 0.3)
loglog(ff1, psd1, 'Color', 'b', 'DisplayName', 'Port 1 cross-flow', 'linewidth', 2); hold on

xline(1.93, 'Color', 'r', 'LineStyle', '--', 'Label', 'M2', 'HandleVisibility', 'off'); % M2 潮汐 (~1.93 cpd)
xline(24/23.93447, 'Color', 'r', 'LineStyle', '--', 'Label', 'K1', 'HandleVisibility', 'off'); % K1 潮汐
legend
figset_linefont(ax)
title_str = sprintf("%s", plot_time);
title(ax, title_str)
ylabel('Power Spectral Density (m^2 s^{-2} cpd^{-1})')
xlabel('Frequency (cpd)')
xlim([1e-1 1e1])

%% Wind vs current
WSu = -WSm.*sind(WDm);
WSv = -WSm.*cosd(WDm);

figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 1 Wind vs. Current\n\\rm%s~%s", datestr(W_time(prd(1)), 'yyyy/mm/dd'), datestr(W_time(prd(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd)), WSv(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_v'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.v(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_v')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))


ax = nexttile;
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
plot(datenum(W_time(prd)), WSu(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_u'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'Color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_u')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))


ax = nexttile;
title_str = sprintf("KHS Port 1 Wind vs. Current 40hr low-pass flow");
title(ax, title_str)
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
plot(datenum(W_time(prd)), WSv(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_v'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'Color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.v_lowpass(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{v-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))


ax = nexttile;
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
plot(datenum(W_time(prd)), WSu(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_u'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'Color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u_lowpass(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{u-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))

xlabel(tt, 'Date (mm/dd)')

saving_str = fullfile(pic_ty, sprintf("%s_%s_P1_WindvsCurrent.png", [datestr(p1.c_dday(prd(1)), 'yyyymmdd'), '_', datestr(p1.c_dday(prd(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)




figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 2 Wind vs. Current\n\\rm%s~%s", datestr(W_time(prd(1)), 'yyyy/mm/dd'), datestr(W_time(prd(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd)), WSv(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_v'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.v(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_v')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))


ax = nexttile;
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
plot(datenum(W_time(prd)), WSu(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_u'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'Color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_u')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))


ax = nexttile;
title_str = sprintf("KHS Port 2 Wind vs. Current 40hr low-pass flow");
title(ax, title_str)
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
plot(datenum(W_time(prd)), WSv(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_v'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'Color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.v_lowpass(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{v-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))


ax = nexttile;
yyaxis left
prd = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
plot(datenum(W_time(prd)), WSu(prd), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind_u'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'Color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u_lowpass(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{u-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))

xlabel(tt, 'Date (mm/dd)')

saving_str = fullfile(pic_ty, sprintf("%s_%s_P2_WindvsCurrent.png", [datestr(p2.c_dday(prd(1)), 'yyyymmdd'), '_', datestr(p2.c_dday(prd(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


%% Wind-along vs Current-along
dt = 1;
fs = 1/dt;
T_cutoff = 40; % filter tide under 40 hr
f_cutoff = 1/T_cutoff;

f_nyquist = fs/2;
Wn = f_cutoff / f_nyquist; % normalized frequency

order = 4; 
[b, a] = butter(order, Wn, "low");

WSu_fillmissing = fillmissing(WSu, "linear");
WSv_fillmissing = fillmissing(WSv, "linear");

WSu_lowpass = filtfilt(b, a, WSu_fillmissing);
WSv_lowpass = filtfilt(b, a, WSv_fillmissing);

WS_along = WSu_lowpass.*cosd(p1.inc_K1) + WSv_lowpass.*sind(p1.inc_K1);
tau_along = WS_along.* abs(WSm);

p1.u_along_lpss = p1.u_lowpass.*cosd(p1.inc_K1) + p1.v_lowpass.*sind(p1.inc_K1);


figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 1 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_along(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{along}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u_along_lpss(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{along-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))


ax = nexttile;
[cc, lags] = xcorr(tau_along(prd_wind), p1.u_along_lpss(prd), "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'k')
xlim([-24 24])
ylim([0.4 0.8])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(cc);
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



WS_along = WSu_lowpass.*cosd(p2.inc_M2) + WSv_lowpass.*sind(p2.inc_M2);
tau_along = WS_along.* abs(WSm);
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 2 Wind-along-lowpass vs. Current-along-lowpass");
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_along(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{along}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

p2.u_along_lpss = p2.u_lowpass.*cosd(p2.inc_M2) + p2.v_lowpass.*sind(p2.inc_M2);
yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u_along_lpss(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{along-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))


ax = nexttile;
[cc, lags] = xcorr(tau_along(prd_wind), p2.u_along_lpss(prd), "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'b')
xlim([-24 24])
ylim([0.4 0.8])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(cc);
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on


saving_str = fullfile(pic_ty, sprintf("%s_%s_P1P2_WindtauvsCurrent_lowpass_lagcorr_along.png", [datestr(p2.c_dday(prd(1)), 'yyyymmdd'), '_', datestr(p2.c_dday(prd(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)



% ============= Cross =====================================================
WS_cross = -WSu_lowpass.*sind(p1.inc_K1) + WSv_lowpass.*cosd(p1.inc_K1);
tau_cross = WS_cross.* abs(WSm);

p1.u_cross_lpss = -p1.u_lowpass.*sind(p1.inc_K1) + p1.v_lowpass.*cosd(p1.inc_K1);


figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 1 Wind-cross-lowpass vs. Current-cross-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_cross(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{cross}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u_cross_lpss(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{cross-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))


ax = nexttile;
[cc, lags] = xcorr(tau_cross(prd_wind), p1.u_cross_lpss(prd), "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'k')
xlim([-24 24])
ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(cc);
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



WS_cross = -WSu_lowpass.*sind(p2.inc_M2) + WSv_lowpass.*cosd(p2.inc_M2);
tau_cross = WS_cross.* abs(WSm);
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 2 Wind-cross-lowpass vs. Current-cross-lowpass");
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_cross(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{cross}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

p2.u_cross_lpss = -p2.u_lowpass.*sind(p2.inc_M2) + p2.v_lowpass.*cosd(p2.inc_M2);
yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u_cross_lpss(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{cross-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))


ax = nexttile;
[cc, lags] = xcorr(tau_cross(prd_wind), p2.u_cross_lpss(prd), "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'b')
xlim([-24 24])
ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(cc);
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on


saving_str = fullfile(pic_ty, sprintf("%s_%s_P1P2_WindtauvsCurrent_lowpass_lagcorr_cross.png", [datestr(p2.c_dday(prd(1)), 'yyyymmdd'), '_', datestr(p2.c_dday(prd(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


%% Wind & Current scatter
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(2, 1, "TileSpacing", "compact", "Padding", "tight");
ax =  nexttile;
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
scatter(WS_along(prd_wind), p1.u_along_lpss(prd), 15, datenum(p1.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
% colormap(jet)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 6])
ylim([-.6 .6])
xline(0)
yline(0)
title_str = sprintf("\\bfKHS Port 1 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
figset_linefont(ax)

ax = nexttile;
scatter(WS_cross(prd_wind), p1.u_cross_lpss(prd), 8, datenum(p1.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-15 6])
ylim([-1.5 .6])
xline(0)
yline(0)
title_str = sprintf("\\bfKHS Port 1 Wind-cross-lowpass vs. Current-cross-lowpass");
title(ax, title_str)
figset_linefont(ax)

saving_str = fullfile(pic_ty, sprintf("%s_%s_P1_WindtauvsCurrent_lowpass_scatter.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(2, 1, "TileSpacing", "compact", "Padding", "tight");
ax =  nexttile;
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
scatter(WS_along(prd_wind), p2.u_along_lpss(prd), 8, datenum(p2.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
% colormap(jet)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 6])
ylim([-.6 .6])
xline(0)
yline(0)
title_str = sprintf("\\bfKHS Port 2 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
figset_linefont(ax)

ax = nexttile;
scatter(WS_cross(prd_wind), p2.u_cross_lpss(prd), 8, datenum(p2.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-15 6])
ylim([-1.5 .6])
xline(0)
yline(0)
title_str = sprintf("\\bfKHS Port 2 Wind-cross-lowpass vs. Current-cross-lowpass");
title(ax, title_str)
figset_linefont(ax)

saving_str = fullfile(pic_ty, sprintf("%s_%s_P2_WindtauvsCurrent_lowpass_scatter.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


%% Wind-along vs current-along
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 1 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_along(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{along}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u_along_lpss(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{along-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_along(prd_wind), p1.u_along_lpss(prd), "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'k')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
scatter(WS_along(prd_wind), p1.u_along_lpss(prd), 15, datenum(p1.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 6])
ylim([-.6 .6])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 1 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P1_WindAlongvsCurrentAlong_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)



figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 2 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_along(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{along}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u_along_lpss(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{along-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_along(prd_wind), p2.u_along_lpss(prd), 24, "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'b')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
scatter(WS_along(prd_wind), p2.u_along_lpss(prd), 15, datenum(p2.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 6])
ylim([-.6 .6])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 2 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P2_WindAlongvsCurrentAlong_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


%% Wind-cross vs current-cross
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 1 Wind-cross-lowpass vs. Current-cross-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_cross(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{cross}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u_cross_lpss(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{cross-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_cross(prd_wind), p1.u_cross_lpss(prd), "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'k')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
scatter(WS_cross(prd_wind), p1.u_cross_lpss(prd), 15, datenum(p1.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 15])
ylim([-.6 1.5])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 1 Wind-cross-lowpass vs. Current-cross-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P1_WindCrossvsCurrentCross_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)



figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 2 Wind-cross-lowpass vs. Current-cross-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_cross(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{cross}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u_cross_lpss(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{cross-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_cross(prd_wind), p2.u_cross_lpss(prd), 24, "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'b')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
scatter(WS_cross(prd_wind), p2.u_cross_lpss(prd), 15, datenum(p2.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 15])
ylim([-.6 1.5])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 2 Wind-cross-lowpass vs. Current-cross-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P2_WindCrossvsCurrentCross_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


%% Wind-along vs current-cross
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 1 Wind-along-lowpass vs. Current-cross-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_along(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{along}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u_cross_lpss(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{cross-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_along(prd_wind), p1.u_cross_lpss(prd), "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'k')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
scatter(WS_along(prd_wind), p1.u_cross_lpss(prd), 15, datenum(p1.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 6])
ylim([-.6 .6])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 1 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P1_WindAlongvsCurrentCross_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)



figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 2 Wind-along-lowpass vs. Current-cross-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_along(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{along}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u_cross_lpss(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{cross-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_along(prd_wind), p2.u_cross_lpss(prd), 24, "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'b')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
scatter(WS_along(prd_wind), p2.u_cross_lpss(prd), 15, datenum(p2.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 6])
ylim([-.6 .6])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 2 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P2_WindAlongvsCurrentCross_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)



%% Wind-cross vs current-along
figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 1 Wind-cross-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_cross(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{cross}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
plot(datenum(p1.c_dday(prd)), p1.u_along_lpss(prd), 'Color', 'k', 'LineWidth', 1.2, 'DisplayName', 'Cur_{along-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p1.c_dday(prd)))
figset_date_minorticks(ax, datenum(p1.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_cross(prd_wind), p1.u_along_lpss(prd), 24, "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'k')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p1.c_dday >= datetime(2024, 09, 15) & p1.c_dday <= datetime(2024, 10, 16));
scatter(WS_cross(prd_wind), p1.u_along_lpss(prd), 15, datenum(p1.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 15])
ylim([-.6 1.5])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 1 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P1_WindCrossvsCurrentAlong_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)


figure("OuterPosition", [1 1 1920/2 1080])
tt = tiledlayout(4, 1, "TileSpacing", "compact", "Padding", "tight");
ax = nexttile;
yyaxis left
prd_wind = find(W_time >= datetime(2024, 09, 15) & W_time <= datetime(2024, 10, 16));
title_str = sprintf("\\bfKHS Port 2 Wind-cross-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
title(ax, title_str)
plot(datenum(W_time(prd_wind)), WS_cross(prd_wind), 'Color', 'r', 'LineWidth', 1.2, 'DisplayName', 'Wind*|Wind|_{cross}'); hold on
set(ax, 'ycolor', 'r')
ylim([-30 30])
ylabel('Wind velocity (m s^{-1})', 'color', 'r')

yyaxis right
prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
plot(datenum(p2.c_dday(prd)), p2.u_along_lpss(prd), 'Color', 'b', 'LineWidth', 1.2, 'DisplayName', 'Cur_{along-lowpass}')
legend('NumColumns', 2)
set(ax, 'Ycolor', 'k')
grid on
ylim([-2 2])
ylabel('Current velocity (m s^{-1})')
figset_linefont(ax)
figset_date(ax, datenum(p2.c_dday(prd)))
figset_date_minorticks(ax, datenum(p2.c_dday(prd)))



ax = nexttile;
[cc, lags] = xcorr(tau_cross(prd_wind), p2.u_along_lpss(prd), 24, "normalized");
plot(lags, cc, 'linewidth', 2, 'Color', 'b')
xlim([-24 24])
% ylim([0 0.4])
xlabel('Lags (hr)')
figset_linefont(ax)
[~, idx] = max(abs(cc));
xline_str = sprintf("Lags = %.1f hr", lags(idx));
ylabel("Correlation coefficient")
xline(lags(idx), "Label", xline_str, "LineWidth", 2, "Color", 'r', "LineStyle", '--')
grid on



ax =  nexttile([2, 1]);
% prd = find(p2.c_dday >= datetime(2024, 09, 15) & p2.c_dday <= datetime(2024, 10, 16));
scatter(WS_cross(prd_wind), p2.u_along_lpss(prd), 15, datenum(p2.c_dday(prd)), 'filled')
cb = colorbar;
datetick(cb, 'y', 'mm/dd')
colormap(turbo)
xlabel("Wind speed (m s^{-1})")
ylabel("Current speed (m s^{-1})")
axis square
grid on
xlim([-6 15])
ylim([-.6 1.5])
xline(0)
yline(0)
% title_str = sprintf("\\bfKHS Port 2 Wind-along-lowpass vs. Current-along-lowpass\n\\rm%s~%s", datestr(W_time(prd_wind(1)), 'yyyy/mm/dd'), datestr(W_time(prd_wind(end)), 'mm/dd'));
% title(ax, title_str)
figset_linefont(ax)


saving_str = fullfile(pic_ty, sprintf("%s_%s_P2_WindCrossvsCurrentAlong_lowpass.png", [datestr(W_time(prd_wind(1)), 'yyyymmdd'), '_', datestr(W_time(prd_wind(end)), 'yyyymmdd')], station));
exportgraphics(gcf, saving_str)