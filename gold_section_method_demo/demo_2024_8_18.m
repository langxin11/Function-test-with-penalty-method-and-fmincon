y=@(x)(x-3)^2;
x0=0;
h=y(x0);
[a,b]=findInterval(y,x0,h,2);
[x_min,y_min,iter]=Gold_section(y,a,b,0.01);