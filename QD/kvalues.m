%% Clear

clc
clear all
close all

%% Data Aggregate
for n=0:3 
    m=n+1;
load(['m2' num2str(n) '1.mat'],'elevData');
elev1 = elevData;
load(['m2' num2str(n) '2.mat'],'elevData');
elev2 = elevData;
load(['m2' num2str(n) '3.mat'],'elevData');
elev3 = elevData;
elev1sig = elev1.signals.values(1:79851);
elev2sig = elev2.signals.values(1:79851);
elev3sig = elev3.signals.values(1:79851);
elev3time = elev3.time(1:79851);
elev4 = mean([elev1sig elev2sig elev3sig],2);
meanelev(:,m) = elev4;
elev3timeav = elev3time(39860:79851);
elev4av = elev4(39860:79851);
elevendmean(:,m)= elev4av;
elev5av = elev4(1:39860);
elevaverage(m) = mean([elev4av]);
figure(1)
% % plot(elev3time,meanelev(:,m))
% hold on;
end 
% title('Plot of Average Elevation Angles for Range of Steps')
% xlabel('Time');
% ylabel('Elevation Angle');
% legend('m20','m21','m22','m2m1');

for m=1:4
figure(2);
plot(elev3timeav, elevendmean(:,m))
hold on
end
title('Estimated Transfer Functions')
xlabel('Time');
ylabel('Elevation Angle');

%% Variables
% topadj=-0.79;
% zetaadj=-0.01;
topadj=-0.3;
zetaadj=-0.04;
kscale = 1.839;
kmax = 0.28;
for m=1:4
%     if m== 1
%         k(m)= kmax/kscale^2;
%     
%     elseif m == 2
%         k(m)= kmax/kscale;
%     
%     elseif m == 3
%         k(m)= kmax;
%     else
%         k(m)= kmax/kscale^3;
%     end
end
% k = [0.0769024700000000,0.141402412000000,0.260000000000000,0.0418238260000000];
k = [0.096057201	0.196088424	0.265	0.04604159];
xyval= [23.9200000000000,30.4000000000000,39.2200000000000,17.4500000000000;20.1100000000000,24.7200000000000,29.9900000000000,15.8100000000000;42.9100000000000,42.9100000000000,42.9800000000000,42.4000000000000;64.9000000000000,65.7950000000000,61.2000000000000,66];
nperiod= 4;
ks = 3;

%% Find 4 Transfer Functions
for m=1:4
offsetdeg(m) = elevaverage(m);
offsetrad = offsetdeg(m)*pi()/180;
T(m) = (xyval(4,m)-xyval(3,m))/nperiod;
wd(m) = 2*pi()/T(m);
logdec(m) = (1/nperiod)*log((xyval(1,m) - offsetdeg(m)) /(xyval(2,m) - offsetdeg(m)));
zeta(m) = logdec(m)./(2*pi());
wn(m) = wd(m)/sqrt(1-(zeta(m)^2));
sigma(m) = zeta(m)*wn(m);
top(m) = wn(m)^2;
sys(m) = tf([(top(m)+topadj)*k(m)],[1 (zeta(m)+zetaadj)*2*wn(m) top(m)+topadj]) %%0.01
[yyrad, tt] = step(sys(m));
yydeg = yyrad.*180/pi();
yyred(:,m) = yydeg(1:177);
yyaveragedeg(m) = mean([yydeg]);
ttred(:,m) = tt(1:177)+40;
yoffset(m) = offsetdeg(m)-yyaveragedeg(m);
% plot(ttred(:,m),yyred(:,m)+yoffset(m),'*');
hold on
end
% legend('m20','m21','m22','m2m1','tfm20','tfm21','tfm22','tfm2m1');

%% Mean TF

offsetdegmean = mean([offsetdeg(m)]);
tmean= mean([T]);
wdmean= mean([wd]);
logdecmean= mean([logdec]);
zetamean= mean([zeta]);
wnmean = mean([wn]);
sigmamean = mean([sigma]);
topmean = mean([top]);
for m= 1:4
sysmean(m) = tf([(topmean+topadj)*k(m)],[1 (zetamean+zetaadj)*2*wnmean topmean+topadj]);
[yyradmean, ttmean] = step(sysmean(m));
yydegmean = yyradmean.*180/pi();
yyredmean = yydegmean(1:120);
yyaveragedegmean = mean([yyaveragedeg]);
ttredmean = ttmean(1:120)+40;
% yoffset = offsetdegmean-yyaveragedegmean;
yoffsetmean = mean([yoffset]);
plot(ttredmean,yyredmean+yoffsetmean,'--');
hold on
end