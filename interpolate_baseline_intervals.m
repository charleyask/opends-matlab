function [ T ] = interpolate_baseline_intervals( intervals, tgaps, M, hdr )
%
% Interpolates baseline intervals from the matrix M into log times. Returns
% an M x 2 matrix defining the intervals as atart and end log times
%

idx_cycle = find(strcmp(hdr,'Cycle'));
idx_repeat = find(strcmp(hdr,'Repeat'));
idx_logtime = find(strcmp(hdr,'TrackerTime'));
idx_dist = find(strcmp(hdr,'LaneDist'));

% For each cycle/repeat, we want to estimate the time points of baseline
% onset/offset

intervals = cell2mat(intervals);

cycle = 1;
cycles = cell2mat(M(:,idx_cycle));
N_cycles = max(cycles);
T = zeros(0,2);

while cycle <= N_cycles

    S = M(cycles==cycle,:);
    R = intervals(intervals(:,1)==cycle,2:3);
    
    repeats = cell2mat(S(:,idx_repeat));
    N_repeats = max(repeats);
    
    repeat = 1;
    while repeat <= N_repeats
        S2 = S(repeats==repeat,:);
        logtime = cell2mat(S2(:,idx_logtime));
        d_end = S2{end,idx_dist};
        dists = cell2mat(S2(:,idx_dist));
        t0 = logtime(1);
        tm = logtime(end);
        
        % Account for time gaps
        tgap = tgaps(find(tgaps(:,1)>=t0 & tgaps(:,1)<tm),:);
        
        % Assign interval distances to fractions of round
        for i = 1 : size(R,1)
           d_start = R(i,1);
           
           if d_start > max(dists) % The round ended prematurely
               break;
           end
           
           d1 = find(dists<=d_start,1,'last');
           d2 = find(dists>=d_start,1,'first');
           
           if ~(isempty(d1) || isempty(d2)) 
           
               if d1 == d2
                  ratio = 0; 
               else
                  ratio = (d_start-dists(d1))/(dists(d2)-dists(d1));
               end

               try
               t1 = logtime(d1)+ratio*double(logtime(d2)-logtime(d1));
               catch 
                  a = 0; 
               end
               
               if t1 == 0
                  a=0; 
               end

               d_end = R(i,2);
               if d_end > max(dists) % The interval exceeds the round
                   ratio = 1;
               else
                   d1 = find(dists<=d_end,1,'last');
                   d2 = find(dists>=d_end,1,'first');

                   if d1 == d2
                      ratio = 0; 
                   else
                      ratio = (d_end-dists(d1))/(dists(d2)-dists(d1));
                   end
               end

               t2 = logtime(d1)+ratio*double(logtime(d2)-logtime(d1));

               if t2 > 10000000
                  a=0;
               end
               
               T(end+1,:) = [t1 t2];
           
           end
           
        end
        
        repeat = repeat + 1;
    end
    
    cycle = cycle + 1;
end

