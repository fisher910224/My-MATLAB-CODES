clear; close all; clc;

%% PATH
p_data = "C:\Users\adm\Desktop\Kaohsiung\processed_data";


station = "Fengbitou";


%% Codis data processing
weather = load_codis_weather("C:\Users\adm\Desktop\Codis天氣資料\鳳鼻頭\");

%% 
stb = statistics_max_mean_min_monthly(weather.ddatetime, weather.TX01, station, ...
    "Seasonal", "off", "OutputPath", p_data);


statistics_wind(weather.ddatetime, weather.WD01, weather.WD02, station, "OutputPath", p_data);

df_str = sprintf("%s_pres_statistics.csv", station);
statistics_max_mean_min_monthly(weather.ddatetime, weather.PS01, station, ...
    "Seasonal", "off", "OutputPath", p_data, "FileName", df_str);

df_str = sprintf("%s_rainfall_statistics.csv", station);
statistics_max_mean_min_monthly_rainfall(weather.ddatetime, weather.PP01, station, "OutputPath", p_data, "FileName", df_str);

