# mpYALMIP-neos

A [YALMIP](http://users.isy.liu.se/johanl/yalmip/) interface to the multiple-precision solver [SDPA-GMP](http://sdpa.sourceforge.net/download.html) 
using [NEOS server](https://neos-server.org/neos/).
Based on the code of [mpYALMIP](https://github.com/htadashi/mpYALMIP-neos) and [matlabneos](https://github.com/wannesvl/matlabneos).
The jar executable file provided in the utils folder is from [Redstone XML-RPC Library](http://xmlrpc.sourceforge.net/).


## Contents
- [Setup](#Setup)
- [Licence](#Licence)

## Setup<a name="Setup"></a>

Add `xmlrpc-client-1.1.1.jar` file to `javaclasspath`

    >> javaaddpath('/path_to_mpYALMIP-neos/utils/xmlrpc-client-1.1.1.jar')

Add SDPA-GMP to YALMIP by running

    >> install_sdpa_gmp_neos 
    
The installer will ask for a valid email address in order to use the NEOS XML-RPC interface

**Note:** please ignore any compilation warnings that might be displayed.


## Licence<a name="Licence"></a>
mpYALMIP is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

