function mat2dance(matrix, outfile)

% make input file for dancing links

f = fopen(outfile, 'w');

n = size(matrix,1);
m = size(matrix,2);

for i = 1:m
  fprintf(f, '%s ', dec2base(i, 36));
end
fprintf(f, '\n');

for i = 1:n
  js = find(matrix(i,:));
  for j = js
    fprintf(f, '%s ', dec2base(j, 36));
  end
  fprintf(f, '\n');
end












