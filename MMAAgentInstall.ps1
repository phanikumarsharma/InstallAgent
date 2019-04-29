param( 
    [parameter(Mandatory=$true)] 
    [ValidateNotNullOrEmpty()] 
    [string]$WorkSpaceID, 
 
    [parameter(Mandatory=$true)] 
    [ValidateNotNullOrEmpty()] 
    [string]$WorkSpaceKey 
) 

# Set the default parameters 
 $FileName = "MMASetup-AMD64.exe" 
 $MMAFolder = 'C:\Microsoft Monitoring Agent' 
 $MMAFile = $MMAFolder + "\" + $FileName 
 $MMAInstallAgentDowloadURI = "http://download.microsoft.com/download/F/4/5/F45B6296-32EC-4615-99E3-72C97EDE7613/MMASetup-AMD64.exe" 
 $path= Get-ChildItem -Path "C:/"
# Check if folder exists, if not exist create a folder
 if(!(Test-Path -Path $MMAFolder )){ 
     Write-Host "The folder $MMAFolder does not exist, creating..." 
     New-Item $MMAFolder -type Directory | Out-Null 
     Write-Host "$MMAFolder is created successfully"  
 }

# Set the location to the specified folder 
 Set-Location $MMAFolder 
 
# Check if file exists, if not, download it 
 if (!($FileName -in $MMAFolder)){ 
    Invoke-WebRequest -Uri $MMAInstallAgentDowloadURI -OutFile $MMAFile | Out-Null 
    Write-Host "Agent is successfully downloaded to the $MMAFolder...."
 } 
# Install the Microsoft Monitoring Agent (MMA)
 Write-Host "Installing Microsoft Monitoring Agent..."  
 $ArgumentList = '/C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 '+  "OPINSIGHTS_WORKSPACE_ID=$WorkspaceID " + "OPINSIGHTS_WORKSPACE_KEY=$WorkSpaceKey " +'AcceptEndUserLicenseAgreement=1"' 
 Start-Process $FileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null 
 Write-Host "Microsoft Monitoring Agent is successfully installed..."
