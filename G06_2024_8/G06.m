%G06
clc;clear;
% Record the number of model calls
global model_call
model_call=0;

lb=[13,0];
ub=[100,100];
A=[];
b=[];
Aeq=[];
beq=[];
result_fmin_f=[];%记录fmincon最优结果和模型迭代次数
result_fmin_p=[];%记录罚函数外点法最优结果和模型迭代次数
x0=[15,15;25,50;30,24;
    lb+(ub-lb).*lhsdesign(7,2)];
%%fmincon
for i=1:10
    options=optimoptions('fmincon','Algorithm','sqp','StepTolerance',1e-06,'FunctionTolerance',1e-06);
    [x,fival] = fmincon(@fun,x0(i,:),A,b,Aeq,beq,lb,ub,@con,options);
    result_fmin_f=[result_fmin_f;x,fival,model_call];
    model_call=0;
    disp(i);
end
%%penalty_method
for i=1:10    
[x,fival] = Penalty_method(@fun,x0(i,:),A,b,Aeq,beq,lb,ub,@con,[]);
result_fmin_p=[result_fmin_p;x,fival,model_call];
model_call=0;
disp(i);
end
%%
function y=fun(x)
x=x(:);
y=(x(1)-10).^3+(x(2)-20)^3;
global model_call
model_call=model_call+1;
end
%%非线性不等式与等式约束
function [c,ceq]=con(x)
c(1)=-(x(1)-5)^2-(x(2)-5)^2+100;
c(2)=(x(1)-6)^2+(x(2)-5)^2-82.81;
c=c(:);
ceq=[];
end