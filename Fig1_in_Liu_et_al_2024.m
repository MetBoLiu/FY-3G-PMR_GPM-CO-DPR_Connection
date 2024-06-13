%% Figure 1 in Liu et al. 2024
% panels (a)-(e)

% @author: B.Liu (202211030001@nuist.edu.cn)

clear
clc
close all

%% path & setting
% ================== FY-3G PMRL1/ Ascending ==================
filename_FY3GA = 'Path_FY3G_PMRL1\FY3G_PMR--_ORBA_L1_20230808_0901_5000M_V0.HDF';
% ================== FY-3G PMRL1/ Descending ==================
filename_FY3GD = 'Path_FY3G_PMRL1\FY3G_PMR--_ORBD_L1_20230808_0948_5000M_V0.HDF';

% ================== GPM 2ADPR ==================
filename_GPM = 'Path_GPM_2ADPR\2A.GPM.DPR.V9-20211125.20230808-S085655-E102925.053652.V07B.HDF5';

% ================== Color Table ==================
rgb_radar = [  0 255 255;  0 157 255;  0   0 255;  9 130 175;  0 255   0;
      8 175  20; 255 214   0; 255 152   0; 255   0   0; 221   0  27;
    188   0  54; 121   0 109; 121  51 160; 195 163 212; 230 215 238] / 255;

%% read
% ================== FY-3G Ascending ==================
[ScanTime_FY3GA,...
    latKa_FY3GA, lonKa_FY3GA,...
    latKu_FY3GA, lonKu_FY3GA,...
    ZmKa_FY3GA, ZmKu_FY3GA]...
    = FY3G_PMRL1_Read(filename_FY3GA);
latKu_FY3GA = squeeze(latKu_FY3GA(1,:,:));
lonKu_FY3GA = squeeze(lonKu_FY3GA(1,:,:));
latKa_FY3GA = squeeze(latKa_FY3GA(1,:,:));
lonKa_FY3GA = squeeze(lonKa_FY3GA(1,:,:));

% ================== FY-3G Descending ==================
[ScanTime_FY3GD,...
    latKa_FY3GD, lonKa_FY3GD,...
    latKu_FY3GD, lonKu_FY3GD,...
    ZmKa_FY3GD, ZmKu_FY3GD]...
    = FY3G_PMRL1_Read(filename_FY3GD);
latKu_FY3GD = squeeze(latKu_FY3GD(1,:,:));
lonKu_FY3GD = squeeze(lonKu_FY3GD(1,:,:));
latKa_FY3GD = squeeze(latKa_FY3GD(1,:,:));
lonKa_FY3GD = squeeze(lonKa_FY3GD(1,:,:));

% ================== GPM 2ADPR ==================
[ScanTime_GPM,...
    lat_GPM, lon_GPM,...
    ZmKu_GPM, adjFKu_GPM,...
    ZmKa_GPM, adjFKa_GPM]...
    = GPM_2ADPR_Read(filename_GPM);
ZmKu_GPM = ZmKu_GPM + permute( repmat(adjFKu_GPM, [1,1,176]), [3,1,2] );
ZmKa_GPM =  ZmKa_GPM + permute( repmat(adjFKa_GPM, [1,1,176]), [3,1,2] );

%% Figure1
fig1 = figure(1);
set(fig1, 'Unit', 'centimeters', 'Position', [1 1 30 30])

% ================== Orbital Track  ==================
ax = axes('position',[0.08 0.47 0.90 0.52],'FontSize',20);
m_proj('miller','lat',[-77 77]);
hold on
m_coast('color',[0.5 0.5 0.5]);
m_grid('box','on','tickdir','out','linewidth',2.5,'linestyle','none','FontSize',20);
m_scatter(lonKu_FY3GA(30,:), latKu_FY3GA(30,:), 100*1.2041, ScanTime_FY3GA', 'filled');
m_scatter(lonKu_FY3GD(30,:), latKu_FY3GD(30,:), 100*1.2041, ScanTime_FY3GD', 'filled');
m_scatter(lon_GPM(25,:), lat_GPM(25,:), 100, ScanTime_GPM', 'filled');
colormap(turbo)
caxis([datenum([2023,08,08,08,55,00]), datenum([2023,08,08,10,35,00])])
cb = colorbar('horiz', 'Position', [0.10,0.41,0.40,0.02],...
    'Ticks', datenum([2023,08,08,08,55,00]):20/60/24:datenum([2023,08,08,10,35,00]),...
    'TickLabels', {'08:55','09:15','09:35','09:55','10:15','10:35'},...
    'FontSize', 18);
cb.Label.String = 'Time [UTC, on 8 Aug. 2023]';
cb.Label.FontSize = 20;
m_plot([-102 -92], [40 40], 'k-', 'LineWidth', 2.5)
m_plot([-92 -92], [30 40], 'k-', 'LineWidth', 2.5)
m_plot([-102 -92], [30 30], 'k-', 'LineWidth', 2.5)
m_plot([-102 -102], [30 40], 'k-', 'LineWidth', 2.5)
hold off
m_text(-175,73,'(a)','FontSize',22)
m_text(double(lonKu_FY3GA(1,1))-3, double(latKu_FY3GA(1,1))+9, 'FY-3G', 'FontSize', 20)
m_text(double(lon_GPM(49,1))-8, double(lat_GPM(49,1))+10, 'GPM-CO', 'FontSize', 20)

% ================== FY-3G PMR ZmKu/ ZmKa at 3km ==================
ax1 = axes('Position',[0.065, 0.038, 0.27, 0.28],'FontSize',20);
m_proj('Equidistant cylindrical','lon',[-98.8 -93.8],'lat',[33.2 38.2]);
hold on
m_coast('color',[0.5 0.5 0.5]);
m_grid('box','on',...
    'xtick',[],'xlabeldir','middle',...
    'ytick',[],...
    'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
ms = m_pcolor(lonKu_FY3GA, latKu_FY3GA, squeeze(ZmKu_FY3GA(340,:,:)));
set(ms, 'alphadata', ~isnan( squeeze(ZmKu_FY3GA(340,:,:)) ));
colormap(ax1, rgb_radar)
caxis([0 60])
% colorbar
m_plot(lonKu_FY3GA(1,:), latKu_FY3GA(1,:), 'k--', 'LineWidth', 1.5);
m_plot(lonKu_FY3GA(59,:), latKu_FY3GA(59,:), 'k--', 'LineWidth', 1.5);
m_plot(lonKu_FY3GA(18,:), latKu_FY3GA(18,:), 'k-', 'LineWidth', 1.5);
m_plot(lonKu_FY3GA(42,:), latKu_FY3GA(42,:), 'k-', 'LineWidth', 1.5);
m_text(-98.6,37.9,'(b)','FontSize',22)
m_text(-98.6,37.5,{'      PMR'; 'Z_{m,Ku}'},'FontSize',20)
m_grid('box','on',...
    'xtick',-99:2:-94,'xlabeldir','middle',...
    'ytick',33:2:38,...
    'ticklength',0.03,'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
hold off

ax2 = axes('Position',[0.285, 0.038, 0.27, 0.28],'FontSize',20);
m_proj('Equidistant cylindrical','lon',[-98.8 -93.8],'lat',[33.2 38.2]);
hold on
m_coast('color',[0.5 0.5 0.5]);
m_grid('box','on',...
    'xtick',[],'xlabeldir','middle',...
    'ytick',[],'yticklabels',[],...
    'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
ms = m_pcolor(lonKa_FY3GA, latKa_FY3GA, squeeze(ZmKa_FY3GA(340,:,:)));
set(ms, 'alphadata', ~isnan( squeeze(ZmKa_FY3GA(340,:,:)) ));
colormap(ax2, rgb_radar)
caxis([0 60])
% colorbar
m_plot(lonKu_FY3GA(1,:), latKu_FY3GA(1,:), 'k--', 'LineWidth', 1.5);
m_plot(lonKu_FY3GA(59,:), latKu_FY3GA(59,:), 'k--', 'LineWidth', 1.5);
m_plot(lonKu_FY3GA(18,:), latKu_FY3GA(18,:), 'k-', 'LineWidth', 1.5);
m_plot(lonKu_FY3GA(42,:), latKu_FY3GA(42,:), 'k-', 'LineWidth', 1.5);
m_text(-98.6,37.9,'(c)','FontSize',22)
m_text(-98.6,37.5,{'      PMR'; 'Z_{m,Ka}'},'FontSize',20)
m_grid('box','on',...
    'xtick',-99:2:-94,'xlabeldir','middle',...
    'ytick',33:2:38,'yticklabels',[],...
    'ticklength',0.03,'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
hold off

% ================== GPM DPR ZmKu/ ZmKa at 3km ==================
ax3 = axes('Position',[0.505, 0.038, 0.27, 0.28],'FontSize',20);
m_proj('Equidistant cylindrical','lon',[-98.8 -93.8],'lat',[33.2 38.2]);
hold on
m_coast('color',[0.5 0.5 0.5]);
m_grid('box','on',...
    'xtick',[],'xlabeldir','middle',...
    'ytick',[],'yticklabels',[],...
    'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
ms = m_pcolor(lon_GPM, lat_GPM, squeeze(ZmKu_GPM(152,:,:)));
set(ms, 'alphadata', ~isnan( squeeze(ZmKu_GPM(152,:,:)) ));
colormap(ax3, rgb_radar)
caxis([0 60])
% colorbar
m_plot(lon_GPM(1,:), lat_GPM(1,:), 'k--', 'LineWidth', 1.5);
m_plot(lon_GPM(49,:), lat_GPM(49,:), 'k--', 'LineWidth', 1.5);
m_plot(lon_GPM(13,:), lat_GPM(13,:), 'k-', 'LineWidth', 1.5);
m_plot(lon_GPM(37,:), lat_GPM(37,:), 'k-', 'LineWidth', 1.5);
m_grid('box','on',...
    'xtick',-99:2:-94,'xlabeldir','middle',...
    'ytick',33:2:38,'yticklabels',[],...
    'ticklength',0.03,'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
m_text(-94.7,37.9,'(d)','FontSize',22)
m_text(-96.1,37.5,{'DPR'; '   Z_{m,Ku}'},'FontSize',20)
hold off

ax4 = axes('Position',[0.725, 0.038, 0.27, 0.28],'FontSize',20);
m_proj('Equidistant cylindrical','lon',[-98.8 -93.8],'lat',[33.2 38.2]);
hold on
m_coast('color',[0.5 0.5 0.5]);
m_grid('box','on',...
    'xtick',[],'xlabeldir','middle',...
    'ytick',[],'yticklabels',[],...
    'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
ms = m_pcolor(lon_GPM, lat_GPM, squeeze(ZmKa_GPM(152,:,:)));
set(ms, 'alphadata', ~isnan( squeeze(ZmKa_GPM(152,:,:)) ));
colormap(ax4, rgb_radar)
caxis([0 60])
cb4 = colorbar('horiz', 'AxisLocation', 'in', 'Position', [0.57,0.41,0.39,0.02], 'FontSize', 18);
cb4.Label.String = 'Reflectivity [dBZ]';
cb4.Label.FontSize = 20;
m_plot(lon_GPM(1,:), lat_GPM(1,:), 'k--', 'LineWidth', 1.5);
m_plot(lon_GPM(49,:), lat_GPM(49,:), 'k--', 'LineWidth', 1.5);
m_plot(lon_GPM(13,:), lat_GPM(13,:), 'k-', 'LineWidth', 1.5);
m_plot(lon_GPM(37,:), lat_GPM(37,:), 'k-', 'LineWidth', 1.5);
m_grid('box','on',...
    'xtick',-99:2:-94,'xlabeldir','middle',...
    'ytick',33:2:38,'yticklabels',[],...
    'ticklength',0.03,'tickdir','out','linewidth',2.5,'linestyle','none','fontsize',20);
m_text(-94.7,37.9,'(e)','FontSize',22)
m_text(-96.1,37.5,{'DPR';'   Z_{m,Ka}'},'FontSize',20)
hold off

%% Read Function
% ================== FY-3G PMRL1 ==================
function [ScanTime, lat_Ka, lon_Ka, lat_Ku, lon_Ku, Zm_Ka, Zm_Ku]...
    = FY3G_PMRL1_Read(filename_FY3G)

% ------------------ Group '/Geolocation' ------------------
lat_Ka = h5read(filename_FY3G,'/Geolocation/Ka/Latitude');
lat_Ka( lat_Ka <= -9999.9 ) = NaN;
lat_Ku = h5read(filename_FY3G,'/Geolocation/Ku/Latitude');
lat_Ku( lat_Ku <= -9999.9 ) = NaN;

lon_Ka = h5read(filename_FY3G,'/Geolocation/Ka/Longitude');
lon_Ka( lon_Ka <= -9999.9 ) = NaN;
lon_Ku = h5read(filename_FY3G,'/Geolocation/Ku/Longitude');
lon_Ku( lon_Ku <= -9999.9 ) = NaN;

dayC_Ka = h5read(filename_FY3G,'/Geolocation/Ka/dayCount');
dayC_Ka( dayC_Ka <= -9999 ) = NaN;
dayC_Ku = h5read(filename_FY3G,'/Geolocation/Ku/dayCount');
dayC_Ku( dayC_Ku <= -9999 ) = NaN;

msC_Ka = h5read(filename_FY3G,'/Geolocation/Ka/msCount');
msC_Ka( msC_Ka <= -9999 ) = NaN;
msC_Ku = h5read(filename_FY3G,'/Geolocation/Ku/msCount');
msC_Ku( msC_Ku <= -9999 ) = NaN;

DayCountStart = datenum('2000-01-01 12:00:00', 'yyyy-mm-dd HH:MM:SS');
ScanTime = DayCountStart + double(dayC_Ku) + double(msC_Ku*0.1)/1000/60/60/24;

% ------------------ Group '/PRE' ------------------
Zm_Ka = h5read(filename_FY3G,'/PRE/Ka/zFactorMeasured');
Zm_Ka( Zm_Ka <= -9999.9 ) = NaN;
Zm_Ku = h5read(filename_FY3G,'/PRE/Ku/zFactorMeasured');
Zm_Ku( Zm_Ku <= -9999.9 ) = NaN;

end

% ================== GPM 2ADPR ==================
function [ScanTime_FS_2ADPR, lat_FS_2ADPR, lon_FS_2ADPR,...
    ZmKu_FS_2ADPR, adjFKu_FS_2ADPR,...
    ZmKa_FS_2ADPR, adjFKa_FS_2ADPR]...
    = GPM_2ADPR_Read(filename_2ADPR)

% ------------------ Group '/FS/ScanTime' ------------------
Year_FS_2ADPR = h5read(filename_2ADPR,'/FS/ScanTime/Year');
Year_FS_2ADPR( Year_FS_2ADPR <= -9999 ) = NaN;
Month_FS_2ADPR = h5read(filename_2ADPR,'/FS/ScanTime/Month');
Month_FS_2ADPR( Month_FS_2ADPR <= -99 ) = NaN;
Day_FS_2ADPR = h5read(filename_2ADPR,'/FS/ScanTime/DayOfMonth');
Day_FS_2ADPR( Day_FS_2ADPR <= -99 ) = NaN;
Hour_FS_2ADPR = h5read(filename_2ADPR,'/FS/ScanTime/Hour');
Hour_FS_2ADPR( Hour_FS_2ADPR <= -99 ) = NaN;
Minute_FS_2ADPR = h5read(filename_2ADPR,'/FS/ScanTime/Minute');
Minute_FS_2ADPR( Minute_FS_2ADPR <= -99 ) = NaN;
Second_FS_2ADPR = h5read(filename_2ADPR,'/FS/ScanTime/Second');
Second_FS_2ADPR( Second_FS_2ADPR <= -99 ) = NaN;
MilliSecond_FS_2ADPR = h5read(filename_2ADPR,'/FS/ScanTime/MilliSecond');
MilliSecond_FS_2ADPR( MilliSecond_FS_2ADPR <= -9999 ) = NaN;

ScanTime_FS_2ADPR = [Year_FS_2ADPR, Month_FS_2ADPR, Day_FS_2ADPR, Hour_FS_2ADPR, Minute_FS_2ADPR, Second_FS_2ADPR, MilliSecond_FS_2ADPR];
ScanTime_FS_2ADPR = double(ScanTime_FS_2ADPR);
ScanTime_FS_2ADPR = datenum([ScanTime_FS_2ADPR(:,1:5), ScanTime_FS_2ADPR(:,6) + ScanTime_FS_2ADPR(:,7)/1000]);

% ------------------ FS/ Latitude ------------------
lat_FS_2ADPR = h5read(filename_2ADPR,'/FS/Latitude');
lat_FS_2ADPR( lat_FS_2ADPR <= -9999.9 ) = NaN;

% ------------------ FS/ Longitude ------------------
lon_FS_2ADPR = h5read(filename_2ADPR,'/FS/Longitude');
lon_FS_2ADPR( lon_FS_2ADPR <= -9999.9 ) = NaN;

% ------------------ Group '/FS/PRE' ------------------
Zm_FS_2ADPR = h5read(filename_2ADPR,'/FS/PRE/zFactorMeasured');
Zm_FS_2ADPR( Zm_FS_2ADPR <= -9999.9 ) = NaN;
ZmKu_FS_2ADPR = squeeze(Zm_FS_2ADPR(1,:,:,:));
ZmKa_FS_2ADPR = squeeze(Zm_FS_2ADPR(2,:,:,:));

adjF_FS_2ADPR = h5read(filename_2ADPR,'/FS/PRE/adjustFactor');
adjF_FS_2ADPR( adjF_FS_2ADPR<= -9999.9 ) = NaN;
adjFKu_FS_2ADPR = squeeze(adjF_FS_2ADPR(1,:,:));
adjFKa_FS_2ADPR = squeeze(adjF_FS_2ADPR(2,:,:));

end