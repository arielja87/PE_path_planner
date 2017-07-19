%Prepare an empty priority queue
%function [pq] = priorityPrepare()
function [pq] = priorityPrepare()
pq = repmat(struct('node',[],'cost',[]),1,0);
end