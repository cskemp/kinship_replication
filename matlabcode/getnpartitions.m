function n = getnpartitions(fid)

% get number of partitions 

fseek(fid,-100,'eof');

while 1
  tline = fgetl(fid);
  if length(tline) < 4 || ~strcmp(tline(1:4), 'Alto');
    continue;
  else
    ds = regexp(tline, '\d');
    l = find(ds(2:end)-ds(1:end-1) > 1);
    n = str2num(tline(ds(1):ds(1)+l-1));
    break;
  end
end

% rewind file
fseek(fid,0,-1);
