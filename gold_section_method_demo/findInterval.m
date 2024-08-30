function [lb, ub] = findInterval(fun, x0, h,alpha)
%input:
%output:
x1=x0;
x2=x0+h;
y1=fun(x1);
y2=fun(x2);
if y1>y2
%前进运算
x1=x2;
h=alpha*h;
x2=x1+h;
y1=y2;
y2=fun(x2);
    while y1>y2
    x1=x2;
    h=alpha*h;%增长步长
    x2=x1+h;
    y1=y2;
    y2=fun(x2);
    end
    if y1==y2
    lb=x1;ub=x2;
    else
    lb=x1-h/alpha;ub=x2;
    end

elseif y1<y2
    %后退运算
    while y1<y2
        x2=x1;
        h=alpha*h;
        x1=x1-h;
        y2=y1;
        y1=fun(x1);
    end
    if y1==y2
        lb=x1;ub=x2;
    else 
        lb=x1;ub=x2+h/alpha;
    end
else
    lb=x1;ub=x2;
end
end