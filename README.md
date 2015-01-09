# Octopus Deploy Tentacle puppet module.

This module installs and configures an Octopus Deploy Tentacle.

## Installation

This module depends on the Chocolatey provider module to install Octopus Deploy:

* [chocolatey module](https://github.com/rismoney/puppet-chocolatey)

## Configuration

The installer supports the following options:

- apikey (required)
- environment (required)
- instancename (required)
- publichostname (required)
- serveraddress (required)
- thumbprint (required)
- port (optional, default = 10933)
- role (optional, default = ' ')

### Example
	class { 'octopustentacle' : 
		apikey => 'API-000AAA111BBB333CCC444DDD555',
		environment => 'Production',
		instancename => 'production',
		publichostname => '192.168.0.10',
		serveraddress => 'http://server.octopusdeploy.net/',
		thumbprint => '860d3448a431462da9b190d875220692',
		port => '10933',
		role => 'web-server',
	}

### Notes
#### instancename
The name of the installed Tentacle instance. The instance's config file will be created at ```C:\Octopus\<instancename>\<instancename>.config```.

#### port
The port number that the tentacle is listening on. This defaults to 10933.

#### publichostname
The publicly visible host name of the tentacle on which the server will communicate (if the host name of the machine is not suitable). must be ip or host, no http included

