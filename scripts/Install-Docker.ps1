# iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Tuochenlyu/tuochenlyu.github.io/master/scripts/Install-Docker.ps1'))

# Install the OneGet PowerShell module. Install DockerMsftProvider package.
if(!(Get-Package DockerMsftProvider -ErrorAction SilentlyContinue)) {
    Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
    $shouldRestart = $true
}

# Use OneGet to install the latest version of Docker.
Install-Package -Name docker -ProviderName DockerMsftProvider -Confirm:$false

# When the installation is complete, reboot the computer.
if($shouldRestart) {
    Restart-Computer -Force
}
if(Get-Package Docker -ErrorCorrection SilentlyContinue) {
    docker pull mcr.microsoft.com/dotnet/core/samples:aspnetapp
    docker pull mcr.microsoft.com/dotnet/core/aspnet
    docker pull mcr.microsoft.com/dotnet/core/runtime
    docker pull mcr.microsoft.com/dotnet/core/runtime-deps
    docker pull mcr.microsoft.com/dotnet/core/samples
    docker pull mcr.microsoft.com/dotnet/core/sdk
    docker pull python
    docker pull golang
    docker pull hello-world
    docker pull mcr.microsoft.com/azure-cli
    docker pull mcr.microsoft.com/mssql/server
    docker pull redis
    docker pull couchbase
    docker pull ubuntu
    docker pull postgres
    docker pull traefik
    docker pull busybox
    docker pull nginx
    docker pull mariadb
    docker pull httpd
    docker pull registry
    docker pull docker
    docker pull centos
    docker pull rabbitmq
    docker pull golang
    docker pull consul
    docker pull openjdk
    docker pull python
    docker pull tomcat
    docker pull jenkins
    docker pull kibana
    docker pull mcr.microsoft.com/azure-cognitive-services/sentiment

    docker pull mono
    docker pull gcc
    docker pull ubuntu
    docker pull centos
    docker pull fedora
    docker pull openjdk
    docker pull busybox
    docker pull jenkins
    docker pull consul
    docker pull elasticsearch:7.9.0
    docker pull jekyll/jekyll

    # Windows containers
    docker pull mcr.microsoft.com/windows/nanoserver:2004
    docker pull mcr.microsoft.com/windows:2004
    docker pull mcr.microsoft.com/windows/servercore:2004
    docker pull mcr.microsoft.com/dotnet/runtime
    docker pull mcr.microsoft.com/dotnet/framework/aspnet
    docker pull mcr.microsoft.com/dotnet/framework/sdk
    docker pull mcr.microsoft.com/dotnet/framework/runtime
    docker pull mcr.microsoft.com/dotnet/framework/wcf
    docker pull mcr.microsoft.com/dotnet/framework/samples
    docker pull mcr.microsoft.com/windows/servercore/iis
    docker pull microsoft/dynamics-nav
    docker pull mcr.microsoft.com/windows/servercore:ltsc2019
}


