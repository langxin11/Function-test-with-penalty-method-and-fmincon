%%PVD_problem
clc;
clear;
global model_call
model_call=0;


lb=[1,0.625,25,25];
ub=[1.375,1.0,150,240];
A=[-1,0,0.0193,0;0,-1,0.00954,0];
b=[0;0];
Aeq=[];
beq=[];
result_fmin_f=[];%记录fmincon最优结果和模型迭代次数
result_fmin_p=[];%记录罚函数外点法最优结果和模型迭代次数
x0=[1.3,0.8,50,100;1,0.7,60,200;1,0.9,120,50;
    lb+(ub-lb).*lhsdesign(7,4)];
%%fmincon
for i=1:10
    options=optimoptions('fmincon','Algorithm','interior-point','StepTolerance',1e-06,'FunctionTolerance',1e-2);
    [x,fival] = fmincon(@fun,x0(i,:),A,b,Aeq,beq,lb,ub,@con,options);
    result_fmin_f=[result_fmin_f;x,fival,model_call];
    model_call=0;
    disp(i);
end
% for i=1:10
%     
%     [x,fival] = ga(@fun,4,A,b,Aeq,beq,lb,ub,@con,[]);
%     result_fmin_g=[result_fmin_f;x,fival,model_call];
%     model_call=0;
%     disp(i);
% end
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
y=0.6244*x(1)*x(3)*x(4)+1.7781*x(2)*x(3)^2+3.1661*x(1)^2*x(4)+19.84*x(1)^2*x(3);
global model_call
model_call=model_call+1;
end
%%非线性不等式与等式约束
function [c,ceq]=con(x)
c(1)=-pi*x(1)*x(3)^2-4/3*pi*x(3)^3+1296000;
c=c(:);
ceq=[];
end