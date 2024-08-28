%G01 TEST
clc;
clear;
% Record the number of model calls
global iter
iter=0;

lb=zeros(1,13);
ub=[ones(1,9),100,100,100,1];
A=[2,2,zeros(1,7),1,1,0,0;
   2,0,2,zeros(1,6),1,0,1,0;
   0,2,2,zeros(1,7),1,1,0
   -8,zeros(1,8),1,0,0,0;
   0,-8,zeros(1,8),1,0,0;
   zeros(1,3),-2,-1,zeros(1,4),1,zeros(1,3);
   zeros(1,5),-2,-1,zeros(1,3),1,zeros(1,2);
   zeros(1,7),-2,-1,zeros(1,2),1,0];
b=[10;10;10;zeros(5,1)];
Aeq=[];
beq=[];
result_fmin_f=[];%记录fmincon最优结果和模型迭代次数
result_fmin_p=[];%记录罚函数外点法最优结果和模型迭代次数
x0=[ones(1,13);0.5*ones(1,13);0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,2,3,0.5;
    lb+(ub-lb).*lhsdesign(7,13)];
%%fmincon
for i=1:10
    options=optimoptions('fmincon','StepTolerance',1e-06,'FunctionTolerance',1e-06);
[x,fival] = fmincon(@fun,x0(i,:),A,b,Aeq,beq,lb,ub,@con,options);
result_fmin_f=[result_fmin_f;x,fival,iter];
iter=0;
disp(i);
end
%%penalty_method
for i=1:10    
[x,fival] = Penalty_method(@fun,x0(i,:),A,b,Aeq,beq,lb,ub,@con,[]);
result_fmin_p=[result_fmin_p;x,fival,iter];
iter=0;
disp(i);
end
%%
function y=fun(x)
y=5*sum(x(1:4)-x(1:4).^2)-sum(x(5:13));
global iter
iter=iter+1;
end
%%非线性不等式与等式约束
function [c,ceq]=con(x)
c=[];
ceq=[];
end