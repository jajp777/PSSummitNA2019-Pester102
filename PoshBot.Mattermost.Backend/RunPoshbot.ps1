# Import necessary modules
Import-Module PoshBot
. "$PSScriptRoot\build.ps1" compile
Import-Module "$PSScriptRoot\out\PoshBot.Mattermost.Backend\0.0.1\PoshBot.Mattermost.Backend.psd1"

# Store config path in variable
$tmpPath = "$PSScriptRoot\tmp\mm"
$configPath = "$tmpPath\MMConfig.psd1"



# Please copy the access token below. You won't be able to see it again!

# Token Description: BOT
# Token ID: d9jwzmfcpffi3ck94mzfcrz8ta
# Access Token: jjm4stwjtigf8n5hzqr9yppy4o


# Create hashtable of parameters for New-PoshBotConfiguration
$botParams = @{
  # The friendly name of the bot instance
  Name                   = 'MMMBop'
  # The primary email address(es) of the admin(s) that can manage the bot
  BotAdmins              = @('user2')
  # Universal command prefix for PoshBot.
  # If the message includes this at the start, PoshBot will try to parse the command and
  # return an error if no matching command is found
  CommandPrefix          = '!'
  # PoshBot log level.
  LogLevel               = 'Debug'
  # The path containing the configuration files for PoshBot
  ConfigurationDirectory = "$tmpPath"
  # The path where you would like the PoshBot logs to be created
  LogDirectory           = "$tmpPath"
  # The path containing your PoshBot plugins
  PluginDirectory        = "$tmpPath\Plugins"

  BackendConfiguration   = @{
    Token = 'kn4skudrk3g9bnoy9kagsgn69e'
    ApiUri = 'http://localhost:8065'
    # This is the PSGSuite config name that you would like the GChat backend to run under.
    # This config needs to have access to the Sheet set up as the Message Queue
    #ConfigName       = "mydomain"
    # This is the FileID of the Sheet set up as the Message Queue
    #SheetId          = "1H7mJoKflklakoJKDSwo923lsdO5sK3mjg"
    # How frequently you'd like to poll the Sheet for new messages.
    # If this is greater than 1000, it's treated as milliseconds, otherwise it's treated as seconds
    #PollingFrequency = 1500
    # The friendly name for the backend
    Name             = 'MattermostBackend'
  }
}


Get-ChildItem $tmpPath -Filter *.log* | Remove-Item -Force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null

# Create the bot backend
$backend = New-PoshBotMatterMostBackend -Configuration $botParams.BackendConfiguration

# Create the bot configuration
$myBotConfig = New-PoshBotConfiguration @botParams

# Save bot configuration
Save-PoshBotConfiguration -InputObject $myBotConfig -Path $configPath -Force

# Create the bot instance from the backend and configuration path
$bot = New-PoshBotInstance -Backend $backend -Path $configPath

$VerbosePreference = 'Continue'

# Start the bot
$bot | Start-PoshBot
