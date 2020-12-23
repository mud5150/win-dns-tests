# win-dns-test
This is a windows dns server container intended to be used for integration tests. The container is setup with the required environment variables for [DNSControl](https://github.com/StackExchange/dnscontrol) integration testing. 

The `repo_packed` tag was build to include [DNSControl](https://github.com/StackExchange/dnscontrol) source with `go get -d`

## Dependencies info
GOPATH is: `C:\Users\ContainerAdministrator\go\`
Running `go get -d github.com/StackExchange/dnscontrol` will hence place the integration tests at 
`C:\Users\ContainerAdministrator\go\src\github.com\StackExchange\dnscontrol\integrationTest`

## Subtle weirdness
If you attempt to use the `AD_SERVER` environment variable in the docker command, it must be escaped with a backtick '`' 
so that it's not evaluated until the entrypoint script runs. This variable, as well as the example.com dns zone, 
must be created at runtime since the server name changes for each container instance. 

## Running in docker
Aside from the subtle weirdness noted above, the container can be executed normally and as expected.  If run as a background process it will terminate after one hour, as determined by the default CMD. 

You can run the container as a background process thusly  
```docker run --rm -d mud5150/win-dns:latest```

And passing a command   
```docker run --rm mud5150/win-dns:latest ping -t 1.1.1```

And finally interactively  
```docker run --rm -it mud5150/win-dns:latest powershell```

## Running in ACI
I am attempting to leverage Azure ACI since github actions doesn't support running windows containers. 

To run on ACI  
```az container create --resource-group <resource_group_name> --name <instance_name> --image mud5150/win-dns --os-type windows --cpu 2 --memory 4```

To connect to shell. `exec` does appear to *work* with windows containers, but the screen draw is pretty flaky.  
```az container exec -g <resource_group_name> --name <instance_name> --container-name <instance_name> --exec-command "powershell"```