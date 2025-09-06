function m = reln2exm(r);

% find extension corresponding to full relational matrix

n = size(r,1);
firsthalf  = 1:(n-2)/2;
secondhalf = (max(firsthalf)+1):n-2;
ego1 = n-1;
ego2 = n;

exm2a = transpose(squeeze(r(firsthalf, ego1,:)));
exm2b = transpose(squeeze(r(secondhalf,  ego2,:)));
exm2c = transpose(squeeze(r(secondhalf, ego1,:)));
exm2d = transpose(squeeze(r(firsthalf,  ego2,:)));
exm2e = transpose(squeeze(r([ego1,ego2],  ego1,:)));
exm2f = transpose(squeeze(r([ego1,ego2],  ego2,:)));

m = [exm2a, exm2b, exm2c, exm2d, exm2e, exm2f];

