function ts = maketreespecs()

% Tree specifications

% 12: everything plus niblings. Ghost female-speaker niblings
% 13: minimal cousin tree. Ghost grandparents.
% 14: niblings
% 15: gp
% 16: gc
% 17: aunts
% 18: siblings
% 19: uncles

% when adding new trees, label all the individuals in female speaker tree
% (except self) before all the individuals in male speaker tree.


% --------------
% everything plus niblings
ts{12}{1} = [ 9:12, 13:22, 31:34, 43:52, 53:56,...
              65:68,69:78, 87:90, 99:108,109:112, 113:114];
% focal set F for tree 1 (indices with respect to the ordering in S)
ts{12}{2} = [1:18, 23:24, 29:64];
% --------------
% minimal cousin tree
ts{13}{1} = [ 9:12, 14,15,17,19,20,22,25:26,29:30,32,34,37:38,41:42,...
              65:68,70,71,73,75,76,78,81:82,85:86,88,90,93:94,97:98, 113:114];
% focal set F for tree 1 (indices with respect to the ordering in S)
ts{13}{2} = [5:20,25:40];

% --------------
% niblings
ts{14}{1} = [71,76, 87:90, 99:108, 113:114];
% focal set F for tree 1 (indices with respect to the ordering in S)
ts{14}{2} = [7:16];

% --------------
% grandparents. ghost mother, father
ts{15}{1} = [9:12,15,20,65:68, 71,76,113,114];
ts{15}{2} = [1:4,7:10];

% --------------
% grandchildren. ghost son, daughter 
ts{16}{1} = [47:48, 53:56, 103:104, 109:112, 113,114];
ts{16}{2} = [3:6,9:12];

% --------------
% aunts.
ts{17}{1} = [9:12, 13:15, 18:20, 65:68,69:71,74:76, 113,114 ];
ts{17}{2} = [5:9, 15:19];

% --------------
% siblings
ts{18}{1} = [ 15,20,31:34, 71,76, 87:90, 113, 114]; 
ts{18}{2} = [3:6,9:12 ];

% --------------
% uncles
ts{19}{1} = [9:12, 15:17, 20:22, 65:68, 71:73, 76:78, 113,114];
ts{19}{2} = [6:10, 16:20];


