% San Francisco Crime prediction
% 随机森林分类器
% 地址采用计数特征，时间、日期均为离散型
clear all;
close;
% load('testset.mat')
% load('trainset.mat')
%% 导入训练集，处理数据
train = importdata('data\train.csv'); 
test = importdata('data\test.csv');
%% 去掉表头
train.textdata(1,:) = [];
test.textdata(1,:) = [];

%% 经纬度
train_X = train.data(:,1);% 训练集经度
train_Y = train.data(:,2);% 训练集纬度
test_X = test.data(:,1); % 测试集经度
test_Y = test.data(:,2); % 测试集纬度

%% 时间和日期
traindates = train.textdata(:,1);
[train_dates,train_season,train_awake] = Dates_feature(traindates,878049,'train');
testdates = test.textdata(:,2);
[test_dates,test_season,test_awake] = Dates_feature(testdates,884262,'test');
clear train_Dates;
clear test_Dates;

%% 日期地址是否有重复项
train_data = [train_X,train_Y,train_dates];
test_data = [test_X,test_Y,test_dates];
train_isdup = Isdup_feature(train_data);
test_isdup = Isdup_feature(test_data);

%% 星期
trainweek = train.textdata(:,4);
train_week = Week_feature(trainweek,878049);

testweek = test.textdata(:,3);
test_week = Week_feature(testweek,884262);
clear trainweek;
clear testweek;
%% PDistrict所在区
traindistrict = train.textdata(:,5);
PD = unique(traindistrict);
train_district = District_feature(traindistrict,PD,878049);
testdistrict = test.textdata(:,4);
test_district = District_feature(testdistrict,PD,884262);
clear traindistrict;
clear testdistrict;
%% 标签
trainlabel = train.textdata(:,2);
Labels = unique(trainlabel);
[~,train_label] = ismember(trainlabel,Labels);

%% 地址
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
%% 训练集和测试集
% train_data = [train_X,train_Y,train_dates,train_seaton,train_week,train_district,train_countaddfeature];
% test_data = [test_X,test_Y,test_dates,test_seaton,test_week,test_district,test_countaddfeature];
train_data = [train_data,train_awake,train_week,train_season,train_district,train_inter,train_isdup];
test_data = [test_data,test_awake,test_week,test_season,test_district,test_inter,test_isdup];

%% 特征标准化为零均值一方差
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

%% 随机森林模型训练和预测
model = classRF_train(train_data,train_label,100);
[predict_label,votes] = classRF_predict(test_data,model);
%%
votes = votes +1;%消除零项
votes = votes / 139;%将得票数转换为预测概率
id = zeros(884262,1);
for i=1:884262
    id(i) = i-1; 
end
sub = [id,votes];
csvwrite('submission30.csv',sub);%保存结果为csv文件