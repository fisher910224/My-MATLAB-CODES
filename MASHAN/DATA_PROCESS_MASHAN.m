clear; close all; clc; 

% the most important is ctrl+F find date of variable name (e.g. dday"_20260406"), 
% and click triangle of left-hand-side of "Find"
% then "Replace All" the dates as your NOW date (e.g. Find "_20260101" -> Replace as "_20260406", then click "Replace All")

%% 20260817 edited
main_folder = "C:\Users\adm\Desktop\Mashan\2023\QC\Mashan";
cd(main_folder)
dd = dir("C:\Users\adm\Desktop\Mashan\2023\QC\Mashan\2023*");

% target_items = ['Cur', '']
C = struct();
W = struct();
% file_table = [];
flags_table = [];
Layers = ["Bot"; "Mid"; "Top"];
wave_items = ["Dir"; "Hs"; "Tp"];

for ii = 1:length(dd)
    % tt = datetime(dd(ii).name, 'InputFormat', 'yyyyMM');
    % file_name = sprintf("%s", datestr(tt, 'mmm'));
    aim_folder = dd(ii).name; % naming the main folder path
    % ===================== DATA PROCESS =====================
    % cd([aim_folder,'\AQP']) % Change Direction to this folder
    cd(main_folder + '\' + dd(ii).name)
    
    try
        df_name = dir("*CurVel*");
        for kk = 1:length(df_name)
            df = readtable(df_name(kk).name, 'Delimiter', ',', 'ReadVariableNames', false);
            if kk == 1; dday_datetime = datetime(df.Var2, "InputFormat", "yyyyMMdd HH:mm:ss"); C(ii).dday(:, 1) = datenum(dday_datetime); end
            C(ii).Cur(:, kk) = df.Var3;
            C(ii).(((Layers(kk)) + "_Vel_flag")) = table2array(df(:, 4:end));
        end

        df_name = dir("*CurDir*");
        for kk = 1:length(df_name)
            df = readtable(df_name(kk).name, 'Delimiter', ',', 'ReadVariableNames', false);
            C(ii).Dir(:, kk) = df.Var3;
            C(ii).(((Layers(kk)) + "_Dir_flag")) = table2array(df(:, 4:end));
        end
        
        df_name = dir("*Sealevel*");
        for kk = 1:length(df_name)
            df = readtable(df_name(kk).name, 'Delimiter', ',', 'ReadVariableNames', false);
            C(ii).Pre(:, kk) = df.Var3;
            C(ii).SL_flag = table2array(df(:, 4:end));
        end
    
        df_name = dir("*Wave*");
        
        for kk = 1:length(df_name)
            df = readtable(df_name(kk).name, 'Delimiter', ',', 'ReadVariableNames', false);
            if kk == 1; dday_datetime = datetime(df.Var2, "InputFormat", "yyyyMMdd HH:mm:ss"); W(ii).waveday(:, 1) = datenum(dday_datetime); end
            W(ii).((wave_items(kk))) = df.Var3;
            W(ii).(((wave_items(kk)) + "_flag")) = table2array(df(:, 4:end));
        end
        fprintf("  [Success!] Read folder %s success!\n", dd(ii).name);

    catch ME
        fprintf('  [錯誤] 讀取 %s 失敗: %s\n', df_name(kk).name, ME.message);
        break
    end
    
end

saving_str = sprintf("%s\\QC_DATA.mat", main_folder);
save(saving_str, "C", "W", "-mat");
fprintf("Saving Data in %s\n", main_folder);


%% wind
% downloading data by webside "CODiS" (https://codis.cwa.gov.tw/Login?locale=zh-TW)
% cd([aim_folder,'\wind'])
% winddata = readmatrix('lotsDataReports.txt'); % reading data as a matrix
% [nicewind] = find(~isnan(winddata(:,1))); % sometimes the data has NaN values when your original data has ENGLISH and NUMBERS at the same time
% 
% % judging if the data has NaN value
% if any(isnan(winddata(:,1)))
%     wi_20260406 = winddata;
% else
%     wi_20260406 = winddata(nicewind,1:width(winddata));
% end
% 
% wind_st_20260406 = find(wi_20260406(:,2)==str2double(datestr(N.dday_20260406(1), 'yyyymmddHH'))); % start of wind data
% 
% % judging if the data has NaN value again
% if any(isnan(wi_20260406(:,7)))
%     wu_20260406=-wi_20260406(wind_st_20260406:N.N.wavedaylength_20260406+wind_st_20260406-1,4).*sind(wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,5)); % U分量 風為來向加負號變去向
%     wv_20260406=-wi_20260406(wind_st_20260406:N.N.wavedaylength_20260406+wind_st_20260406-1,4).*cosd(wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,5)); % V分量 風為來向加負號變去向
%     rain_20260406 = wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,6); % rainfall of the weather station
%     atm_st_20260406 = wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,3); % atmospheric pressure of the station
%     atm_sea_20260406 = [];
% else
%     wu_20260406=-wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,5).*sind(wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,6)); % U分量 風為來向加負號變去向
%     wv_20260406=-wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,5).*cosd(wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,6)); % V分量 風為來向加負號變去向
%     rain_20260406 = wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,7);
%     atm_st_20260406 = wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,3);
%     atm_sea_20260406 = wi_20260406(wind_st_20260406:N.wavedaylength_20260406+wind_st_20260406-1,4); % atmospheric pressure of the nearest sea
% end
% 
% 
% %% Saving data as .mat file type
% cd(aim_folder)
% % save DATA_WIND.mat atm_sea atm_st rain wv wu wi
% save DATA_WIND.mat rain_20260406 wv_20260406 wu_20260406 wi_20260406 atm_st_20260406 atm_sea_20260406


