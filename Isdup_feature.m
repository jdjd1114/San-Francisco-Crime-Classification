function isdup = Isdup_feature(data)
n = size(data,1);isdup = zeros(n,1);

% [un,first_place,~] = unique(data,'rows','first');
% [~,last_place,~] = unique(data,'rows','last');
% isd = zeros(size(un,1),1);
% 
% for i=1:size(un,1)
%     if first_place(i) ~= last_place(i)
%         isd(i)=1;
%     end
% end
% for i=1:n
%     for j=1:size(un,1)
%         if isequal(data(i,:),un(j,:)) == 1
%             isdup(i) = isd(j);
%         end
%     end
% end

[~,pos] = ismember(data,unique(data,'rows'),'rows');
[m,~] = hist(pos,unique(pos));
for i=1:n
    if m(pos(i)) > 1
        isdup(i) = 1;
    end
end