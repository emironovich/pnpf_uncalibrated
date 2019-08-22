function d = new_find_det3(M)
    pwrs = [ 2,0 ; 1,1 ; 0,2 ; 1,0 ; 0,1; 0,0 ];
    d = zeros(1, 28);
    for i = 1 : 6
        for j = 1 : 6
            for k = 1 : 6
                mon_pwr = pwrs(i, :) + pwrs(j, :) + pwrs(k,  :);
                deg = sum(mon_pwr);
                ind = (9 + deg)*(6 - deg)/2 + mon_pwr(2) + 1;
                
                %deg = find_deg(i) + find_deg(j) + find_deg(k);
                %pwr_y = find_y_pwr(i) + find_y_pwr(j) + find_y_pwr(k);
                %ind = (9 + deg)*(6 - deg)/2 + pwr_y + 1;
                
                d(ind) = d(ind) + det([M(:, 1, i), M(:, 2, j), M(:, 3, k)]);
            end
        end
    end
end  

% function deg = find_deg(i)
%     if i == 6
%         deg = 0;
%     elseif i == 4 || i == 5
%         deg = 1;
%     else
%         deg = 2;
%     end
% end
% 
% function y = find_y_pwr(i)
%     if i == 3
%         y = 2;
%     elseif i == 2 || i == 5
%         y = 1;
%     else
%         y = 0;
%     end
% end