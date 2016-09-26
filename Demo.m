% San Francisco Crime prediction
% ���ɭ�ַ�����
% ��ַ���ü���������ʱ�䡢���ھ�Ϊ��ɢ��
clear all;
close;
% load('testset.mat')
% load('trainset.mat')
%% ����ѵ��������������
train = importdata('data\train.csv'); 
test = importdata('data\test.csv');
%% ȥ����ͷ
train.textdata(1,:) = [];
test.textdata(1,:) = [];

%% ��γ��
train_X = train.data(:,1);% ѵ��������
train_Y = train.data(:,2);% ѵ����γ��
test_X = test.data(:,1); % ���Լ�����
test_Y = test.data(:,2); % ���Լ�γ��

%% ʱ�������
traindates = train.textdata(:,1);
[train_dates,train_season,train_awake] = Dates_feature(traindates,878049,'train');
testdates = test.textdata(:,2);
[test_dates,test_season,test_awake] = Dates_feature(testdates,884262,'test');
clear train_Dates;
clear test_Dates;

%% ���ڵ�ַ�Ƿ����ظ���
train_data = [train_X,train_Y,train_dates];
test_data = [test_X,test_Y,test_dates];
train_isdup = Isdup_feature(train_data);
test_isdup = Isdup_feature(test_data);

%% ����
trainweek = train.textdata(:,4);
train_week = Week_feature(trainweek,878049);

testweek = test.textdata(:,3);
test_week = Week_feature(testweek,884262);
clear trainweek;
clear testweek;
%% PDistrict������
traindistrict = train.textdata(:,5);
PD = unique(traindistrict);
train_district = District_feature(traindistrict,PD,878049);
testdistrict = test.textdata(:,4);
test_district = District_feature(testdistrict,PD,884262);
clear traindistrict;
clear testdistrict;
%% ��ǩ
trainlabel = train.textdata(:,2);
Labels = unique(trainlabel);
[~,train_label] = ismember(trainlabel,Labels);

%% ��ַ
trainadd = train.textdata(:,7);
testadd = test.textdata(:,5);
train_inter = Interection_feature(trainadd,878049);
test_inter = Interection_feature(testadd,884262);

% [train_countadd,train_numAdd,A_count,default_logodds] = Address_feature_train(trainadd, 878049,train_label,0);
% clear trainadd;
% clear trainlabel;
% train_countaddfeature = zeros(878049,40);
% for i=1:878049
%     train_countaddfeature(i,:) = train_countadd(train_numAdd(i),:);
% end
% [test_countadd,test_numAdd] = Address_feature_test(trainadd,testadd,train_countadd,A_count,default_logodds,878049,884262);
% test_countaddfeature = zeros(884262,40);
% for i=1:884262
%     test_countaddfeature(i,:) = test_countadd(test_numAdd(i),:);
% end
%% ѵ�����Ͳ��Լ�
% train_data = [train_X,train_Y,train_dates,train_seaton,train_week,train_district,train_countaddfeature];
% test_data = [test_X,test_Y,test_dates,test_seaton,test_week,test_district,test_countaddfeature];
train_data = [train_data,train_awake,train_week,train_season,train_district,train_inter,train_isdup];
test_data = [test_data,test_awake,test_week,test_season,test_district,test_inter,test_isdup];

%% ������׼��Ϊ���ֵһ����
[train_data, mu, sigma] = zscore(train_data);
test_data = normalize(test_data, mu, sigma);
% [~,col] = size(train_data);
% sigma = std(train_data,1);
% mu = mean(train_data);
% for i=1:col
%     train_data(:,i) = (train_data(:,i) - mu(i))/sigma(i);
% end
% 
% for i=1:col 
%     test_data(:,i) = (test_data(:,i) - mu(i))/sigma(i);
% end

%% ���ɭ��ģ��ѵ����Ԥ��
model = classRF_train(train_data,train_label,100);
[predict_label,votes] = classRF_predict(test_data,model);
%%
votes = votes +1;%��������
votes = votes / 139;%����Ʊ��ת��ΪԤ�����
id = zeros(884262,1);
for i=1:884262
    id(i) = i-1; 
end
sub = [id,votes];
csvwrite('submission30.csv',sub);%������Ϊcsv�ļ�