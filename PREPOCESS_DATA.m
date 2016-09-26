%% ��������
load('Address_data.mat');
load('train_label.mat');
addre = unique(train_Address);
[add_num,~] = size(addre);
cate = unique(train_label);
[cate_num,~] = size(cate);
train_numAdd = zeros(n,1);
n=878049;
parfor i=1:n
        %fprintf('The %dth iteration of prepossessing addresses.\n',i);
    for j=1:add_num
        if strcmp(train_Address(i),addre(j))
            train_numAdd(i) = j;
        end
    end
end
save train_numAdd train_numAdd

n=884262;
%new_address = unique(test); %���Լ����ֵĵ�ַ
old_address = unique(train_Address); %ѵ�������ֵĵ�ַ
[old_num,~] = size(old_address);
%[new_num,~] = size(new_address);
only_new = setdiff(unique(test_Address),unique(train_Address)); %ֻ�ڲ��Լ��г��ֵĵ�ַ

address = [old_address;only_new]; %���г��ֹ��ĵ�ַ
[addr_num,~] = size(address);

in_both = intersect(unique(train_Address),unique(test_Address));
[both_num,~] = size(in_both);
encode_both = zeros(both_num,1);
test_addr = zeros(n,1);
parfor i=1:n
    %fprintf('The %dth iteration of prepocessing addresses.\n',i);
    for j=1:addr_num
        if strcmp(test(i),address(j))
            test_addr(i) = j;
        end
    end
end
save test_numAdd test_addr