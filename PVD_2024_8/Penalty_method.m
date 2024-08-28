function [x_best, fval] = Penalty_method(fun, x0, A, b, Aeq, beq, lb, ub, nonlcon,options)
    %转换为列向量
    x0=x0(:);
    lb=lb(:);
    ub=ub(:);
    % 初始化参数
    penalty_factor = 10000; % 初始罚因子
    tolerance_1=1e-6;
    tolerance_2 = 1e-6; % 收敛精度
   
    k=1;
    % 主循环
    x_k=x0;
    while true
        %select 
        f_k=obj_fun(x_k, fun, penalty_factor, A, b, Aeq, beq, lb, ub,nonlcon);
        % 使用无约束优化方法（fminsearch）寻找新的x
        [x_k_1,f_k_1] = fminsearch(@(y)obj_fun(y, fun, penalty_factor, A, b, Aeq, beq, lb, ub,nonlcon), x_k);
        % 检查收敛性
        if (sum((x_k_1-x_k).^2)<tolerance_1^2)&&((f_k_1-f_k)^2)<tolerance_2^2
            break;
        end
        k=k+1;
        penalty_factor=5*penalty_factor;
        x_k=x_k_1;

    end
    x_best=x_k_1;
    %判断是否满足约束
    constraintViolation = checkConstraints(A, b, Aeq, beq, lb, ub, nonlcon, x_best);
    if constraintViolation
        disp('find feasilble solution');
    else
        disp('not find feasible solution');
    end
    x_best=x_best';
    fval=fun(x_best);
end
% 定义内部对象函数
function obj = obj_fun(x, fun, penalty_factor, A, b, Aeq, beq, lb, ub,nonlcon)   
    obj= fun(x);
    [c,ceq]=nonlcon(x);
    penalty = sum(max(0, c).^2) + sum(ceq.^2);
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
function constraintViolation = checkConstraints(A, b, Aeq, beq, lb, ub, nonlcon, x)
    % 计算约束违反的程度
    constraintViolation =true;
    
    % 线性约束违反
    if ~isempty(A)
        if ~all((A * x - b)<=1e-3)
            constraintViolation=false;
            return; 
        end
    end
    if ~isempty(Aeq)
        if ~all(abs(Aeq * x - beq)<1e-3)
            constraintViolation=false;
            return;
        end
    end
    
    % 边界约束违反
    if ~(all((lb - x)<=0.005)&&all((x - ub)<=0.005))
            constraintViolation=false;
            return;
    end
    % 非线性约束违反
    [c, ceq] = nonlcon(x);      
    if ~isempty(c)
        if ~all(c<=1e-04)
        constraintViolation =false;
        return
        end
    end
        if ~isempty(ceq)
            if ~all(abs(ceq)<1e-03)
                constraintViolation =false;
                return
            end
        end
          
end