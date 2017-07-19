%Add an element to the priority queue
%function [pq] = priorityPush(pq,node,cost)
%Inputs
%   pq   Priority queue struct array
%   node  node number to add
%   cost Cost associated to the element to add
%In this implementation the elment is added at the end.
function [pq] = priorityPush(pq,nodes,costs)
% This function adds a structure with arguments node and cost to their 
% corresponding fields in vector pq.
nodes = num2cell(nodes);
costs = num2cell(costs);
if isempty(pq)
    [pq(1:numel([nodes{:}])).node] = deal(nodes{:});
    [pq(1:numel([nodes{:}])).cost] = deal(costs{:});
else
    new_id = (numel(pq)+1):(numel(pq)+numel([nodes{:}]));
    [pq(new_id).node] = deal(nodes{:});
    [pq(new_id).cost] = deal(costs{:});
end
end