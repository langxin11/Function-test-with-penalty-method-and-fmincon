lb=[13,0];
ub=[100,100];
A=[];
b=[];
Aeq=[];
beq=[];
x_k=[30,24];
[x_k_1,f_k_1] = fminsearch(@(y)obj_fun(y, @fun, 1e12, A, b, Aeq, beq, lb, ub,@con), x_k);
disp(x_k_1);
disp(obj_fun(x_k_1, @fun, 10e6, A, b, Aeq, beq, lb, ub,@con));
disp(fun(x_k_1));
%%
function obj = obj_fun(x, fun, penalty_factor, A, b, Aeq, beq, lb, ub,nonlcon)   
    obj= fun(x);
    [c,ceq]=nonlcon(x);
    penalty = sum(max(c, 0).^2) + sum(ceq.^2);
    obj = obj + penalty_factor * penalty;
    
    % 如果线性约束不满足，则增加罚项
    lin_penalty = 0;
    if ~isempty(A)
        lin_penalty = sum((max(A*x - b, 0)).^2);
        obj = obj + penalty_factor * lin_penalty;
    end
    if ~isempty(Aeq)
        lin_penalty = sum((Aeq*x - beq).^2);
        obj = obj + penalty_factor * lin_penalty;
    end
    if ~isempty(lb)
        lin_penalty =sum(max(lb - x, 0).^2);
        obj = obj + penalty_factor * lin_penalty;
    end
    if ~isempty(ub)
        lin_penalty =sum(max(x-ub, 0).^2);
        obj = obj + penalty_factor * lin_penalty;
    end
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