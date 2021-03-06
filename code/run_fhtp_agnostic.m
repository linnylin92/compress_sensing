sparsity_vect = [2*(1:50),125,150];
TOTALITER = 10;

LEN = length(sparsity_vect);
LEN_GAUSS = 100000;
LEN_IDX = 1500;

lambda = 0.01;      % regularization parameter
rel_tol = 10^-8;     % relative target duality gap

n1 = 33;
n2 = 34;
d1 = 141;
d2 = 142;

rng_gauss = csvread('rng_gauss.csv');
rng_idx = csvread('rng_idx.csv');
counterVect = 10000*(0:(TOTALITER-1));
counterVect2 = 150*(0:(TOTALITER-1));

res_sparsity = -ones(LEN*TOTALITER,1);
res_timer = -ones(LEN*TOTALITER,1);
res_maxerror = -ones(LEN*TOTALITER,1);
res_l1error = -ones(LEN*TOTALITER,1);

res_counter = 1;
for i = 1:LEN
    for j = 1:TOTALITER
        fprintf('NEW PROBLEM: Sparisity %d, Iteration %d\n',sparsity_vect(i),j); 
        counter = counterVect2(j)+1;
        x0 = zeros(d1*d2,1);
        while sum(x0)< sparsity_vect(i)
            x0(rng_idx(counter)) = 1;
            counter = counter+1;
        end
        A = reshape(rng_gauss((counterVect(j)+1):(counterVect(j)+n1*d1)),n1,d1)';
        A = A';
        B = reshape(rng_gauss((counterVect(j)+n1*d1+1):(counterVect(j)+n1*d1+n2*d2)),n2,d2)';
        B = B';
        U = kron(A,B);
        y = U*x0;
        %check:
        %X = vec2mat(x0,d2);
        %Y = A*X*B';
        %yprime = reshape(Y',n1*n2,1);
        %sum(abs(yprime-y))
        fprintf('starting now\n===============================\n');
        tic;
[x,S,NormRes,NbIter] = FHTP_(y,U,100,1500);
        res_timer(res_counter) = toc;
        res_sparsity(res_counter) = sparsity_vect(i);
        res_maxerror(res_counter) = max(abs(x-x0));
        res_l1error(res_counter) = sum(abs(x-x0))/sparsity_vect(i);
        
        fprintf('Betahat sum: %f\n, Max error: %f\n, L1 error: %f\n, Solution time (seconds): %f\n',sum(x),res_maxerror(res_counter),res_l1error(res_counter),res_timer(res_counter));
        res_counter = res_counter+1;
    end

res_matrix = [res_sparsity'; res_timer'; res_maxerror'; res_l1error']';
csvwrite('fhtp_res_agnostic.csv',res_matrix);

end

res_matrix = [res_sparsity'; res_timer'; res_maxerror'; res_l1error']';
csvwrite('fhtp_res_agnostic.csv',res_matrix);

quit();
