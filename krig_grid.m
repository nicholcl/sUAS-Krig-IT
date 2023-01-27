%Example 1: Grid
LONG=zeros(100,1);
LAT=zeros(100,1);
rand=randn(100);
i=0;
while i<=9
   if mod(i,2)~=0
       LONG(i*10+1:i*10+10)=transpose(1:-0.1:0.1)+rand(i*10+1:i*10+10,1)*.01;
       i=i+1;
   elseif mod(i,2)==0
       LONG(i*10+1:i*10+10)=transpose(0.1:0.1:1)+rand(i*10+1:i*10+10,1)*.01;
       i=i+1;
   end
end

i=0.1;
j=1;
while i<=1
    LAT(j:j+9)=zeros(10,1)+i;
    i=i+0.1;
    j=j+10;
end

n = length(LONG);
ALT=zeros(size(LONG))-3;
TEMP=randn(n,'single');
TEMP1= transpose(linspace(1,10,n))+TEMP(:,1);

LONG2=zeros(100,1);
LAT2=zeros(100,1);
rand=randn(n);
i=0;
while i<=9
   if mod(i,2)~=0
       LONG2(i*10+1:i*10+10)=transpose(1:-0.1:0.1)+rand(i*10+1:i*10+10,1)*.01;
       i=i+1;
   elseif mod(i,2)==0
       LONG2(i*10+1:i*10+10)=transpose(0.1:0.1:1)+rand(i*10+1:i*10+10,1)*.01;
       i=i+1;
   end
end

i=0.1;
j=1;
while i<=1
    LAT2(j:j+9)=zeros(10,1)+i;
    i=i+0.1;
    j=j+10;
end

n = length(LONG2);
ALT2=zeros(size(LONG2));
TEMP2= flip(transpose(linspace(1,10,n))+TEMP(:,2));

LONG3=zeros(100,1);
LAT3=zeros(100,1);
rand=randn(n);
i=0;
while i<=9
   if mod(i,2)~=0
       LONG3(i*10+1:i*10+10)=transpose(1:-0.1:0.1)+rand(i*10+1:i*10+10,1)*.01;
       i=i+1;
   elseif mod(i,2)==0
       LONG3(i*10+1:i*10+10)=transpose(0.1:0.1:1)+rand(i*10+1:i*10+10,1)*.01;
       i=i+1;
   end
end

i=0.1;
j=1;
while i<=1
    LAT3(j:j+9)=zeros(10,1)+i;
    i=i+0.1;
    j=j+10;
end

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