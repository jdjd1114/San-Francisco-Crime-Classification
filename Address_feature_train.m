%% 提取训练集中的街道信息
function [countadd,train_numAdd,A_count,default_logodds] = Address_feature_train(address,n,categories,c_size)

%% 预处理
addre = unique(address);
[add_num,~] = size(addre);
cate = unique(categories);
[cate_num,~] = size(cate);

if c_size ~= 0
    train_numAdd = zeros(n,1);
    parfor i=1:n
        %fprintf('The %dth iteration of prepossessing addresses.\n',i);
        for j=1:add_num
            if strcmp(address(i),addre(j))
                train_numAdd(i) = j;
            end
        end
    end
    % 计算(导入count矩阵)
    A_C_count = [train_numAdd,categories];
    A_C_count = sortrows(A_C_count,[1,2]);
    for i=1:n
        A_C_count(i,3) = 1;
    end
    for i=n:-1:2
        fprintf('The %dth iteration of generating AC_count.\n',i);
        if A_C_count(i,1)==A_C_count(i-1,1) && A_C_count(i,2)==A_C_count(i-1,2)
            A_C_count(i-1,3) = A_C_count(i-1,3) + A_C_count(i,3);
            A_C_count(i,:)=[]; 
        end
    end
end
if c_size == 0
    load('data\A_C_count.mat');
    load('data\train_numAdd.mat');
end
%% 计算Address_count
A_count = zeros(add_num,1); % 存储每个街道出现的次数
A_count(1) = A_C_count(1,3);
A_C_count = sortrows(A_C_count,1);
x = 1;
[ac,~] = size(A_C_count);
for i=1:ac-1
    if A_C_count(i,1) == A_C_count(i+1,1) && A_C_count(i,1) == x
        A_count(x) = A_count(x) + A_C_count(i+1,3);
    else
        x = x + 1;
        A_count(x) = A_C_count(i+1,3);
    end
end
%% 计算category_count
C_count = zeros(cate_num,1);
A_C_count = sortrows(A_C_count,2);
C_count(1) = A_C_count(1,3);
y = 1;
for i=1:ac-1
    if A_C_count(i,2) == A_C_count(i+1,2) && A_C_count(i,2) == y
        C_count(y) = C_count(y) + A_C_count(i+1,3);
    else
        y = y + 1;
        C_count(y) = A_C_count(i+1,3);
    end
end
%% 计算logodds
logodds = zeros(add_num,cate_num);
logoddsPA = zeros(cate_num,1);
MIN_CAT_COUNTS=2;
default_logodds = zeros(1,cate_num);
for i=1:cate_num
    default_logodds(i) = log(C_count(i)/n)-log(1.0-C_count(i)/n);
end
for i=1:add_num
    PA = A_count(i)/n;
    logoddsPA(i) = log(PA) - log(1.0-PA);
    logodds(i,:) = default_logodds;
    for j=1:cate_num
        ACcount = count_AC(A_C_count,i,j);
        if ACcount>MIN_CAT_COUNTS && ACcount<A_count(i)
            PA = ACcount/A_count(i);
            logodds(i,j) = log(PA) - log(1.0-PA);
        end
    end
end
countadd = [logodds,logoddsPA];