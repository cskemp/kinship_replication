function [preds, rinds] = componentbase(ps)

% Define predicates that will be used to enumerate components

% Dependencies:
%    numbers correspond to the master tree
%    makeanalysisspecs relies on the predicates here and their listed order

n = 114;

preds{1}= logical(zeros(2,n));

femaleind = [1,3,5,7,9,11,13,14,15,18,19,23,25,27,29,31,32,35,37,39,41,43,45,47,49,51,53,55, 57,59,61,63,65,67,69,70,71,74,75,79,81,83,85,87,88,91,93,95,97,99,101,103,105,107,109,111,113];

	      % parents % children
parentpairs = { [1,2],  [9]; 
                [3,4],  [10]; 
                [5,6],  [11]; 
                [7,8],  [12]; 
                [9,10], [13:17]; 
                [11,12],[18:22]; 
                [13],   [23:24]; 
                [14],   [25:26]; 
                [16],   [27:28]; 
                [17],   [29:30]; 
                [18],   [35:36]; 
                [19],   [37:38]; 
                [21],   [39:40]; 
                [22],   [41:42]; 
                [31],   [43:44]; 
                [32],   [45:46]; 
                [33],   [49:50]; 
                [34],   [51:52]; 
                [47],   [53:54]; 
                [48],   [55:56]; 
		};
l = length(parentpairs);
offset = 56;
for i = 1:l
  parentpairs{l+i, 1} = offset + parentpairs{i,1};
  parentpairs{l+i, 2} = offset + parentpairs{i,2};
end
parentpairs = [ parentpairs;
                {113},     {47:48}; 
                {[15,20]}, {[31,32,113,33,34]}; 
		{114},     {[103:104]};
		{[71,76]}, {[87,88,114,89,90]};
	        ];

% individuals assumed to be the same age
agegroups  = { [1:8, 57:64];
	       [9:12, 65:68];
	       [14,17,19,22,70,73,75,78];
	       [15,20,71,76];
	       [13,16,18,21,69,72,74,77];
	       [32,34,88,90];
	       [23:30, 113, 35:42,79:86,114,91:98];
	       [31,33,87,89];
	       [43:52, 99:108];
	       [53:56, 109:112]
	    };

%--------------------------------------
% Unary predicates: female, male

preds{1}(1, femaleind) = 1;

maleind = setdiff(1:n, femaleind);
preds{1}(2, maleind)   = 1;

fvec = preds{1}(1,:);
mvec = preds{1}(2,:);

%--------------------------------------
% Binary predicates: 

% 1. parent        2. child	    3. same sex	     4. diff sex 
% 5. older         6. younger	    7. identity	     8. non-identity 
% 9. siblingself  10. sibling	   11. mother	    12. father 
%13. daughter     14. son          15. ancestor     16. descendant
%17. sister       18. brother      19. femalesibsel 20. malesibsel
%21. young sist   22. young bro    23. old sis      24. old bro
%25. young sib    26. old sib      27. mother'      28. father'
%29. daughter'    30. son'	   31. motherdau    32. motherson
%33. fatherdau    34. fatherson    35. samesexsib   36. diffsexsib
%37. grandparent  38. matgrandp    39. patgrandp    40. ssparent
%41. dsparent     42. parentoff    43. parentofm    44. motheroff 
%45. motherofm    46. fatheroff    47. fatherofm    48. sschild
%49. dschild      50. childoff     51. childofm     52. daughteroff
%53. daughterofm  54. sonoff	   55. sonofm       56. sssib
%57. dssib        58. sibofff      59. sibofm       60. sisoff 
%61. sisofm       62. brooff 	   63. broofm       64. matlinanr
%65. patlinarn    66. sslinanr     67. dslinanr     68. parentoffanr
%69. parentofmanr 70. motheroffanr 71. motherofmanr 72. fatheroffanr
%73. fatherofmanr 74. daughtdsc    75. sondsc       76. sschilddsc
%77. dschilddsc   78. childoffdsc  79. childofmdsc  80. daughtroffdsc
%81. dauterofmdsc 82. sonoffdsc    83. sonofmdsc       


nonid = not(logical(eye(n)));

nbinpred = 39;

preds{2} = logical(zeros(n,n,nbinpred));
emptypred = logical(zeros(n,n));

% 1.  Parent
preln = emptypred;
for i = 1:length(parentpairs)
  preln(parentpairs{i,1}, parentpairs{i,2}) = 1;
end
preds{2}(:,:,1) = preln;

% 2.  Child
preds{2}(:,:,2) = transpose(preln);

% 3.  Same sex
samesex= emptypred;
samesex(maleind,  maleind) = 1;
samesex(femaleind,femaleind) = 1;
preds{2}(:,:,3) = samesex & nonid;

% 4.  Diff sex
diffsex = emptypred;
diffsex(maleind,femaleind) = 1;
diffsex(femaleind,maleind) = 1;
preds{2}(:,:,4) = diffsex;

% 5.  Older
older = emptypred;
inds = triu(ones(length(agegroups)),1);
[r,c] = find(inds);

for i = 1:length(c)
  older(agegroups{r(i)},agegroups{c(i)}) = 1; 
end
preds{2}(:,:,5) = older;
% 6.  Younger
preds{2}(:,:,6) = transpose(older);

% 7.  Identity
preds{2}(:,:,7) = logical(eye(n));

% 8.  Non-identity
preds{2}(:,:,8) = not(preds{2}(:,:,7));

% 9.  Siblingself
dpreln = double(preln);
preds{2}(:,:,9) = logical(transpose(dpreln)*dpreln);

% 10. Sibling
preds{2}(:,:,10) = preds{2}(:,:,9) & preds{2}(:,:,8);

mreln = emptypred;
mreln(maleind,:) = 1;
freln = emptypred;
freln(femaleind,:) = 1;

% 11. Mother
preds{2}(:,:,11) = preln & freln;

% 12. Father
preds{2}(:,:,12) = preln & mreln;

% 13. Daughter
preds{2}(:,:,13) = preds{2}(:,:,2) & freln;

% 14. Son
preds{2}(:,:,14) = preds{2}(:,:,2) & mreln;

% 15. Ancestor
dpreln = double(preln)|eye(n);
% NB: preln can't have any self-links, so we don't need to replace them
preds{2}(:,:,15) = logical(dpreln^ps.tclosuremax & (ones(n)-eye(n)));

% 16. Descendant
dcreln = double(preds{2}(:,:,2))|eye(n);
% NB: creln can't have any self-links, so we don't need to replace them
preds{2}(:,:,16) = logical(dcreln^ps.tclosuremax & (ones(n)-eye(n)));

% 17. Sister
preds{2}(:,:,17) = preds{2}(:,:,10) & repmat(preds{1}(1,:)', 1, n);

% 18. Brother
preds{2}(:,:,18) = preds{2}(:,:,10) & repmat(preds{1}(2,:)', 1, n);

% 19. Female self-sib
preds{2}(:,:,19) = preds{2}(:,:,9) & repmat(preds{1}(1,:)', 1, n);

% 20. Male self-sib
preds{2}(:,:,20) = preds{2}(:,:,9) & repmat(preds{1}(2,:)', 1, n);

% 21. Younger sister
preds{2}(:,:,21) = preds{2}(:,:,17) & preds{2}(:,:,6);

% 22. Younger brother
preds{2}(:,:,22) = preds{2}(:,:,18) & preds{2}(:,:,6);

% 23. Older sister
preds{2}(:,:,23) = preds{2}(:,:,17) & preds{2}(:,:,5);

% 24. Older brother
preds{2}(:,:,24) = preds{2}(:,:,18) & preds{2}(:,:,5);

% 25. Younger sibling
preds{2}(:,:,25) = preds{2}(:,:,10) & preds{2}(:,:,6);

% 26. Older sibling 
preds{2}(:,:,26) = preds{2}(:,:,10) & preds{2}(:,:,5);

% 27. Child of female 
preds{2}(:,:,27) = preds{2}(:,:,2) & repmat(preds{1}(1,:), n, 1);

% 28. Child of male
preds{2}(:,:,28) = preds{2}(:,:,2) & repmat(preds{1}(2,:), n, 1);

% 29. Parent of female 
preds{2}(:,:,29) = preds{2}(:,:,1) & repmat(preds{1}(1,:), n, 1);

% 30. Parent of male
preds{2}(:,:,30) = preds{2}(:,:,1) & repmat(preds{1}(2,:), n, 1);

% 31. mother of daughter
preds{2}(:,:,31) = preds{2}(:,:,11) & repmat(preds{1}(1,:), n, 1);

% 32. mother of son
preds{2}(:,:,32) = preds{2}(:,:,11) & repmat(preds{1}(2,:), n, 1);

% 33. father of daughter
preds{2}(:,:,33) = preds{2}(:,:,12) & repmat(preds{1}(1,:), n, 1);

% 34. father of son
preds{2}(:,:,34) = preds{2}(:,:,12) & repmat(preds{1}(2,:), n, 1);

% 35. Same sex sibling
preds{2}(:,:,35) = preds{2}(:,:,10) & preds{2}(:,:,3);

% 36. Diff sex sibling 
preds{2}(:,:,36) = preds{2}(:,:,10) & preds{2}(:,:,4);

% 37. Grandparent 
dpreln = double(preln);
preds{2}(:,:,37) = logical(dpreln*dpreln);

% 38. Maternal grandparent
dmumreln = double(preds{2}(:,:,11));
preds{2}(:,:,38) = logical(dpreln*dmumreln);

% 39. Paternal grandparent
ddadreln= double(preds{2}(:,:,12));
preds{2}(:,:,39) = logical(dpreln*ddadreln);

% 40. Same sex parent
preds{2}(:,:,40) = preds{2}(:,:,1) & preds{2}(:,:,3);

% 41. Diff sex parent
preds{2}(:,:,41) = preds{2}(:,:,1) & preds{2}(:,:,4);

mreln2 = emptypred;
mreln2(:, maleind) = 1;
freln2 = emptypred;
freln2(:, femaleind) = 1;

% 42. Parent of female
preds{2}(:,:,42) = preds{2}(:,:,1) & freln2; 

% 43. Parent of male
preds{2}(:,:,43) = preds{2}(:,:,1) & mreln2; 

% 44. Mother of female
preds{2}(:,:,44) = preds{2}(:,:,11) & freln2; 

% 45. Mother of male
preds{2}(:,:,45) = preds{2}(:,:,11) & mreln2; 

% 46. Father of female
preds{2}(:,:,46) = preds{2}(:,:,12) & freln2; 

% 47. Father of male
preds{2}(:,:,47) = preds{2}(:,:,12) & mreln2; 

% 48. Same sex child
preds{2}(:,:,48) = preds{2}(:,:,2) & preds{2}(:,:,3);

% 49. Diff sex child 
preds{2}(:,:,49) = preds{2}(:,:,2) & preds{2}(:,:,4);

% 50. child of female
preds{2}(:,:,50) = preds{2}(:,:,2) & freln2; 

% 51. child of male
preds{2}(:,:,51) = preds{2}(:,:,2) & mreln2; 

% 52. daughter of female
preds{2}(:,:,52) = preds{2}(:,:,13) & freln2; 

% 53. daughter of male
preds{2}(:,:,53) = preds{2}(:,:,13) & mreln2; 

% 54. son of female
preds{2}(:,:,54) = preds{2}(:,:,14) & freln2; 

% 55. son of male
preds{2}(:,:,55) = preds{2}(:,:,14) & mreln2; 

% 56. Same sex sibling
preds{2}(:,:,56) = preds{2}(:,:,10) & preds{2}(:,:,3);

% 57. Diff sex sibling 
preds{2}(:,:,57) = preds{2}(:,:,10) & preds{2}(:,:,4);

% 58. sibling of female
preds{2}(:,:,58) = preds{2}(:,:,10) & freln2; 

% 59. sibling of male
preds{2}(:,:,59) = preds{2}(:,:,10) & mreln2; 

% 60. sister of female
preds{2}(:,:,60) = preds{2}(:,:,17) & freln2; 

% 61. sister of male
preds{2}(:,:,61) = preds{2}(:,:,17) & mreln2; 

% 62. brother of female
preds{2}(:,:,62) = preds{2}(:,:,18) & freln2; 

% 63. brother of male
preds{2}(:,:,63) = preds{2}(:,:,18) & mreln2; 

% 64. matlinancestor
tmprln = double(preds{2}(:,:,11))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,64) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 65. patlinancestor
tmprln = double(preds{2}(:,:,12))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,65) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 66. sslinancestor 
tmprln = double(preds{2}(:,:,40))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,66) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 67. dslinancestor
tmprln = double(preds{2}(:,:,41))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,67) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 68. parent of female ancestor
tmprln = double(preds{2}(:,:,42))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,68) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 69. parent of male ancestor
tmprln = double(preds{2}(:,:,43))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,69) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 70. mother of female ancestor
tmprln = double(preds{2}(:,:,44))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,70) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 71. mother of male ancestor
tmprln = double(preds{2}(:,:,45))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,71) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 72. father of female ancestor
tmprln = double(preds{2}(:,:,46))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,72) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 73. father of male ancestor
tmprln = double(preds{2}(:,:,47))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,73) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 74. daughter descendant
tmprln = double(preds{2}(:,:,13))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,74) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 75. son descendant
tmprln = double(preds{2}(:,:,14))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,75) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 76. ss child descendant
tmprln = double(preds{2}(:,:,48))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,76) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 77. ds child descendant
tmprln = double(preds{2}(:,:,49))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,77) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 78. child of female descendant
tmprln = double(preds{2}(:,:,50))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,78) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 79. child of male descendant
tmprln = double(preds{2}(:,:,51))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,79) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 80. daughter of female ancestor
tmprln = double(preds{2}(:,:,52))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,80) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 81. daughter of male ancestor
tmprln = double(preds{2}(:,:,53))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,81) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 82. son of female ancestor
tmprln = double(preds{2}(:,:,54))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,82) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% 83. son of male ancestor
tmprln = double(preds{2}(:,:,55))|eye(n);
% NB: no self-links in base, so we don't need to replace them
preds{2}(:,:,83) = logical(tmprln^ps.tclosuremax & (ones(n)-eye(n)));

% enforce no self links
for i = 1:size(preds{2},3)
  preds{2}(:,:,i) = preds{2}(:,:,i)&nonid;
end

% cases where one predicate is the reciprocal of another

rinds = [zeros(1,8), 53,109,55,111, 45,43, 47, 101,99,  51,49, 103, 107,105,...
  25, 81,23,79, 37,93, 35,91,   32,31,88,87,  29,85, 27,83, 41,97,39,95,...
  14,70,13,69,  15, 71,  19, 75, 18, 74,  9, 65, 11, 67,...
  zeros(1,8), 54,110,56,112,  46,44, 48,  102,100,  52,50, 104, 108,106,...
  26,82,24,80,38,94,36,92, 34,33,90,89,  30,86,28,84, 42,98,40,96,...
  17,73,16,72,  20, 76,  22, 78, 21, 77, 10, 66, 12,68,...
  0,0];

