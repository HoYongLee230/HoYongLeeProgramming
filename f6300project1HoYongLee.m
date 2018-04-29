%F6300 Computer Simulation Project 1 Ho Yong Lee

%Control Variables
R = 1000; %cell radius in meters
N = 7; %cluster size
n = 3; %path loss exponent
d0 = 50; %path loss distance in meters
m = 100; %number of mobiles in the cell
std = 4; %standard deviation
k = 1; %array index
x = zeros(1,m); %initialize x position array of mobiles
y = zeros(1,m); %initialize y position array of mobiles
z = zeros(1,m); %initialize SIR values of mobiles
P = zeros(1,m); %initialize signal powers of mobiles
D = (sqrt(3*N))*R; %distance between centers of co-channel cells

%positions of the centers of the six co-channel cells, starting clockwise
%from top, cells are separated 60 degrees from each other
x1 = 0;
y1 = D;
x2 = (sqrt(3)/2)*D;
y2 = D/2;
x3 = (sqrt(3)/2)*D;
y3 = -D/2;
x4 = 0;
y4 = -D;
x5 = -(sqrt(3)/2)*D;
y5 = -D/2;
x6 = -(sqrt(3)/2)*D;
y6 = D/2;

while k <= m %randomly generates the positions of mobiles in the cell
    x(k) = 2*R*rand - R; %range of x for mobiles
    %range of y for mobiles if x is less than R/2
    if abs(x(k)) < R/2 && abs(x(k)) >= d0 
        y(k) = sqrt(3)*R*rand - sqrt(3)*R/2;
    %range of y for mobiles if x is less than d0
    elseif abs(x(k)) < d0
        while abs(y(k)) < d0*cos(asin(abs(x(k))/d0))
        y(k) = sqrt(3)*R*rand - sqrt(3)*R/2;
        end
    else %range of y for mobiles if x is greater than R/2
        y(k) = (sqrt(3)*R*rand - sqrt(3)*R/2)*2*(R - abs(x(k)))/R; 
    end
    d1 = (sqrt(((x1 - x(k))^2) + (y1 - y(k))^2))^-n;
    d2 = (sqrt(((x2 - x(k))^2) + (y2 - y(k))^2))^-n;
    d3 = (sqrt(((x3 - x(k))^2) + (y3 - y(k))^2))^-n;
    d4 = (sqrt(((x4 - x(k))^2) + (y4 - y(k))^2))^-n;
    d5 = (sqrt(((x5 - x(k))^2) + (y5 - y(k))^2))^-n;
    d6 = (sqrt(((x6 - x(k))^2) + (y6 - y(k))^2))^-n;
    z(k) = (R^(-n))/(d1 + d2 + d3 + d4 + d5 + d6); %SIR for a mobile
    %signal power for a mobile
    P(k) = -30-10*n*log((sqrt((x(k))^2 + (y(k))^2))/d0) + std*randn;
    k = k + 1; %iterate to next mobile
end

[minSIR,kmin] = min(z); %worst SIR value
[maxSIR,kmax] = max(z); %best SIR value

figure; %plot the mobiles randomly distributed in cell
scatter(x,y,10,'filled');
axis([-R R -sqrt(3)*R/2 sqrt(3)*R/2])
title('Positions of mobiles in cell')
xlabel('meters')
ylabel('meters')

figure; %3-D plot for SIRs of all the mobiles
ax1 = axes('Position',[0 0 1 1],'Visible','off');
ax2 = axes('Position',[.33 .1 .6 .8]);
scatter3(ax2,x,y,z,10,'filled');
title('3-D plot of SIRs of mobiles in cell')
xlabel('meters')
ylabel('meters')
zlabel('SIR')
descr = { %displays worst and best SIR values and their positions
'The best SIR value is: ';
[num2str(maxSIR) ' dB'];
['at: ' num2str(x(kmax)) ' , ' num2str(y(kmax))];
' ';
'The worst SIR value is: ';
[num2str(minSIR) ' dB'];
['at: ' num2str(x(kmin)) ' , ' num2str(y(kmin))]
};
axes(ax1) 
text(.001,0.8,descr)

figure; %3-D plot for signal power of all the mobiles
scatter3(x,y,P,10,'filled');
title('3-D plot of signal power of mobiles in cell')
xlabel('meters')
ylabel('meters')
zlabel('Pr[dB]')
