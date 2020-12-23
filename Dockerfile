# escape=`

FROM mcr.microsoft.com/windows/servercore:10.0.17763.1158-amd64 

RUN powershell.exe -Command `
    Install-WindowsFeature -Name DNS -IncludeManagementTools; `
    Set-ExecutionPolicy Bypass -Scope Process -Force; `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco install git golang -y; `
    [Environment]::SetEnvironmentVariable('AD_DOMAIN', 'example.com',[System.EnvironmentVariableTarget]::Machine)
RUN go get -d github.com/StackExchange/dnscontrol
ADD entrypoint.ps1 c:/
ENTRYPOINT [ "powershell.exe", "-Command", "c:/entrypoint.ps1"]
CMD [ "sleep", "3600" ]