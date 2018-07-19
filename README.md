# Receive Connector Migration Tool
This PowerShell module allows an administrator to easily migrate receive connectors from one Exchange server to another. Having an automated method to do the migration of receive connectors can help tremendously, if there a large number of connectors, or the connectors have a large number of 'remote IP addresses'.

## Usage Instructions
### Download and Installation
*Note: You must do this on both the source and target server*
1. Download the repository from git.vtechamerica.com, and unzip it if necessary.
2. Open the "Exchange Management Shell"
3. Switch to the directory where the unziped module is located
```Powershell
PS> cd C:\Users\JSmith\Downloads
```
4. Import the module into the PowerShell session
```Powershell
PS> Import-Module .\Receive-Connector-Migrator
```

### Exporting the Receive Connectors on the Source Server
*After importing the module on the source Exchange server:*

1. Run `Export-ReceiveConnector` and *optionally* specify an output path. If no output path is specified, the file will be named 'Exported-Receive-Connectors.xml' and placed in the current user's directory.
```Powershell
PS> Export-ReceiveConnector -Path ".\Export.xml"
Attempting to export the receive connectors to disk...
Succesfully exported the receive connectors to C:\Users\JSmith\Downloads\Export.xml
```
 OR

1. Export specific receive connectors by piping in objects from `Get-ReceiveConnector`.
```Powershell
PS> Get-ReceiveConnector -Name "Default*" | Export-ReceiveConnector -Path ".\Export.xml"
Attempting to export the receive connectors to disk...
Succesfully exported the receive connectors to C:\Users\JSmith\Downloads\Export.xml
```

### Importing the Receive Connectors on the Target Server
*After importing the module on the target Exchange server:*

1. Run `Import-ReceiveConnector` and specify the path to the export file that was generated by `Export-ReceiveConnector`. You will need to copy this file over from the source server by hand, as importing the file over the network has not been tested.
```Powershell
PS> Import-ReceiveConnector -Path C:\Export.xml
```

2. Verify that the new receive connectors have been created on the target server by running:
```Powershell
PS> Get-ReceiveConnector
```

*NOTE: The imported receive connectors will be imported in disabled mode for safety reasons. You MUST enable them by hand or via another PowerShell call.*
