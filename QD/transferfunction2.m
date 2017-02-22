%% Clear
clc
clear all
close all
%% Means

meanelev = meanelev();
elevaverage = 26.216810576567050;
elevaverage1 = 11.8187012933157;
k = (elevaverage-elevaverage1)/4;
krad = k*pi()/180;

%% Transfer Function Variables

offsetdeg = elevaverage;
offsetrad = offsetdeg*pi()/180;

k= [0.0769024700000000,0.141402412000000,0.260000000000000,0.0418238260000000];
xyval= [23.9200000000000,30.4000000000000,39.2200000000000,17.4500000000000;20.1100000000000,24.7200000000000,29.9900000000000,15.8100000000000;42.9100000000000,42.9100000000000,42.9800000000000,42.4000000000000;64.9000000000000,65.7950000000000,61.2000000000000,66];

nperiod= 4;
T = (xyval(4,3)-xyval(3,3))/nperiod;
wd = 2*pi()/T;
logdec = (1/nperiod)*log((39.22 - offsetdeg) /(29.99 - offsetdeg));
zeta = logdec/(2*pi());
wn = wd/sqrt(1-(zeta^2));
sigma = zeta*wn;
top = wn^2;

%% Transfer Function

% opt = stepDataOptions('InputOffset',0,'StepAmplitude',0.238);
% sys = tf([top],[1 zeta*2*wn top]);

opt = stepDataOptions('InputOffset',0,'StepAmplitude',0.26);
sys = tf([(top-0.79)],[1 (zeta+0.007)*2*wn top-0.79]); %%0.01

[yyrad, tt] = step(sys,opt);
yydeg = yyrad*180/pi();

% figure(1);5
% plot(tt,yydeg);

yyaveragedeg = mean([yydeg]);
yyaveragerad = mean([yyrad]);
yyred = yydeg(1:177);
ttred = tt(1:177);
% Change between deg and rad
figure(2)

plot(ttred,yyred+offsetdeg-yyaveragedeg);
hold on
elev40 = meanelev(:,3);
elev40 = elev40(39860:79851);
tp = 40/(79851-39860);
time = 0:tp:40;
% plot(elev3time,meanelev(:,3));
plot(time,elev40);
% plot([0 elevaverage], [time(end) elevaverage]);

%% Underdamped Y plot
% i = 0;
% for t = 0:0.001:40
%     i = i+1;
% y(i)= 1-exp(-sigma*t)*cos(wd*t)-(zeta/sqrt(1-zeta^2))*exp(-sigma*t)*sin(wd*t);
% end
%  y = y';
%  yaverage = mean([y]);
%  t = 0:0.001:40;
%  plot(t,y+offsetdeg-yaverage);
%  hold on
% % plot(elev3time,meanelev(:,3));
%  plot(time,elev40);
