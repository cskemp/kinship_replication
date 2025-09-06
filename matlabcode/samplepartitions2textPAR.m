function samplepartitions2text(compfile, x, ys, e, r, trees, ps)

load(compfile, 'exm_enum');

outpref= [ps.outdir, ps.linkoutpref, num2str(x),  '_', num2str(ys(1)), '_', num2str(ys(2)), '_', num2str(ys(3)), '_', num2str(e),  '_rpt', num2str(r), '.txt'];

suffixes = 'a':1:'z';

ncomp= size(exm_enum,1);
npeople = size(exm_enum,2);

nsuccess = 0;
ndiscard = 0;

indlist = zeros(1, npeople);
complist = zeros(1, ncomp);
partition = zeros(1, ncomp);

nsamplepersplit = ceil(ps.nsamplepartition/ps.nsamplesplit);

exm_enum = exm_enum;

%matlabpool('open', ps.parconf); 
%parfor sampi = 1:ps.nsamplesplit
%  outfile = [outpref, '__', suffixes(sampi)];
%  samplerandparts(outfile, sampi, nsamplepersplit, partition, ncomp, npeople, exm_enum);
%end
%matlabpool('close'); 

pool = gcp('nocreate'); % Get the current pool if it exists, but don't create one.
if isempty(pool)
    % No pool exists, so create one.
    numWorkers = ps.parconf;
    pool = parpool('local', ps.parnumWorkers);
    % Use onCleanup to ensure the new pool is closed when the function finishes.
    c = onCleanup(@() delete(pool));
end

parfor sampi = 1:ps.nsamplesplit
  outfile = [outpref, '__', suffixes(sampi)];
  samplerandparts(outfile, sampi, nsamplepersplit, partition, ncomp, npeople, exm_enum);
end

%
% combine output files
[ss, ww] = system(['cat ', outpref, '__?', '>', outpref]);


