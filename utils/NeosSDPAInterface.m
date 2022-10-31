% NEOS server interface to SDPA-GMP solver based on matlabneos (https://github.com/wannesvl/matlabneos)
classdef NeosSDPAInterface
    properties
        client
    end
    methods
        function neos = NeosSDPAInterface(host, port)
            fpath = fileparts(which('NeosSDPAInterface.m'));
            javaaddpath([fpath filesep 'xmlrpc-client-1.1.1.jar']);
            
            import redstone.xmlrpc.XmlRpcClient

            % Parse constructor arguments
            if nargin == 0
                host = 'https://neos-server.org';
                port = '3333';
            elseif nargin == 1
                port = '3333';
            end

            client = XmlRpcClient(strcat(host, ':', port), 0);
            status = client.invoke('ping', {});
            if ~strcmp(status, 'NeosServer is alive')
                error('Unable to connect to NEOS server. Check host and port. Are you connected to the internet?');
            end
            neos.client = client;            
        end        
      
        function queue = get_queue(this)
            queue = this.client.invoke('printQueue', {});
        end

        function submit_job(this, xml_string,filename)
            response = this.client.invoke('submitJob', {xml_string});
            job = response.get(0);
            password = response.get(1);
            this.client.invoke('getFinalResults', {job, password});

            % Query the webpage for the results
            url = sprintf('https://www.neos-server.org/neos/jobs/%d/%d.html', job - mod(job, 10000), job);
            result_page = urlread(url);
            result = regexp(result_page, '(?<=<pre>).*(?=<\/pre>)', 'match');       
            
            % Open file
            fid=fopen(filename, 'w');
            if fid == -1
                 error('Failed to open %s.', filename);
            end
            fprintf(fid,'%s',result{1});
            fclose(fid);            
        end
    end
end
