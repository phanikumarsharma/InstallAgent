param( 
    [parameter(Mandatory=$true)] 
    [ValidateNotNullOrEmpty()] 
    [string]$WorkSpaceID, 
 
    [parameter(Mandatory=$true)] 
    [ValidateNotNullOrEmpty()] 
    [string]$WorkSpaceKey 
) 
 
# Set the parameters 
 $FileName = "MMASetup-AMD64.exe" 
 $LogAnalyticsAgentFolder = 'C:\LogAnalytics' 
 $MMAFile = $LogAnalyticsAgentFolder + "\" + $FileName 
 
# Check if folder exists, if not, create it 
 if (Test-Path $LogAnalyticsAgentFolder){ 
 Write-Host "The folder $LogAnalyticsAgentFolder already exists." 
 }  
 else  
 { 
 Write-Host "The folder $LogAnalyticsAgentFolder does not exist, creating..." -NoNewline 
 New-Item $LogAnalyticsAgentFolder -type Directory | Out-Null 
 Write-Host "$LogAnalyticsAgentFolder is created successfully"  
 } 
 
# Set the location to the specified folder 
 Set-Location $LogAnalyticsAgentFolder 
 
# Check if file exists, if not, download it 
 if (Test-Path $FileName){ 
 Write-Host "The file $FileName already exists." 
 } 
 else 
 { 
 Write-Host "The file $FileName does not exist, downloading..." -NoNewline 
 $URL = "http://download.microsoft.com/download/F/4/5/F45B6296-32EC-4615-99E3-72C97EDE7613/MMASetup-AMD64.exe" 
 Invoke-WebRequest -Uri $URl -OutFile $MMAFile | Out-Null 
 Write-Host "Agent is successfully downloaded to the $LogAnalyticsAgentFolder...."
 } 
  
# Install the Microsoft Monitoring Agent 
 Write-Host "Installing Microsoft Monitoring Agent..."  
 $ArgumentList = '/C:"setup.exe /qn ADD_OPINSIGHTS_WORKSPACE=1 '+  "OPINSIGHTS_WORKSPACE_ID=$WorkspaceID " + "OPINSIGHTS_WORKSPACE_KEY=$WorkSpaceKey " +'AcceptEndUserLicenseAgreement=1"' 
 Start-Process $FileName -ArgumentList $ArgumentList -ErrorAction Stop -Wait | Out-Null 
 Write-Host "Microsoft Monitoring Agent is successfully installed..."
 
