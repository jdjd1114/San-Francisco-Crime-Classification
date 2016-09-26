function D = District_feature(district,PD,n)

[a,~] = size(PD);
D = zeros(n,a);
[~,pos] = ismember(district,PD);
for i=1:n
    D(i,pos(i)) = 1;
end