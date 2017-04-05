close all force;
clear all;
clc;

%% 2nd Order Transfer Function
%tf([1.109],[1 0.1313 1.109])
%-2 to 2, 0.26

%including our observed k from previous task and degree converter
num=[0.26*1.109*180/pi()];
den=[1 0.1313 1.109];
A = tf(num,den);
t = 0:0:100;

set(0,'DefaultFigureWindowStyle','docked') %% Dock all figures
set(0,'defaultfigurecolor',[1 1 1]) % Set bacground colour to white
set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultTextFontSize', 18)

figure(1)
step(A, t)

%% Gain iterating
i = 1;

c = 0;
stepp=0.01;
gg = (0.01:stepp:0.1);
maxgg=max(gg);
mingg=min(gg);
Legend=cell(length(gg),1);
   
   for p=1:length(gg)
     Legend{p}=num2str(gg(p));
   end

%1a, the effect of varying prop gain, Kp
for G = mingg:stepp:maxgg
    
     %Generating Root Locus
     Kp= G;
     sim('P.slx',[0 100])
     Cp = pid(Kp);
     Tp = feedback(Cp*A,1);
     stepinfoKP(i) = stepinfo(Tp);
     
     figure(51)
     plot(P);
     title('P - Simulink');
     hold on;
     figure(52)
     pzmap(Tp);
     title('P - Simulink');
     hold on; 
     
     i = i + 1;
end
for i=51:52
    figure(i)
    legend(Legend)
    if i < 52
        xlabel('Time/ Seconds')
        ylabel('Response')
        legend(Legend,'Orientation','vertical','Location','northeast')
    else
    legend(Legend,'Orientation','vertical','Location','northeast')
    end
end 

stepP=0.05;
Gg = (0.0:stepP:1);
maxGg=max(Gg);
minGg=min(Gg);

Legend=cell(length(Gg),1);
   
for p=1:length(Gg)
    Legend{p}=num2str(Gg(p));
end

j = 1;
for G = minGg:stepP:maxGg

sim('PD.slx',[0 40])
sim('PID.slx',[0 40])
sim('PI.slx',[0 40])

   Kd= G;
   Kp= G;
   Ki= G;
   
         Cd = pid(1,0,Kd);
         Td = feedback(Cd*A,1);
         stepinfoKD(j) = stepinfo(Td);
         Ci = pid(1,Ki,1);
         Ti = feedback(Ci*A,1);
         stepinfoKI(j) = stepinfo(Ti);

        figure(61)
        plot(varyKD_constKP);
        title('Constant K_p(proportional gain) = 1, Varying K_d ')
        hold on;
        figure(62)
        plot(varyKDKP);
        title('Varying K_d and K_p')
        hold on;
        figure(63)
        pzmap(Td);
        title('Root Locus for Constant K_p = 1, Varying K_d ')
        hold on;


        figure(71)
        plot(varyKI_constKDKP);
        title('Constant K_p and K_d = 1, Varying K_i');
        hold on;
        figure(72)
        plot(varyKIKDKP);
        title('Varying K_d, K_p and K_i');
        hold on;
        figure(73)
        pzmap(Ti);
        title('Root Locus for Constant K_p and K_d = 1, Varying K_i ')
        hold on;
         
        j = j + 1;
        
end

Effect_of_Varying_Kp = struct2table(stepinfoKP)
Effect_of_Varying_Kd = struct2table(stepinfoKD)
Effect_of_Varying_Ki = struct2table(stepinfoKI)

for i=61:63
    figure(i)
    
    if i < 63
        xlabel('Time/ Seconds')
        ylabel('Response')
       legend(Legend,'Orientation','vertical','Location','southeast')

    else
        legend(Legend,'Orientation','vertical','Location','northwest')
    end
end 
for i=71:73
    figure(i)
    if i < 73
        xlabel('Time/ Seconds')
        ylabel('Response')
         legend(Legend,'Orientation','vertical','Location','southeast')
    else
       legend(Legend,'Orientation','vertical','Location','northwest')
    end
end 
