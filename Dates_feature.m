% Dates
function [dates_feature,season_feature,isawake] = Dates_feature(Dates,n,sign)
dates_feature = zeros(n,4);
season_feature = zeros(n,4);
isawake = zeros(n,1);
for i=1:n
    date = regexp(Dates(i), '/|\s|:|-', 'split');
    if strcmp(sign,'train') 
        month = date{1,1}{1,1};%month
        month = str2double(month);

        day = date{1,1}{1,2};%day
        day = str2double(day);
        
        year = date{1,1}{1,3};
        year = str2double(year);
        
        hour = date{1,1}{1,4};
        hour = str2double(hour);

        dates_feature(i,1) = year;
        dates_feature(i,2) = month;
        dates_feature(i,3) = day;
        dates_feature(i,4) = hour;

        if month == 8 || month == 6 || month == 7
            season_feature(i,1) = 1;
        end
        if month == 11 || month == 9 || month == 10
            season_feature(i,2) = 1;
        end
        if month == 2 || month == 1 || month == 12
            season_feature(i,3) = 1;
        end
        if month == 3 || month == 4 || month == 5
            season_feature(i,4) = 1;
        end

        if hour==0 || (hour>=8 && hour<=24)
            isawake(i) = 1;
        end
    end
    
    if strcmp(sign,'test')
        year = date{1,1}{1,1};
        year = str2double(year);
        
        month = date{1,1}{1,2};%month
        month = str2double(month);

        day = date{1,1}{1,3};%day
        day = str2double(day);

        hour = date{1,1}{1,4};
        hour = str2double(hour);

        dates_feature(i,1) = year;
        dates_feature(i,2) = month;
        dates_feature(i,3) = day;
        dates_feature(i,4) = hour;

        if month == 5 || month == 6 || month == 7
            season_feature(i,1) = 1;
        end
        if month == 8 || month == 9 || month == 10
            season_feature(i,2) = 1;
        end
        if month == 11 || month == 1 || month == 12
            season_feature(i,3) = 1;
        end
        if month == 2 || month == 3 || month == 4
            season_feature(i,4) = 1;
        end

        if hour==0 || (hour>=8 && hour<=24)
            isawake(i) = 1;
        end
    end
    
%     minute = date{1,1}{1,5};
%     minute = str2double(minute);
%     if (month == 4 || month ==6 || month ==9 || month == 11)
%         day = day/30;
%     end
%     if (month == 2)
%         day = day/28;
%     end
%     if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month ==10 || month ==12)
%         day = day/31;
%     end
%     F1(i) = month + day;
%     F2(i) = minute + sec/60;

end
    
    