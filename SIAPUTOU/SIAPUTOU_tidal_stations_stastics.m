%% Tidal stations
% 20260831
clear; close all; clc;

%% 
file_folder_main = 'C:\Users\adm\Desktop\潮位站資料原始資料';
stations = {"Xialiuqiu", "Donggang", "Kaohsiung", "Houbihu"};
stations_var = {"XLQ", "DG", "KHS", "HBH"};

T_data = struct();
for ii = 1:length(stations)
    dd = dir(fullfile(file_folder_main, stations{ii}, '*.mat'));
    tt_data = load(fullfile(dd.folder, dd.name), stations_var{ii});
    T_data.([stations_var{ii}]) = tt_data.([stations_var{ii}]).tide;
    p_data.([stations_var{ii}]) = fullfile("C:\Users\adm\Desktop\Siaputou\processed_data", stations{ii});
    if ~isfolder(p_data.([stations_var{ii}]))
        mkdir(p_data.([stations_var{ii}]))
    end
end


%% stastics
% stations_var = {"XLQ", "DG", "KHS", "HBH"};
month_number = 1:12;
stastics_data = struct();
% sr = 6/360;

for ii = 1:length(stations_var)

    for jj = 1:length(T_data.([stations_var{ii}]))

        t_raw = T_data.([stations_var{ii}])(jj).pres;
        t_datetime = datetime(T_data.([stations_var{ii}])(jj).dday, "ConvertFrom", "datenum");

        for kk = month_number

            ig = find(t_datetime.Month == kk);

            if ig

                stastics_data.([stations_var{ii}])(kk).HHWL(jj) = max(t_raw(ig), [], 'omitnan');
                
                % [high_vals, high_locs] = findpeaks(t_raw(ig), 'MinPeakDistance', 10*10);
                % [low_vals, low_locs] = findpeaks(-t_raw(ig), 'MinPeakDistance', 10*10);
                [high_vals, high_locs] = findpeaks(t_raw(ig));
                [low_vals, low_locs] = findpeaks(-t_raw(ig));
                low_vals = -low_vals; % 轉回正值

                num_cycles = min(length(high_vals), length(low_vals));
                ranges = abs(high_vals(1:num_cycles) - low_vals(1:num_cycles));

                % 4. 篩選「大潮」(Spring Tide)
                % 實務上可以取前 20% 最大的潮差作為大潮樣本，或根據農曆日期篩選
                spring_threshold = prctile(ranges, 80); % 取得前20%大的潮差門檻
                spring_idx = find(ranges >= spring_threshold);

                stastics_data.([stations_var{ii}])(kk).HWOST(jj) = mean(high_vals(spring_idx), 'omitnan');
                stastics_data.([stations_var{ii}])(kk).MHWL(jj) = mean(high_vals, 'omitnan');
                stastics_data.([stations_var{ii}])(kk).MWL(jj) = mean(t_raw(ig), 'omitnan');
                stastics_data.([stations_var{ii}])(kk).MLWL(jj) = mean(low_vals, 'omitnan');
                stastics_data.([stations_var{ii}])(kk).LWOST(jj) = mean(low_vals(spring_idx), 'omitnan');

                stastics_data.([stations_var{ii}])(kk).LLWL(jj) = min(t_raw(ig), [], 'omitnan');

                stastics_data.([stations_var{ii}])(kk).MR(jj) = mean(ranges, 'omitnan');

            else

                stastics_data.([stations_var{ii}])(kk).HHWL(jj) = NaN;
                stastics_data.([stations_var{ii}])(kk).HWOST(jj) = NaN;
                stastics_data.([stations_var{ii}])(kk).MHWL(jj) = NaN;
                stastics_data.([stations_var{ii}])(kk).MWL(jj) = NaN;
                stastics_data.([stations_var{ii}])(kk).MLWL(jj) = NaN;
                stastics_data.([stations_var{ii}])(kk).LWOST(jj) = NaN;
                stastics_data.([stations_var{ii}])(kk).LLWL(jj) = NaN;
                stastics_data.([stations_var{ii}])(kk).MR(jj) = NaN;

            end

        end

    end

end


%% Print processed data
var_names = {"HHWL", "HWOST", "MHWL", "MWL", "MLWL", "LWOST", "LLWL", "MR"};
HHWL = [];
HWOST = [];
MHWL = [];
MWL = [];
MLWL = [];
LWOST = [];
LLWL = [];
MR = [];

for ii = 1:length(stations)
    file_name = sprintf("%s\\%s_tide_stastics_monthly.txt", p_data.([stations_var{ii}]), stations{ii});
    fid = fopen(file_name, 'w');
    fprintf(fid, "%s Tidal Station Monthly-Stastics\n", stations{ii});
    fprintf(fid, "Month, %5s, %5s, %5s, %5s, %5s, %5s, %5s, %5s\n", var_names{:});
    for kk = 1:12
        fprintf(fid, "%+5s, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f\n", ...
            datestr(datetime(1, kk, 1), 'mmm'), ...
            max(stastics_data.([stations_var{ii}])(kk).HHWL, [], 'omitnan')/1000, ...
            mean(stastics_data.([stations_var{ii}])(kk).HWOST, 'omitnan')/1000, ...
            mean(stastics_data.([stations_var{ii}])(kk).MHWL, 'omitnan')/1000, ...
            mean(stastics_data.([stations_var{ii}])(kk).MWL, 'omitnan')/1000, ...
            mean(stastics_data.([stations_var{ii}])(kk).MLWL, 'omitnan')/1000, ...
            mean(stastics_data.([stations_var{ii}])(kk).LWOST, 'omitnan')/1000, ...
            min(stastics_data.([stations_var{ii}])(kk).LLWL, [], 'omitnan')/1000, ...
            mean(stastics_data.([stations_var{ii}])(kk).MR, 'omitnan')/1000);

        HHWL = [max(stastics_data.([stations_var{ii}])(kk).HHWL, [], 'omitnan')/1000, HHWL];
        HWOST = [mean(stastics_data.([stations_var{ii}])(kk).HWOST, [], 'omitnan')/1000, HWOST];
        MHWL = [mean(stastics_data.([stations_var{ii}])(kk).MHWL, [], 'omitnan')/1000, MHWL];
        MWL = [mean(stastics_data.([stations_var{ii}])(kk).MWL, [], 'omitnan')/1000, MWL];
        MLWL = [mean(stastics_data.([stations_var{ii}])(kk).MLWL, [], 'omitnan')/1000, MLWL];
        LWOST = [mean(stastics_data.([stations_var{ii}])(kk).LWOST, [], 'omitnan')/1000, LWOST];
        LLWL = [min(stastics_data.([stations_var{ii}])(kk).LLWL, [], 'omitnan')/1000, LLWL];
        MR = [mean(stastics_data.([stations_var{ii}])(kk).MR, [], 'omitnan')/1000, MR];
        
    end
    fprintf(fid, "%+5s, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f, %5.2f\n", ...
        "All", ...
        max(HHWL, [], 'omitnan'), ...
        mean(HWOST, 'omitnan'), ...
        mean(MHWL, 'omitnan'), ...
        mean(MWL, 'omitnan'), ...
        mean(MLWL, 'omitnan'), ...
        mean(LWOST, 'omitnan'), ...
        min(LLWL, [], 'omitnan'), ...
        mean(MR, 'omitnan'));
    fclose(fid);
end

