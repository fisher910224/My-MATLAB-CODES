%% Temperature
% 20260820 edited
clear; close all; clc;

%% DAPENGBAY
main_folder = 'C:\Users\adm\Desktop\浮標資料原始資料\DapengBay';
p_data = [main_folder, '\processed_data'];
station = 'DapengBay';

if ~isfolder(p_data)
    mkdir(p_data)
end
% ============================ Temperature ================================
dd = dir("C:\Users\adm\Desktop\浮標資料原始資料\DapengBay\Temp\*.txt");
DPB = struct();

for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    DPB.temp(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    DPB.temp(ii).dday = datenum(DPB.temp(ii).ddatetime);
    DPB.temp(ii).temp = df.Var4;
end

% ================================ Wind ===================================
dd = dir("C:\Users\adm\Desktop\浮標資料原始資料\DapengBay\wind\*.txt");
for ii = 1:length(dd)
    df = readtable(fullfile(dd(ii).folder, dd(ii).name), "ReadVariableNames", false);
    DPB.wind(ii).ddatetime = datetime(string(df.Var2), 'Inputformat', 'yyyyMMddHHmm');
    DPB.wind(ii).dday = datenum(DPB.wind(ii).ddatetime);
    DPB.wind(ii).WSm = df.Var4;
    DPB.wind(ii).Dirm = df.Var5;
    DPB.wind(ii).WSmax = df.Var6;
    DPB.wind(ii).Beaufort_scale = df.Var7;
    DPB.wind(ii).Beaufort_scale_max = df.Var8;
end


save C:\Users\adm\Desktop\浮標資料原始資料\DapengBay\DPB.mat DPB


%% 


max_values = [];
mean_WS_values = [];
max_idx = [];

% min_values = [];
for ii = 1:length(DPB.wind)
    for month_number = 1:12
        try
            [max_values(ii, month_number), max_idx(ii, month_number)] = max(DPB.wind(ii).WSmax(DPB.wind(ii).ddatetime.Month == month_number));
            mean_WS_values(ii, month_number) = mean(DPB.wind(ii).WSm(DPB.wind(ii).ddatetime.Month == month_number));
            % min_values(ii, month_number) = min(DPB.temp(ii).temp(DPB.temp(ii).datetime.Month == month_number));
        catch ME
            fprintf('Error: %.0f %s\n', ME.message)
            continue
        end
    end
end





