%% Tidal stations
% 20260831
clear; close all; clc;

%% 東港
station = 'Donggang';
main_folder = ['C:\Users\adm\Desktop\潮位站資料原始資料\', station];
DG = struct();

% ============================ Sea Temperature ============================
dd = dir(fullfile(main_folder, "\stemp\*.txt"));


for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    DG.stemp(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    DG.stemp(ii).dday = datenum(DG.stemp(ii).ddatetime);
    DG.stemp(ii).stemp = df.Var4;
end

% ================================== Tide =================================
dd = dir(fullfile(main_folder, "\tide\*.txt"));
opts = fixedWidthImportOptions('NumVariables', 3);
opts.DataLines = 18;
opts.VariableNames = {'st', 'yyyymmddhh', ...
    '00', '06', '12', '18', '24', '30', '36', '42', '48', '54'};
opts.VariableWidths = [7, 10, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6]; 
opts.VariableTypes = {'string', 'string', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double'};
opts.MissingRule = 'fill';
opts.VariableNamingRule = 'preserve';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, 'ReadVariableNames', false);
    % df = readmatrix(fullfile(dd(ii).folder, dd(ii).name), 'Delimiter', ' ');
    DG.tide(ii).ddatetime = datetime(string(df.yyyymmddhh), 'Inputformat', 'yyyyMMddHH');
    dday_st_yr = DG.tide(ii).ddatetime(1).Year;
    dday_st_mm = DG.tide(ii).ddatetime(1).Month;
    dday_st_dd = DG.tide(ii).ddatetime(1).Day;
    dday_st_hh = DG.tide(ii).ddatetime(1).Hour;
    pres = table2array(df(:, 3:end));
    DG.tide(ii).pres = reshape(pres, numel(pres), 1);
    DG.tide(ii).dday = datenum(dday_st_yr, dday_st_mm, dday_st_dd, dday_st_hh, 0:6:length(DG.tide(ii).pres)*6-6, 0)';
end


save('C:\Users\adm\Desktop\潮位站資料原始資料\Donggang\DG_tide.mat', "DG")


%% 後壁湖
station = 'Houbihu';
main_folder = ['C:\Users\adm\Desktop\潮位站資料原始資料\', station];
HBH = struct();

% ============================ Sea Temperature ============================
dd = dir(fullfile(main_folder, "\stemp\*.txt"));


for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    HBH.stemp(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    HBH.stemp(ii).dday = datenum(HBH.stemp(ii).ddatetime);
    HBH.stemp(ii).stemp = df.Var4;
end

% ================================== Tide =================================
dd = dir(fullfile(main_folder, "\tide\*.txt"));
opts = fixedWidthImportOptions('NumVariables', 3);
opts.DataLines = 18;
opts.VariableNames = {'st', 'yyyymmddhh', ...
    '00', '06', '12', '18', '24', '30', '36', '42', '48', '54'};
opts.VariableWidths = [7, 10, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6]; 
opts.VariableTypes = {'string', 'string', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double'};
opts.MissingRule = 'fill';
opts.VariableNamingRule = 'preserve';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, 'ReadVariableNames', false);
    % df = readmatrix(fullfile(dd(ii).folder, dd(ii).name), 'Delimiter', ' ');
    HBH.tide(ii).ddatetime = datetime(string(df.yyyymmddhh), 'Inputformat', 'yyyyMMddHH');
    dday_st_yr = HBH.tide(ii).ddatetime(1).Year;
    dday_st_mm = HBH.tide(ii).ddatetime(1).Month;
    dday_st_dd = HBH.tide(ii).ddatetime(1).Day;
    dday_st_hh = HBH.tide(ii).ddatetime(1).Hour;
    pres = table2array(df(:, 3:end));
    HBH.tide(ii).pres = reshape(pres, numel(pres), 1);
    HBH.tide(ii).dday = datenum(dday_st_yr, dday_st_mm, dday_st_dd, dday_st_hh, 0:6:length(HBH.tide(ii).pres)*6-6, 0)';
end

file_name = sprintf('C:\\Users\\adm\\Desktop\\潮位站資料原始資料\\%s\\HBH_tide.mat', station);
save(file_name, "HBH")


%% 高雄港
station = 'Kaohsiung';
main_folder = ['C:\Users\adm\Desktop\潮位站資料原始資料\', station];
KHS = struct();

% ============================ Sea Temperature ============================
dd = dir(fullfile(main_folder, "\stemp\*.txt"));


for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    KHS.stemp(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    KHS.stemp(ii).dday = datenum(KHS.stemp(ii).ddatetime);
    KHS.stemp(ii).stemp = df.Var4;
end

% ================================== Tide =================================
dd = dir(fullfile(main_folder, "\tide\*.txt"));
opts = fixedWidthImportOptions('NumVariables', 3);
opts.DataLines = 18;
opts.VariableNames = {'st', 'yyyymmddhh', ...
    '00', '06', '12', '18', '24', '30', '36', '42', '48', '54'};
opts.VariableWidths = [7, 10, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6]; 
opts.VariableTypes = {'string', 'string', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double'};
opts.MissingRule = 'fill';
opts.VariableNamingRule = 'preserve';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, 'ReadVariableNames', false);
    % df = readmatrix(fullfile(dd(ii).folder, dd(ii).name), 'Delimiter', ' ');
    KHS.tide(ii).ddatetime = datetime(string(df.yyyymmddhh), 'Inputformat', 'yyyyMMddHH');
    dday_st_yr = KHS.tide(ii).ddatetime(1).Year;
    dday_st_mm = KHS.tide(ii).ddatetime(1).Month;
    dday_st_dd = KHS.tide(ii).ddatetime(1).Day;
    dday_st_hh = KHS.tide(ii).ddatetime(1).Hour;
    pres = table2array(df(:, 3:end));
    KHS.tide(ii).pres = reshape(pres, numel(pres), 1);
    KHS.tide(ii).dday = datenum(dday_st_yr, dday_st_mm, dday_st_dd, dday_st_hh, 0:6:length(KHS.tide(ii).pres)*6-6, 0)';
end

file_name = sprintf('C:\\Users\\adm\\Desktop\\潮位站資料原始資料\\%s\\KHS_tide.mat', station);
save(file_name, "KHS")


%% 小琉球
station = 'Xialiuqiu';
main_folder = ['C:\Users\adm\Desktop\潮位站資料原始資料\', station];
XLQ = struct();

% ============================ Sea Temperature ============================
dd = dir(fullfile(main_folder, "\stemp\*.txt"));


for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    XLQ.stemp(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    XLQ.stemp(ii).dday = datenum(XLQ.stemp(ii).ddatetime);
    XLQ.stemp(ii).stemp = df.Var4;
end

% ================================== Tide =================================
dd = dir(fullfile(main_folder, "\tide\*.txt"));
opts = fixedWidthImportOptions('NumVariables', 3);
opts.DataLines = 18;
opts.VariableNames = {'st', 'yyyymmddhh', ...
    '00', '06', '12', '18', '24', '30', '36', '42', '48', '54'};
opts.VariableWidths = [7, 10, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6]; 
opts.VariableTypes = {'string', 'string', 'double', 'double', 'double', 'double', 'double', ...
    'double', 'double', 'double', 'double', 'double'};
opts.MissingRule = 'fill';
opts.VariableNamingRule = 'preserve';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, 'ReadVariableNames', false);
    % df = readmatrix(fullfile(dd(ii).folder, dd(ii).name), 'Delimiter', ' ');
    XLQ.tide(ii).ddatetime = datetime(string(df.yyyymmddhh), 'Inputformat', 'yyyyMMddHH');
    dday_st_yr = XLQ.tide(ii).ddatetime(1).Year;
    dday_st_mm = XLQ.tide(ii).ddatetime(1).Month;
    dday_st_dd = XLQ.tide(ii).ddatetime(1).Day;
    dday_st_hh = XLQ.tide(ii).ddatetime(1).Hour;
    pres = table2array(df(:, 3:end));
    XLQ.tide(ii).pres = reshape(pres, numel(pres), 1);
    XLQ.tide(ii).dday = datenum(dday_st_yr, dday_st_mm, dday_st_dd, dday_st_hh, 0:6:length(XLQ.tide(ii).pres)*6-6, 0)';
end

file_name = sprintf('C:\\Users\\adm\\Desktop\\潮位站資料原始資料\\%s\\XLQ_tide.mat', station);
save(file_name, "XLQ")



