
%Remove key with minimum cost from the queue
%Inputs
%   pq  Priority queue struct array
%   node node to find
%Outputs
%   pq   Updated priority queue struct array
%   node  node with minimum cost
function [node,pq]=priorityMinPop(pq)
if isempty(pq)
    pq = priorityPrepare;
    node = [];
else
    %Put all costs into a vector, and find minimum
    [~,idx] = min([pq.cost]);
    %Get the node of the minimum
    node=pq(idx).node;
    %Remove minumum element from the queue
    pq(idx)=[];
end

