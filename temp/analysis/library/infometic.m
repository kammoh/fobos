function MI = infometic(x,y)
fprintf('Finding Mutual Information\n');
MI = MutualInformation(x,y);
end

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
end

function CE = ConditionalEntropy(x,y)
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

CE = JointEntropy(x,y)-entropy(y);
end
function H=et1_shn(p,c)
ent = p';
[m,n]=size(ent);
Err=1e-6;
if abs(1-sum(ent))>Err
error('Input vector must be a probability mass function');
end;
h1=(-1)*ones(m,n);
h2=((sign(ent)+h1).*h1)+ent;
H=h2*log(h2)'*(-c);
end

function MI = MutualInformation(x,y)
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
fprintf('Entropy of X -> %d, Entropy of Y ->%d, JEn -> %d\n',Entropy(x), Entropy(y), JointEntropy(x,y));
MI = et1_shn(x,1/log(2)) + et1_shn(y,1/log(2)) -JointEntropy(x,y);
end
