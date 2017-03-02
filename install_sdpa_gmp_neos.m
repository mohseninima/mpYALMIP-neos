function install_sdpa_gmp_neos(varargin)

% INSTALL_SDPA_GMP_NEOS
%
% INSTALL_SDPA_GMP_NEOS adds support for the multiple-precision SDPA-GMP solver 
% using NEOS solver to YALMIP. 
%
% ----------------------------------------------------------------------- %
%
%     Copyright (C) 2017 Hugo Tadashi
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% ----------------------------------------------------------------------- %

% ----------------------------------------------------------------------- %
% CHECK IF YALMIP IS INSTALLED
% ----------------------------------------------------------------------- %
% Copied and edited from yalmiptest.m, YALMIP
detected = which('yalmip.m','-all');
if isa(detected,'cell') && ~isempty(detected)
    if length(detected)>1
        disp('You seem to have multiple installations of YALMIP in your path:');
        disp(detected)
        disp('Please correct this, then run the installation again.');
        return
    end
else
    error(['A working version of YALMIP is required.\n '...
        'Please correct this, then run the installation again.']);
end

% ----------------------------------------------------------------------- %
% ADD SDPA-GMP-NEOS TO LIST OF SUPPORTED SOLVERS
% ----------------------------------------------------------------------- %
fname = which('definesolvers');

% make a backup copy of the original YALMIP file
fpath = fileparts(fname);
success = copyfile(fname,[fpath,filesep,'definesolvers_original.m']);
if ~success
    error('Could not back up the file definesolvers.m')
end

% Add solver definition to definesolvers.m
fid = fopen(fname,'a+'); fprintf(fid,'\n\n');
fprintf(fid,'%% %% ********************************************\n');
fprintf(fid,'%% %% DEFINE SDPA-GMP-NEOS AS A SOLVER - ADDED BY \n');
fprintf(fid,'%% %% install_sdpa_gmp_neos                       \n');
fprintf(fid,'%% %% ********************************************\n');
fprintf(fid,'solver(i) = sdpsolver;                            \n');
fprintf(fid,'solver(i).tag     = ''SDPA-GMP-NEOS'';            \n');
fprintf(fid,'solver(i).version = '''';                         \n');
fprintf(fid,'solver(i).checkfor= {''callsdpagmp_neos.m''};     \n');
fprintf(fid,'solver(i).call    = ''callsdpagmp_neos'';         \n');
fprintf(fid,'solver(i).constraint.equalities.linear = 0;       \n');
fprintf(fid,'i = i+1;                                          \n');
fclose(fid);


% ----------------------------------------------------------------------- %
% ADD SDPA-GMP CALLER FUNCTION TO YALMIP/solvers/
% ----------------------------------------------------------------------- %
fpath = fileparts(which('callsdpa'));
success = movefile('callsdpagmp_neos.m',[fpath,filesep,'callsdpagmp_neos.m']);
if ~success
    error('Could not copy callsdpagmp_neos.m to the correct location.')
end

% ----------------------------------------------------------------------- %
% ADD UTILS TO MATLAB PATH
% ----------------------------------------------------------------------- %
addpath([pwd,filesep,'utils',filesep]);
savepath;


% ----------------------------------------------------------------------- %
% CLEAR YALMIP CACHED SOLVERS
% ----------------------------------------------------------------------- %
clear('compileinterfacedata.m')


% ----------------------------------------------------------------------- %
% RUN MEX
% ----------------------------------------------------------------------- %
cd utils;
mex -silent sdpagmp_read_output.cpp
cd ..;
end