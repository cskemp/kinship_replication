function sts = subtreespecs(ts)

t1all = ts{12}{1};
t1focals = ts{12}{1}(ts{12}{2});

for i = [14:19]
  alli = ts{i}{1};
  focals = ts{i}{2};
  absfocals = alli(focals);
  for j = 1:length(absfocals)
    % sts{12}{k} is tree k expressed as focalinds within full tree 12
    sts{12}{i}(j) = find(t1focals==absfocals(j));
  end
end


