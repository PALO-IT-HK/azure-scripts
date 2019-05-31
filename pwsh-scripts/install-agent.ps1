mkdir agent

cd agent

$version = "vsts-agent-win-x64-2.150.3.zip"

Invoke-WebRequest -Uri "https://vstsagentpackage.azureedge.net/agent/2.150.3/"$version -OutFile "C:\agent\"$version

Add-Type -AssemblyName System.IO.Compression.FileSystem

[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\agent\"$version, "$PWD")
