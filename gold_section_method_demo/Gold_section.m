function [x_min,y_min,iter]=Gold_section(fun,a,b,tor)
%input:
%output:
iter=[];
x1=a+0.382*(b-a);
x2=a+0.618*(b-a);
y1=fun(x1);
y2=fun(x2);
iter(1,:)=[a,b,x1,x2,y1,y2];
while(b-a>tor)

if y1>y2
a=x1;
x1=x2;
y1=y2;
x2=a+0.618*(b-a);
y2=fun(x2);
else
b=x2;
x2=x1;
y2=y1;
x1=a+0.382*(b-a);
y1=fun(x1);
end
iter=[iter;[a,b,x1,x2,y1,y2]];
end
x_min=(x1+x2)/2;
y_min=fun(x_min);
end