%Example 2: Spiral
LONG=transpose(cos(0:0.1:4*pi).*(0:0.008:1));
LAT=transpose(sin(0:0.1:4*pi).*(0:0.008:1));

n = length(LONG);
ALT=zeros(size(LONG))-3;
TEMP=randn(n,'single');
TEMP1= transpose(linspace(1,10,n))+TEMP(:,1);

LONG2=transpose(cos(0:0.1:4*pi).*(0:0.008:1));
LAT2=transpose(sin(0:0.1:4*pi).*(0:0.008:1));

n = length(LONG2);
ALT2=zeros(size(LONG2));
TEMP2= flip(transpose(linspace(1,10,n))+TEMP(:,2));

LONG3=transpose(cos(0:0.1:4*pi).*(0:0.008:1));
LAT3=transpose(sin(0:0.1:4*pi).*(0:0.008:1));

n = length(LONG3);
ALT3=zeros(size(LONG3))+3;
TEMP3= transpose(linspace(1,10,n))+TEMP(:,3);

LONG=cat(1,LONG,LONG2,LONG3);
LAT=cat(1,LAT,LAT2,LAT3);
ALT=cat(1,ALT,ALT2,ALT3);
TEMP0=cat(1,TEMP1,TEMP2,TEMP3);

pos_known=[LONG LAT ALT];
val_known=TEMP0;
figure(1)
histogram(val_known)

long=min(LONG):.01:max(LONG);
lat=min(LAT):.01:max(LAT);
alt=min(ALT):.1:max(ALT);

[xx,yy,zz]=meshgrid(long,lat,alt);
pos_est=[xx(:) yy(:) zz(:)];

[gamma,hc,np,av_dist]=semivar_exp(pos_known,val_known,20);
disp(max(hc))
Nug = num2str(min(gamma));
Sill = num2str(max(gamma)-min(gamma));
Range = num2str(max(hc));
V= append(Nug,' Nug(0) + ',Sill,' Lin(',Range,')');
d=0:.01:2;
[sv,d]=semivar_synth(V,d);

figure(2)
hold on
scatter(hc,gamma)
plot(d,sv)
legend('experimental', 'model')
xlabel('Distance (h)')
ylabel('Semivariogram Value ({\gamma})')
title('Semivariogram Chart')
hold off

[d_est,d_var]=gstat_krig(pos_known,val_known,pos_est,V);

figure(3);scatter3(pos_known(:,1),pos_known(:,2),pos_known(:,3),10,val_known,'filled')
title('Original Data')
colorbar
colormap(jet)
figure(4);scatter3(pos_est(:,1),pos_est(:,2),pos_est(:,3),10,d_est,'filled')
title('Kriging Estimate')
colorbar
colormap(jet)
figure(5);scatter3(pos_est(:,1),pos_est(:,2),pos_est(:,3),10,sqrt(d_var),'filled')
title('Kriging Standard Error, {\sigma}')
colorbar
colormap(jet)