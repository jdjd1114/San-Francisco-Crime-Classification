function inter = Interection_feature(Address,n)
inter = zeros(n,1);
for i=1:n
    ad = regexp(Address(i),'\s/\s|\s/|/','split');
    [~,b]=size(ad{1,1});
    
    A1 = ad{1,1}{1,1};
    A1 = strtrim(A1);
    A2 = '';
    if b==2
        A2 = ad{1,1}{1,2};
        A2 = strtrim(A2);
    end
    if isempty(A1) || isempty(A2)
        inter(i) = 0;
    else
        inter(i) = 1;
    end
end