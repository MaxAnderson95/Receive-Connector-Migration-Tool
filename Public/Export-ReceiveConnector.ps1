<#

    .SYNOPSIS
    Exports receive connector objects to a file

    .DESCRIPTION
    Exports receive connector objects from an Exchange server to a CLIXML file, for the purposes of re-importing them on a different Exchange server.

    .PARAMETER ReceiveConnector
    Accepts a receive connector object or an array of objects, and specifically exports only those. It also accepts pipeline input from Get-ReceiveConnector.

    .PARAMETER Path
    The file path where to output the CLIXML file. The default value is a file named "Exported-Receive-Connectors.xml" in the current user profile directory.

    .EXAMPLE
    PS> Export-ReceiveConnector
    Attempting to export the receive connectors to disk...
    Succesfully exported the receive connectors to C:\Users\JSmith\Exported-Receive-Connectors.xml

    .EXAMPLE
    PS> Get-ReceiveConnector -Identity "Default*" | Export-ReceiveConnector
    Attempting to export the receive connectors to disk...
    Succesfully exported the receive connectors to C:\Users\JSmith\Exported-Receive-Connectors.xml

    .EXAMPLE
    PS> Export-ReceiveConnector -Path C:\Export.xml
    Attempting to export the receive connectors to disk...
    Succesfully exported the receive connectors to C:\Export.xml


#>

Function Export-ReceiveConnector {

    [CmdletBinding()]
    Param (

        [Parameter(Position=0,ValueFromPipeline=$True)]
        [Microsoft.Exchange.Data.Directory.SystemConfiguration.ReceiveConnector[]]$ReceiveConnector,

        [Parameter(Position=1)]
        [ValidateScript({
            #If the specified path is a folder
            If (($_ | Test-Path -PathType Container) -eq $True) {

                Throw "Folder paths are not supported. You must specify a file path."

            }
            #If the specified path is a file
            Else {

                #Take the file path, and grab the preceding directory portion and test to see if it exists.
                If (((Split-Path $_) | Test-Path ) -eq $True) {

                    #Test the same preceding directory portion of the path and test to see if it exists.
                    If (((Split-Path $_) | Test-Path) -eq $False) {

                        Throw "Directory specified not found!"
    
                    }
                    Else {

                        #If the specified file extension is not a .xml file
                        If ((($_ | Split-Path -Leaf).Split(".")[-1]) -ne 'xml') {

                            Throw "Specified file extension must be .xml!"

                        }
                        Else {
    
                            Return $True

                        }
                    
                    }

                }
                Else {

                    Throw "Directory and file specified not found!"

                }

            }
        })]
        [System.IO.FileInfo]$Path = "$env:userprofile\Exported-Receive-Connectors.xml"

    )

    Begin {

        #Create a variable to hold the connector objects
        $ConnectorsArray = @()

    }

    Process {

        #Get a list of recieve connectors

        #If specific recieve connectors are specified
        If ($ReceiveConnector) {

            Write-Verbose "A specific receive connector was specified."

            #Add the inputted receive connectors to the connectors array
            $ConnectorsArray += $ReceiveConnector

        }
        #If no specific receive connecots are specified, all recieve connectors on the server are gathered
        Else {

            Write-Verbose "No specific receive connector was specified. Getting all available connectors on this server."

            Try {
                
                $Connectors = Get-ReceiveConnector
            
            } 
            Catch {

                Write-Error $_
                Break

            }

            #Add the receive connectors to the connectors array
            $ConnectorsArray += $Connectors

        }

    }

    End {

        #Attempt to export the receive connector onbjects to a clixml file
        Try {

            Write-Host "Attempting to export the receive connectors to disk..." -ForegroundColor DarkCyan
            $ConnectorsArray | Export-Clixml -Path $Path
        
        }

        Catch {

            Write-Error $_
            Break

        }

        Write-Host "Successfully exported the receive connectors to $Path" -ForegroundColor DarkCyan
        Write-Host "Gather the file, and use Import-ReceiveConnector to import them on the new server." -ForegroundColor DarkCyan

    }

}
