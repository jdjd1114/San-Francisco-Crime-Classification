function [testfeature,test_addr] = Address_feature_test(train,test,count_train,A_count,default_logodds,m,n)

%new_address = unique(test); %���Լ����ֵĵ�ַ
old_address = unique(train); %ѵ�������ֵĵ�ַ
[old_num,~] = size(old_address);
%[new_num,~] = size(new_address);
only_new = setdiff(unique(test),unique(train)); %ֻ�ڲ��Լ��г��ֵĵ�ַ

address = [old_address;only_new]; %���г��ֹ��ĵ�ַ
[addr_num,~] = size(address);

in_both = intersect(unique(train),unique(test));
[both_num,~] = size(in_both);
encode_both = zeros(both_num,1);
test_addr = zeros(n,1);
%% �����Լ��ĵ�ַ����
% parfor i=1:n
%     fprintf('The %dth iteration of prepocessing addresses.\n',i);
%     for j=1:addr_num
%         if strcmp(test(i),address(j))
%             test_addr(i) = j;
%         end
%     end
% end
%% ����������
% parfor i=1:both_num
%     fprintf('The %dth iteration of encoding in_both.\n',i);
%     for j=1:addr_num
%         if strcmp(in_both(i),address(j))
%             encode_both(i) = j;
%         end
%     end
% end
%%
load('data\test_numAdd.mat');
load('data\encodeboth.mat');
train_addr = zeros(old_num,1);
parfor i=1:old_num
    train_addr(i) = i;
end 
old_index = setdiff(unique(train_addr),unique(test_addr));
%% ���ɲ��Լ�������������
new_A_count = hist(test_addr,unique(test_addr));%������Լ���Ӧ��A_count����
logoddsPA=zeros(addr_num,1);
logodds = zeros(addr_num,39); 
for i=old_num+1:addr_num
    PA = new_A_count(both_num+i-old_num) / (m+n);
    logoddsPA(i) = log(PA) - log(1-PA);
    logodds(i,:) = default_logodds;
end
for i = 1:both_num
    ad = encode_both(i);
    PA = (A_count(ad) + new_A_count(i))/(m+n);
    logoddsPA(ad) = log(PA) - log(1-PA);
    logodds(ad,:) = count_train(ad,1:39);
end
testfeature = [logodds,logoddsPA];