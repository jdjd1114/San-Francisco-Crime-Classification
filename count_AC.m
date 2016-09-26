function count = count_AC(A_C,i,j)
[a,~] = size(A_C);
count = 0;
for ii=1:a
    if A_C(ii,1) == i && A_C(ii,2) == j
        count = A_C(ii,3);
    end
end