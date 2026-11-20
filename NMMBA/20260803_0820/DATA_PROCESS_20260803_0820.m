clear; close all; clc; 

% the most important is ctrl+F find date of variable name (e.g. dday"_20260803"), 
% and click triangle of left-hand-side of "Find"
% then "Replace All" the dates as your NOW date (e.g. Find "_20260101" -> Replace as "_20260803", then click "Replace All")

%% 20260827 edited
aim_folder = 'C:\Users\adm\Desktop\INTERTIDAL\代婷與的PDF們\NMMBA\20260803_0820'; % naming the main folder path
% ===================== DATA PROCESS =====================
cd([aim_folder,'\AQP']) % Change Direction to this folder
filecsv = dir("*.csv"); % find file type is .csv in this folder
AQP_N = readtable(filecsv(1).name, 'Delimiter', ';', 'ReadVariableNames', false); 
% read the AQP data as a table, with the file name filecsv(1).name 

% st = 1; % which one is the first useful data
ig = find(AQP_N.Var6 > 15); % 找水深>12的資料點 finding datasets which water level > 12 m
% ig = ig(2:end); % first data has a issue (maybe velocity is too large)
N.dates_20260803 = datetime(AQP_N.Var1(ig), 'InputFormat', 'yyyy/MM/dd HH:mm:SS'); % turn the date data in .csv as matlab's data type
N.dday_20260803 = datenum(N.dates_20260803); % turning the datetime data type to double, so we can "calculate" date data

% ig = find(N.dday_20260803 < datenum(2026, 1, 2));
% N.dday_20260803 = N.dday_20260803(ig);

N.daym_20260803 = N.dday_20260803(1:6:end); % hour-averaged date data

N.waveday_20260803 = N.daym_20260803; % hour-averaged date data, but different name
N.wavedaylength_20260803 = length(N.waveday_20260803); % length of waveday_********

N.plotdate_all_20260803 = [datestr(floor(N.waveday_20260803(1)), 'yyyy/mm/dd'), '~', datestr(N.waveday_20260803(N.wavedaylength_20260803),'mm/dd') ]; % figure plot minor title
N.filedate_20260803 = [datestr(N.dates_20260803(1), 'yyyymmdd'), '_', datestr(N.waveday_20260803(N.wavedaylength_20260803),'mmdd') ,'_']; % date title of saving plot picture
N.datelabel_20260803 = datestr(floor(N.waveday_20260803(1)):4:ceil(N.waveday_20260803(N.wavedaylength_20260803)), 'mm/dd'); % X axis tick labels

% ==================== Pre =====================
N.Pre_20260803 = table2array(AQP_N(ig, 6)); % water level (m)
N.day_i = 4; % day interval (a tick for 4 days)

% =================== Cur ======================
N.Cur_20260803 = table2array(AQP_N(ig, 10:2:end)); % turning the table data of current speed to double data type
N.Dir_20260803 = table2array(AQP_N(ig, 11:2:end)); % turning the table data of current direction to double data type

% ================== Spectial ==================
% N.Cur_20260803(N.Cur_20260803>1) = mean(N.Cur_20260803(:,11)); % sometimes the data has some issues, so we need to turn the error datas to a "more normal" data
% N.Dir_20260803(N.Cur_20260803>1) = mean(N.Dir_20260803(:,11)); 

N.u_20260803 = N.Cur_20260803.*sind(N.Dir_20260803); % U direction velocity component
N.v_20260803 = N.Cur_20260803.*cosd(N.Dir_20260803); % V direction velocity component

tur_AQP_20260803 = table2array(AQP_N(ig,9)); % turning the table data of turbidity to double data type
tur_AQPhigh_20260803 = table2array(AQP_N(ig,8)); % turning another table data of turbidity to double data type (higher one)
N.tur_20260803 = -6.763*0.01*(tur_AQP_20260803*5/65536).^2+5.21*10*(tur_AQP_20260803*5/65536)-0.04731; %T8535,250/1000 % calculate the "AnalogiIn" data into calibration turbidity 
N.tur_high_20260803 = 1.631*10*(tur_AQPhigh_20260803*5/65536).^2+1.886*100*(tur_AQPhigh_20260803*5/65536)+1.126*0.1;

%% Remove beam 1
% AQP_P = readtable(filecsv(2).name, 'Delimiter', ';', 'ReadVariableNames', false);
% 
% Cur_20260803(:,1:5) = table2array(AQP_P(st:length(dday_20260803)+st-1,10:2:18));
% Dir_20260803(:,1:5) = table2array(AQP_P(st:length(dday_20260803)+st-1,11:2:19));
% 
% u_20260803 = Cur_20260803.*sind(Dir_20260803);
% v_20260803 = Cur_20260803.*cosd(Dir_20260803);

%% 20250310 (for station S)
% ===================== DATA PROCESS =====================
% most parts same as N station
AQP_S = readtable(filecsv(2).name, 'Delimiter', ';', 'ReadVariableNames', false);
ig = find(AQP_S.Var6 > 15);
ig = ig(6:end);
S.dates_20260803 = datetime(AQP_S.Var1, 'InputFormat', 'yyyy/MM/dd HH:mm:SS');

% st = 1; % which one is the first useful data
% ig = find(AQP_N.Var6 > 12);
S.dday_20260803 = datenum(S.dates_20260803(ig)); % end of the data

S.daym_20260803 = S.dday_20260803(1:6:end);

S.waveday_20260803 = S.daym_20260803;
S.wavedaylength_20260803 = length(S.waveday_20260803);

% ==================== Pre =====================
S.Pre_20260803 = table2array(AQP_S(ig,6));
% day_i = 4;

% =================== Cur ======================
S.Cur_20260803 = table2array(AQP_S(ig,10:2:end));
S.Dir_20260803 = table2array(AQP_S(ig,11:2:end));

S.u_20260803 = S.Cur_20260803.*sind(S.Dir_20260803);
S.v_20260803 = S.Cur_20260803.*cosd(S.Dir_20260803);

tur_AQP_20260803 = table2array(AQP_S(ig,9));
tur_AQPhigh_20260803 = table2array(AQP_S(ig,8));
% S.tur_20260803 = 2.4708*(tur_AQP_20260803*5/65536).^2+8.7973*10*(tur_AQP_20260803*5/65536)-0.24683;    %T9469,500/2000
S.tur_high_20260803 = 5.1048*10*(tur_AQPhigh_20260803*5/65536).^2+3.3873*100*(tur_AQPhigh_20260803*5/65536)+1.0805*0.1;
% S.tur_20260803 = 2.4708*10^6*(tur_AQP_20260803*5/65536).^2+8.7973*10^4*(tur_AQP_20260803*5/65536)-0.24683;    %T9469,500/2000
S.tur_20260803 = 8.9741*(tur_AQP_20260803*5/65536).^2+1.6016*10^2*(tur_AQP_20260803*5/65536)-0.43604;    %T9475,1000/4000

%% Saving data as .mat file type
cd(aim_folder)
% save DATA_CUR.mat Cur_20260803 dates_20260803 day_i daym_20260803 dday_20260803 Dir_20260803 Pre_20260803 tur_20260803 u_20260803 v_20260803 waveday_20260803 wavedaylength_20260803 tur_high_20260803 Cur_20260803_S dates_20260803_S daym_20260803_S dday_20260803_S Dir_20260803_S Pre_20260803_S tur_20260803_S u_20260803 v_20260803 waveday_20260803_S wavedaylength_20260803 tur_high_20260803_S
save DATA_CUR.mat N S

%% 
cd([aim_folder, '\S770']) % Changing Direction to folder of S770
% wave = load ("15Jun02184755.ord");

% 讀取 .ord 檔案
w_ord = dir("*.ord"); % find datasets type which is .ord (wave data)
fid_in = fopen(w_ord(1).name, 'r'); % open file with 'r', which means "reading data"
% fid_in2 = fopen("15Jun02190000.ord", "r");
data = fread(fid_in, '*char')'; % reading every char in this file
% data2 = fread(fid_in2, '*char')';
fclose(fid_in); % fopen needs fclose

% 寫入 .txt 檔案
fid_out = fopen('N_Sta_waveheight.txt', 'w');
fwrite(fid_out, data);
% fwrite(fid_out, data2);
fclose(fid_out);

%% 
% 打開檔案
fid = fopen('N_Sta_waveheight.txt', 'r');

% 讀取前i行但不存儲
for i = 1:15
    tline = fgetl(fid);
    if contains(tline, 'Interval (Min)') % finding which line has text "Interval (Min)"
        interval_20260803 = sscanf(tline, '%*s %*s %*s %f'); % scan the string and record it
    elseif contains(tline, 'Burst Number(N)') % this one always has error, needing to pay attention
        Burstnumber_20260803 = sscanf(tline, '%*s %*s %*s %f');
    elseif contains(tline, 'Burst Rate')
        Burstrate_20260803 = sscanf(tline, '%*s %*s %*s %*s %f');
    end
end

% 讀取第18行開始的數據
wave_20260803 = textscan(fid, '%f', 'Delimiter', ' '); % scaning the datas which is wave height data ("Delimiter" is "space")

% 關閉檔案
fclose(fid);
% length(wave{1})/1202

wave_20260803 = reshape(wave_20260803{1}(1:end-mod(length(wave_20260803{1}),1202)), [1202 floor(length(wave_20260803{1})/1202)])'; % 根據實際列數調整 (burst numbers = 1200)
ig = wave_20260803(:, 3) >= 15 & wave_20260803(:, end) >= 15; % find datas which is > 15 m (wave height data based on changing of water level)
wave_20260803 = wave_20260803(ig, :);

% wave_20260803 = wave_20260803(1:length(N.daym_20260803), :);


%% S_station(other season dont need)

cd([aim_folder, '\S770'])
% wave = load ("15Jun02184755.ord");

% 讀取 .ord 檔案
w_ord = dir("*.ord");
fid_in = fopen(w_ord(2).name, 'r'); % must to open the varia to see which one is s station
% fid_in2 = fopen("15Jun02190000.ord", "r");
% fid_in2 = fopen(w_ord(3).name, 'r');
data = fread(fid_in, '*char')'; 
% data2 = fread(fid_in2, '*char')';
fclose(fid_in);

% 寫入 .txt 檔案
fid_out = fopen('S_Sta_waveheight.txt', 'w');
fwrite(fid_out, data);
% fwrite(fid_out, data2);
fclose(fid_out);
%% 
fid = fopen('S_Sta_waveheight.txt', 'r');

% 讀取前17行但不存儲
for i = 1:15
    tline = fgetl(fid);
    if contains(tline, 'Interval (Min)')
        interval_20260803 = sscanf(tline, '%*s %*s %*s %f');
    elseif contains(tline, 'Burst Number(N)')
        Burstnumber_20260803 = sscanf(tline, '%*s %*s %*s %f');
    elseif contains(tline, 'Burst Rate')
        Burstrate_20260803 = sscanf(tline, '%*s %*s %*s %*s %f');
    end
end

% 讀取第18行開始的數據
wave_20260803_S = textscan(fid, '%f', 'Delimiter', ' ');

% 關閉檔案
fclose(fid);
% length(wave{1})/1202

wave_20260803_S = reshape(wave_20260803_S{1}(1:end-mod(length(wave_20260803_S{1}),1202)), [1202 floor(length(wave_20260803_S{1})/1202)])'; % 根據實際列數調整
ig = find(wave_20260803_S(:, 3) >= 15 & wave_20260803_S(:, end) >= 15);
wave_20260803_S = wave_20260803_S(ig, :);

% wave_20260803_S = wave_20260803_S(1:length(S.daym_20260803), :);


%% Wave S
% XX = randi([80 110], height(wave_20260803), width(wave_20260803))/100;
% wave_20260803_S = wave_20260803.*XX;
% XX = randi([70 110], height(wave_20260803), 1)/100;

%% Saving data as .mat file type
cd(aim_folder)
% save DATA_W.mat wave_20260803 wave_20250216_S
save DATA_W.mat wave_20260803_S wave_20260803 


%% wind
% downloading data by webside "CODiS" (https://codis.cwa.gov.tw/Login?locale=zh-TW)
cd([aim_folder,'\wind'])
winddata = readmatrix('lotsDataReports.txt'); % reading data as a matrix
[nicewind] = find(~isnan(winddata(:,1))); % sometimes the data has NaN values when your original data has ENGLISH and NUMBERS at the same time

% judging if the data has NaN value
if any(isnan(winddata(:,1)))
    wi_20260803 = winddata;
else
    wi_20260803 = winddata(nicewind,1:width(winddata));
end

wind_st_20260803 = find(wi_20260803(:,2)==str2double(datestr(N.dday_20260803(1), 'yyyymmddHH'))); % start of wind data

% judging if the data has NaN value again
if any(isnan(wi_20260803(:,7)))
    wu_20260803=-wi_20260803(wind_st_20260803:N.N.wavedaylength_20260803+wind_st_20260803-1,4).*sind(wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,5)); % U分量 風為來向加負號變去向
    wv_20260803=-wi_20260803(wind_st_20260803:N.N.wavedaylength_20260803+wind_st_20260803-1,4).*cosd(wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,5)); % V分量 風為來向加負號變去向
    rain_20260803 = wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,6); % rainfall of the weather station
    atm_st_20260803 = wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,3); % atmospheric pressure of the station
    atm_sea_20260803 = [];
else
    wu_20260803=-wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,5).*sind(wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,6)); % U分量 風為來向加負號變去向
    wv_20260803=-wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,5).*cosd(wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,6)); % V分量 風為來向加負號變去向
    rain_20260803 = wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,7);
    atm_st_20260803 = wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,3);
    atm_sea_20260803 = wi_20260803(wind_st_20260803:N.wavedaylength_20260803+wind_st_20260803-1,4); % atmospheric pressure of the nearest sea
end


%% Saving data as .mat file type
cd(aim_folder)
% save DATA_WIND.mat atm_sea atm_st rain wv wu wi
save DATA_WIND.mat rain_20260803 wv_20260803 wu_20260803 wi_20260803 atm_st_20260803 atm_sea_20260803


