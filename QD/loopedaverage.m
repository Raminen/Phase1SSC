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
elevaverage1(m) = mean([elev5av]);
figure(1)
plot(elev3time,meanelev(:,m))
hold on;
end 
title('Plot of Average Elevation Angles for Range of Steps')
xlabel('Time');
ylabel('Elevation Angle');
legend('m20','m21','m22','m2m1');

for m=1:4
figure(2);
plot(elev3timeav, elevendmean(:,m))
hold on
end

%% Means
k = (elevaverage(3)-elevaverage1(3))/4;
krad = k*pi()/180;


%% Transfer Function Variables

offsetdeg = elevaverage(3);
offsetrad = offsetdeg*pi()/180;

nperiod= 4;
T = (-42.98+61.2)/nperiod;
wn = 2*pi()/T;
logdec = (1/nperiod)*log((39.22 - offsetdeg) /(29.99 - offsetdeg));
zeta = logdec/(2*pi());
wd = wn*sqrt(1-(zeta^2));
sigma = zeta*wn;
top = wn^2;

%% Transfer Function
sys = tf([top],[top zeta*2*wn top]);
[yyrad, tt] = impulse(sys);
figure(3)
yydeg = yyrad*180/pi();
yyaveragedeg = mean([yydeg]);
yyaveragerad = mean([yyrad]);
% Change between deg and rad
plot(tt+1.41,yyrad+offsetrad-yyaveragerad);
hold on
elev40 = meanelev(:,3);
elev40 = elev40(39860:79851).*pi()./180;
tp = 40/(79851-39860);
time = 0:tp:40;
% plot(elev3time,meanelev(:,3));
plot(time,elev40);

 
 %% Underdamped Y plot
i = 0;
for t = 0:0.001:80
    i = i+1;
y(i)= 1-exp(-sigma*t)*cos(wd*t)-(zeta/sqrt(1-zeta^2))*exp(-sigma*t)*sin(wd*t);
end
 y = y';
 yaverage = mean([y]);
 t = 0:0.001:80;
 figure(4)
 plot(t,y+offsetdeg-yaverage);
 hold on
% plot(elev3time,meanelev(:,3));
 plot(time,elev40);
