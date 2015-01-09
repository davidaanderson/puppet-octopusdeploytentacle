class octopustentacle (
	$apikey,
	$environment,
	$instancename,
	$publichostname,
	$serveraddress,
	$thumbprint,
	$port = $octopustentacle::params::port,
	$role = $octopustentacle::params::role,
) inherits octopustentacle::params {
	
	Exec {
		path => [ 'C:\\Program Files\\Octopus Deploy\\Tentacle\\' ],
	}
	
	package { 'octopusdeploy.tentacle' :
		ensure => present,
	}
	
	exec { 'CreateTentacleInstance' :
		command => "Tentacle.exe create-instance --instance \"${instancename}\" --config \"C:\\Octopus\\${instancename}\\${instancename}.config\" --console",
		creates => "C:\\Octopus\\${instancename}\\${instancename}.config",
		require => Package['octopusdeploy.tentacle'],
	}
	
	exec { 'CreateNewCertificate' : 
		command => "Tentacle.exe new-certificate --instance \"${instancename}\" --console",
		require => Exec['CreateTentacleInstance'],
	}
	
	exec { 'SetTentacleHome' :
		command => "Tentacle.exe configure --instance \"${instancename}\" --home \"C:\\Octopus\" --console",
		require => Exec['CreateTentacleInstance'],
		before => Exec['RegisterWithServer'],
	}
	
	exec { 'SetApplication' :
		command => "Tentacle.exe configure --instance \"${instancename}\" --app \"C:\\Octopus\\Applications\" --console",
		require => Exec['CreateTentacleInstance'],
		before => Exec['RegisterWithServer'],
	}
	
	exec { 'SetPort' : 
		command => "Tentacle.exe configure --instance \"${instancename}\" --port \"${port}\" --console",
		require => Exec['CreateTentacleInstance'],
		before => Exec['RegisterWithServer'],
	}
	
	exec { 'SetThumbprint' :
		command => "Tentacle.exe configure --instance \"${instancename}\" --trust \"${thumbprint}\" --console",
		require => Exec['CreateTentacleInstance'],
		before => Exec['RegisterWithServer'],
	}
	
	exec { 'RegisterWithServer' :
		command => "Tentacle.exe register-with --instance \"${instancename}\" --server \"${serveraddress}\" --publichostname=\"${publichostname}\" --apiKey=\"${apikey}\" --role \"${role}\" --environment \"${environment}\" --comms-style TentaclePassive --force --console",
		require => [ 
			Exec['CreateTentacleInstance'],
			Exec['CreateNewCertificate'], 
			Exec['SetPort'], 
			Exec['SetThumbprint'] ],
	}
	
	exec { 'StartService' :
		command => "Tentacle.exe service --instance \"${instancename}\" --install --start --console",
		require => Exec['RegisterWithServer'],
	}
}









