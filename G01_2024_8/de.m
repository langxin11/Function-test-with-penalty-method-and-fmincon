function [best, bestFitness] = de(fobj, lb,ub,mut,crossp, popsize, its)
    if nargin < 4
        mut = 0.8;
    end
    if nargin < 5
        crossp = 0.7;
    end
    if nargin < 6
        popsize = 60;
    end
    if nargin < 7
        its = 20;
    end
   
    dimensions = size(lb, 2); % Number of dimensions
    % Initialize population
    pop = rand(popsize, dimensions);
    diff=ub-lb;
    pop_denorm = lb + diff.*pop;

    % Evaluate fitness
    fitness = arrayfun(@(i) fobj(pop_denorm(i, :)), 1:popsize);
    [bestFitness, best_idx] = min(fitness);
    best = pop_denorm(best_idx, :);

    for iter = 1:its
        for j = 1:popsize
            idxs = setdiff(1:popsize, j);
            rs=randsample(idxs,3);
            a=pop(rs(1),:);b=pop(rs(2),:);c=pop(rs(3),:);
            % Mutation
            mutant = a + mut * (b - c);
            % Ensure mutant is within [0, 1]
            mutant = min(max(mutant, 0), 1);

            % Crossover
            cross_points = rand(1, dimensions) < crossp;
            if ~any(cross_points)
                cross_points(randi(dimensions)) = true;
            end

            trial = pop(j, :);
            trial(cross_points) = mutant(cross_points);

            % Denormalize
            trial_denorm = lb + diff.*trial;

            % Evaluate fitness
            f = fobj(trial_denorm);
            if f < fitness(j)
               
                fitness(j) = f;
                pop(j, :) = trial;
                %[c,ceq]=con(trial);
                %if all(c<=0.001)&&all(abs(ceq)<0.001)
                if f < bestFitness
                    bestFitness = f;
                    best = trial_denorm;
                end
                %end
            end
        end
        % Optionally: display or save the best result of each iteration
    end
end
