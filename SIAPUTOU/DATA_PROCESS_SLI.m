%% Temperature
% 20260821 edited
clear; close all; clc;

main_folder = 'C:\Users\adm\Desktop\浮標資料原始資料\Xiaoliuqiu\';
searchKey = 'temp';
file_name_txt = "*" + searchKey + ".txt";
dd_txt = dir(fullfile(main_folder, file_name_txt));

%% 小琉球
% p_data = [main_folder, '\processed_data'];
% station = 'DapengBay';
% 
% if ~isfolder(p_data)
%     mkdir(p_data)
% end
% ============================ Temperature ================================
dd = dir(fullfile(main_folder, "\temp\*.txt"));
XLQ = struct();
opts = fixedWidthImportOptions('NumVariables', 4);
opts.DataLines = 14;
opts.VariableNames = {'st', 'yyyymmddhhmi', 'Z', 'T'};
opts.VariableWidths = [7, 14, 2, 5]; 
opts.VariableTypes = {'string', 'string', 'double', 'double'};
opts.MissingRule = 'fill';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, "ReadVariableNames", false);
    XLQ.temp(ii).ddatetime = datetime(string(df.yyyymmddhhmi), 'Inputformat', 'yyyyMMddHHmm');
    XLQ.temp(ii).dday = datenum(XLQ.temp(ii).ddatetime);
    XLQ.temp(ii).temp = df.T;
end

% ============================ Sea Temperature ============================
dd = dir(fullfile(main_folder, "\stemp\*.txt"));
% XLQ = struct();

for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    XLQ.stemp(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    XLQ.stemp(ii).dday = datenum(XLQ.stemp(ii).ddatetime);
    XLQ.stemp(ii).stemp = df.Var4;
end



% ================================ Wind ===================================
dd = dir(fullfile(main_folder, "\wind\*.txt"));
opts = fixedWidthImportOptions('NumVariables', 8);
opts.DataLines = 17;
opts.VariableNames = {'st', 'yyyymmddhhmi', 'Z', 'Vm', 'Dm', 'Vg', 'Vms', 'Vgs'};
opts.VariableWidths = [7, 14, 4, 5, 4, 4, 4, 4]; 
opts.VariableTypes = {'string', 'string', 'double', 'double', 'double', 'double', 'double', 'double'};
opts.MissingRule = 'fill';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    XLQ.wind(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    XLQ.wind(ii).dday = datenum(XLQ.wind(ii).ddatetime);
    XLQ.wind(ii).WSm = df.Var4;
    XLQ.wind(ii).Dirm = df.Var5;
    XLQ.wind(ii).WSmax = df.Var6;
    XLQ.wind(ii).Beaufort_scale = df.Var7;
    XLQ.wind(ii).Beaufort_scale_max = df.Var8;
end



% ================================ Wave ===================================
dd = dir(fullfile(main_folder, "\wave\*.txt"));
% dd = dir(fullfile(main_folder, "\wave\*.csv"));
opts = fixedWidthImportOptions('NumVariables', 6);
opts.DataLines = 17;
opts.VariableNames = {'st', 'yyyymmddhhmi', 'H', 'T', 'Tmean', 'D'};
opts.VariableWidths = [7, 14, 4, 4, 6, 4]; 
opts.VariableTypes = {'string', 'string', 'double', 'double', 'double', 'double'};
opts.MissingRule = 'fill';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, 'ReadVariableNames', false);
    % df = readmatrix(fullfile(dd(ii).folder, dd(ii).name), 'Delimiter', ' ');
    XLQ.wave(ii).ddatetime = datetime(string(df.yyyymmddhhmi), 'Inputformat', 'yyyyMMddHHmm');
    XLQ.wave(ii).dday = datenum(XLQ.wave(ii).ddatetime);
    XLQ.wave(ii).H = df.H;
    XLQ.wave(ii).T = df.T/10;
    XLQ.wave(ii).Tmean = df.Tmean/10;
    XLQ.wave(ii).Dir = df.D;
end


% ================================ Current ================================
dd = dir(fullfile(main_folder, "\cur\*.txt"));
opts = fixedWidthImportOptions('NumVariables', 5);
opts.DataLines = 17;
opts.VariableNames = {'st', 'yyyymmddhhmi', 'Z', 'V', 'D'};
opts.VariableWidths = [7, 14, 4, 6, 4]; 
opts.VariableTypes = {'string', 'string', 'double', 'double', 'double'};
opts.MissingRule = 'fill';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, 'ReadVariableNames', false);
    % df = readmatrix(fullfile(dd(ii).folder, dd(ii).name), 'Delimiter', ' ');
    XLQ.cur(ii).ddatetime = datetime(string(df.yyyymmddhhmi), 'Inputformat', 'yyyyMMddHHmm');
    XLQ.cur(ii).dday = datenum(XLQ.cur(ii).ddatetime);
    XLQ.cur(ii).Cur = df.V;
    XLQ.cur(ii).Dir = df.D;
end

% ================================ Pressure ===============================
dd = dir(fullfile(main_folder, "\pres\*.txt"));
opts = fixedWidthImportOptions('NumVariables', 3);
opts.DataLines = 17;
opts.VariableNames = {'st', 'yyyymmddhhmi', 'P'};
opts.VariableWidths = [7, 12, 7]; 
opts.VariableTypes = {'string', 'string', 'double'};
opts.MissingRule = 'fill';
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), opts, 'ReadVariableNames', false);
    % df = readmatrix(fullfile(dd(ii).folder, dd(ii).name), 'Delimiter', ' ');
    XLQ.pres(ii).ddatetime = datetime(string(df.yyyymmddhhmi), 'Inputformat', 'yyyyMMddHHmm');
    XLQ.pres(ii).dday = datenum(XLQ.pres(ii).ddatetime);
    XLQ.pres(ii).pres = df.P;
end


save C:\Users\adm\Desktop\浮標資料原始資料\Xiaoliuqiu\XLQ.mat XLQ






