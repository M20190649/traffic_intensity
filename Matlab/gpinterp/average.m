function  [mi,mj,c] = average(datab,td_length,tb_length,t_name,t_cell)
   for i = 1:td_length
       for j = 1:tb_length
              if t_name(i,:) == t_cell(j,:)
                   my_count(i,j) = datab(j);
              end
       end
   end
   % Remove sparsness or ignore cells not reported
   cc =sum(my_count,2);
   cca = sum(my_count~=0,2);
   [mi,mj,cc]   = find(cc);
   [mi,mj,cca]  = find(cca);
   c = cc./cca;
%%%%%%%%%%%%%%%%%%%%%%%%
end