function m = feat2exm(r);

% find extension corresponding to full feature matrix

n = size(r,2);

firsthalf  = 1:(n-2)/2;
secondhalf = (max(firsthalf)+1):n-2;
ego1 = n-1;
ego2 = n;

m = [r(:, [firsthalf, secondhalf]), r(:,secondhalf), r(:,firsthalf), r(:, [ego1, ego2]), r(:, [ego1, ego2])]; 

