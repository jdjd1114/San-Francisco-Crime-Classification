function WEEK1 = Week_feature(tw,n)

week = {'Monday';'Tuesday';'Wednesday';'Thursday';'Friday';'Saturday';'Sunday'};
WEEK1 = zeros(n,7);
[~,pos] = ismember(tw,week);
for i=1:n
    WEEK1(i,pos(i)) = 1;
end

