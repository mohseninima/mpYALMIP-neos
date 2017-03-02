function uninstall_sdpa_gmp_neos(varargin)

% UNINSTALL_SDPA_GMP_NEOS
%
% UNINSTALL_SDPA_GMP_NEOS removes support for the multiple-precision 
% SDPA-GMP solver using NEOS server from YALMIP, resetting it to its 
% original state.

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
% REMOVE UTILS FROM MATLAB PATH
% ----------------------------------------------------------------------- %
rmpath([pwd,filesep,'utils',filesep]);
savepath;

% ----------------------------------------------------------------------- %
% REMOVE SDPA-GMP NEOS CALLER FUNCTION FROM YALMIP/solvers/
% ----------------------------------------------------------------------- %
fpath = fileparts(which('callsdpagmp_neos'));
success = movefile([fpath,filesep,'callsdpagmp_neos.m'],[pwd,filesep,'callsdpagmp_neos.m']);
if ~success;
    error('Could not remove callsdpagmp_neos.m from YALMIP.')
end

% ----------------------------------------------------------------------- %
% REMOVE SDPA-GMP NEOS FROM LIST OF SUPPORTED SOLVERS
% ----------------------------------------------------------------------- %
fname = which('definesolvers');
delete(fname);

% reinstall backup copy of the original YALMIP file
fpath = fileparts(fname);
success = movefile([fpath,filesep,'definesolvers_original.m'],fname);
if ~success;
    error('Could not restore the original copy of definesolvers.m')
end

% ----------------------------------------------------------------------- %
% CLEAR YALMIP CACHED SOLVERS
% ----------------------------------------------------------------------- %
clear('compileinterfacedata.m')

end