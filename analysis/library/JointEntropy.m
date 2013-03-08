function JE = JointEntropy(x, y)
assert(length(x) == length(y));

x = x(:);
y = y(:);

n = length(x);

x_unique = unique(x);
y_unique = unique(y);

% check the integrity of y
if length(x_unique) ~= length(y_unique)
    error('number of states of inputs are not equal.');
end;

c = length(x_unique);

% distribution of y and x
Ml = double(repmat(x,1,c) == repmat(x_unique',n,1));
Mr = double(repmat(y,1,c) == repmat(y_unique',n,1));

M = Ml'*Mr/n;
JE = -sum( M(:) .* log2( M(:) + eps ) );

