
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Scope='Class', Target='*')]
class MattermostBackend : Backend {

    # The types of message that we care about from Mattermost
    # All othere will be ignored
    [string[]]$MessageTypes = @(
        'channel_updated'
        #'member_joined_channel'
        #'member_left_channel'
        'posted'
        #'pin_added'
        #'pin_removed'
        #'status_change' #'presence_change' maybe
        #'reaction_added'
        #'reaction_removed'
        #'star_added'
        #'star_removed'
    )

    [int]$MaxMessageLength = 4000

    # # Import some color defs.
    # hidden [hashtable]$_PSSlackColorMap = @{
    #     aliceblue = "#F0F8FF"
    #     antiquewhite = "#FAEBD7"
    #     aqua = "#00FFFF"
    #     aquamarine = "#7FFFD4"
    #     azure = "#F0FFFF"
    #     beige = "#F5F5DC"
    #     bisque = "#FFE4C4"
    #     black = "#000000"
    #     blanchedalmond = "#FFEBCD"
    #     blue = "#0000FF"
    #     blueviolet = "#8A2BE2"
    #     brown = "#A52A2A"
    #     burlywood = "#DEB887"
    #     cadetblue = "#5F9EA0"
    #     chartreuse = "#7FFF00"
    #     chocolate = "#D2691E"
    #     coral = "#FF7F50"
    #     cornflowerblue = "#6495ED"
    #     cornsilk = "#FFF8DC"
    #     crimson = "#DC143C"
    #     darkblue = "#00008B"
    #     darkcyan = "#008B8B"
    #     darkgoldenrod = "#B8860B"
    #     darkgray = "#A9A9A9"
    #     darkgreen = "#006400"
    #     darkkhaki = "#BDB76B"
    #     darkmagenta = "#8B008B"
    #     darkolivegreen = "#556B2F"
    #     darkorange = "#FF8C00"
    #     darkorchid = "#9932CC"
    #     darkred = "#8B0000"
    #     darksalmon = "#E9967A"
    #     darkseagreen = "#8FBC8F"
    #     darkslateblue = "#483D8B"
    #     darkslategray = "#2F4F4F"
    #     darkturquoise = "#00CED1"
    #     darkviolet = "#9400D3"
    #     deeppink = "#FF1493"
    #     deepskyblue = "#00BFFF"
    #     dimgray = "#696969"
    #     dodgerblue = "#1E90FF"
    #     firebrick = "#B22222"
    #     floralwhite = "#FFFAF0"
    #     forestgreen = "#228B22"
    #     fuchsia = "#FF00FF"
    #     gainsboro = "#DCDCDC"
    #     ghostwhite = "#F8F8FF"
    #     gold = "#FFD700"
    #     goldenrod = "#DAA520"
    #     gray = "#808080"
    #     green = "#008000"
    #     greenyellow = "#ADFF2F"
    #     honeydew = "#F0FFF0"
    #     hotpink = "#FF69B4"
    #     indianred = "#CD5C5C"
    #     indigo = "#4B0082"
    #     ivory = "#FFFFF0"
    #     khaki = "#F0E68C"
    #     lavender = "#E6E6FA"
    #     lavenderblush = "#FFF0F5"
    #     lawngreen = "#7CFC00"
    #     lemonchiffon = "#FFFACD"
    #     lightblue = "#ADD8E6"
    #     lightcoral = "#F08080"
    #     lightcyan = "#E0FFFF"
    #     lightgoldenrodyellow = "#FAFAD2"
    #     lightgreen = "#90EE90"
    #     lightgrey = "#D3D3D3"
    #     lightpink = "#FFB6C1"
    #     lightsalmon = "#FFA07A"
    #     lightseagreen = "#20B2AA"
    #     lightskyblue = "#87CEFA"
    #     lightslategray = "#778899"
    #     lightsteelblue = "#B0C4DE"
    #     lightyellow = "#FFFFE0"
    #     lime = "#00FF00"
    #     limegreen = "#32CD32"
    #     linen = "#FAF0E6"
    #     maroon = "#800000"
    #     mediumaquamarine = "#66CDAA"
    #     mediumblue = "#0000CD"
    #     mediumorchid = "#BA55D3"
    #     mediumpurple = "#9370DB"
    #     mediumseagreen = "#3CB371"
    #     mediumslateblue = "#7B68EE"
    #     mediumspringgreen = "#00FA9A"
    #     mediumturquoise = "#48D1CC"
    #     mediumvioletred = "#C71585"
    #     midnightblue = "#191970"
    #     mintcream = "#F5FFFA"
    #     mistyrose = "#FFE4E1"
    #     moccasin = "#FFE4B5"
    #     navajowhite = "#FFDEAD"
    #     navy = "#000080"
    #     oldlace = "#FDF5E6"
    #     olive = "#808000"
    #     olivedrab = "#6B8E23"
    #     orange = "#FFA500"
    #     orangered = "#FF4500"
    #     orchid = "#DA70D6"
    #     palegoldenrod = "#EEE8AA"
    #     palegreen = "#98FB98"
    #     paleturquoise = "#AFEEEE"
    #     palevioletred = "#DB7093"
    #     papayawhip = "#FFEFD5"
    #     peachpuff = "#FFDAB9"
    #     peru = "#CD853F"
    #     pink = "#FFC0CB"
    #     plum = "#DDA0DD"
    #     powderblue = "#B0E0E6"
    #     purple = "#800080"
    #     red = "#FF0000"
    #     rosybrown = "#BC8F8F"
    #     royalblue = "#4169E1"
    #     saddlebrown = "#8B4513"
    #     salmon = "#FA8072"
    #     sandybrown = "#F4A460"
    #     seagreen = "#2E8B57"
    #     seashell = "#FFF5EE"
    #     sienna = "#A0522D"
    #     silver = "#C0C0C0"
    #     skyblue = "#87CEEB"
    #     slateblue = "#6A5ACD"
    #     slategray = "#708090"
    #     snow = "#FFFAFA"
    #     springgreen = "#00FF7F"
    #     steelblue = "#4682B4"
    #     tan = "#D2B48C"
    #     teal = "#008080"
    #     thistle = "#D8BFD8"
    #     tomato = "#FF6347"
    #     turquoise = "#40E0D0"
    #     violet = "#EE82EE"
    #     wheat = "#F5DEB3"
    #     white = "#FFFFFF"
    #     whitesmoke = "#F5F5F5"
    #     yellow = "#FFFF00"
    #     yellowgreen = "#9ACD32"
    # }

    MattermostBackend ([string]$Token, [string]$ApiUri) {
      $secPwd = $Token | ConvertTo-SecureString -AsPlainText -Force
      $cred = New-Object System.Management.Automation.PSCredential('pat', $secPwd)
      $config = [ConnectionConfig]::new($ApiUri, $cred)
      $conn = [MattermostConnection]::New()
      $conn.Config = $config
      $this.Connection = $conn
    }

    # Connect to Slack
    [void]Connect() {
        $this.LogInfo('Connecting to Mattermost backend')
        $this.LogInfo('Listening for the following message types. All others will be ignored', $this.MessageTypes)
        $this.Connection.Connect()
        $this.BotId = $this.GetBotIdentity()
        $this.LoadUsers()
        $this.LoadRooms()
    }

    # Receive a message from the websocket
    [Message[]]ReceiveMessage() {
      $messages = New-Object -TypeName System.Collections.ArrayList
      try {
        # Read the output stream from the receive job and get any messages since our last read
        $jsonResult = $this.Connection.ReadReceiveJob()
        if ($null -ne $jsonResult -and $jsonResult -ne [string]::Empty) {
          $this.LogDebug('Received message', $jsonResult)

          # Strip out Slack's URI formatting - TODO Do we need this?
          $jsonResult = $this._SanitizeURIs($jsonResult)

          $mattermostMessages = @($jsonResult | ConvertFrom-Json)

          foreach ($mmMessage in $mattermostMessages) {
            # TODO Don't know what this is in Mattermost terms
            # Mattermost will sometimes send back ephemeral messages from user [SlackBot]. Ignore these
            # These are messages like notifing that a message won't be unfurled because it's already
            # in the channel in the last hour. Helpful message for some, but not for us.
            # if ($mmMessage.subtype -eq 'bot_message') {
            #   $this.LogDebug('SubType is [bot_message]. Ignoring')
            #   continue
            # }

            # We only care about certain message types from Slack
            if ($mmMessage.event -in $this.MessageTypes) {
              $msg = [Message]::new()
              # Set the message type and optionally the subtype
              switch ($mmMessage.event) {
                  'channel_updated' {
                      $msg.Type = [MessageType]::ChannelRenamed
                  }
                  # 'member_joined_channel' {
                  #     $msg.Type = [MessageType]::Message
                  #     $msg.SubType = [MessageSubtype]::ChannelJoined
                  # }
                  # 'member_left_channel' {
                  #     $msg.Type = [MessageType]::Message
                  #     $msg.SubType = [MessageSubtype]::ChannelLeft
                  # }
                  'posted' {
                    $msg.Type = [MessageType]::Message
                  }
                  # 'pin_added' {
                  #     $msg.Type = [MessageType]::PinAdded
                  # }
                  # 'pin_removed' {
                  #     $msg.Type = [MessageType]::PinRemoved
                  # }
                  # 'presence_change' {
                  #     $msg.Type = [MessageType]::PresenceChange
                  # }
                  # 'reaction_added' {
                  #     $msg.Type = [MessageType]::ReactionAdded
                  # }
                  # 'reaction_removed' {
                  #     $msg.Type = [MessageType]::ReactionRemoved
                  # }
                  # 'star_added' {
                  #     $msg.Type = [MessageType]::StarAdded
                  # }
                  # 'star_removed' {
                  #     $msg.Type = [MessageType]::StarRemoved
                  # }
              }

              # Extract post (aka message) information
              $postData = @{}
              if (($mmMessage.data) -and ($mmMessage.data.post)) {
                $postData = $mmMessage.data.post | ConvertFrom-JSON
              }

              # TODO Don't know what the equivalent in Mattermost is
              if ($mmMessage.subtype) {
                switch ($mmMessage.subtype) {
                  'channel_join' {
                    $msg.Subtype = [MessageSubtype]::ChannelJoined
                  }
                  'channel_leave' {
                    $msg.Subtype = [MessageSubtype]::ChannelLeft
                  }
                  'channel_name' {
                    $msg.Subtype = [MessageSubtype]::ChannelRenamed
                  }
                  'channel_purpose' {
                    $msg.Subtype = [MessageSubtype]::ChannelPurposeChanged
                  }
                  'channel_topic' {
                    $msg.Subtype = [MessageSubtype]::ChannelTopicChanged
                  }
                }
              }
              $this.LogDebug("Message type is [$($msg.Type)`:$($msg.Subtype)]")

              $msg.RawMessage = $mmMessage
              $this.LogDebug('Raw message', $mmMessage)
              if ($postData.message)    { $msg.Text = $postData.message }
              if ($postData.channel_id) { $msg.To   = $postData.channel_id }
              if ($postData.user_id)    { $msg.From = $postData.user_id }

              # Resolve From name
              if ($msg.From) {
                $msg.FromName = $this.UserIdToUsername($msg.From)
              }

              # Resolve channel name
              # Skip DM channels, they won't have names
              if ($mmMessage.data -and ($mmMessage.data.channel_type -ne 'D')) {
                $msg.ToName = $this.ChannelIdToName($msg.To)
              }

              # TODO What about DMs??
              # Mark as DM
              $msg.IsDM = ($mmMessage.data -and ($mmMessage.data.channel_type -eq 'D'))

              # TODO Do I need timestamps?
              # # Get time of message
              # $unixEpoch = [datetime]'1970-01-01'
              # if ($mmMessage.ts) {
              #   $msg.Time = $unixEpoch.AddSeconds($mmMessage.ts)
              # } elseIf ($mmMessage.event_ts) {
              #   $msg.Time = $unixEpoch.AddSeconds($mmMessage.event_ts)
              # } else {
              #   $msg.Time = (Get-Date).ToUniversalTime()
              # }

              # TODO I don't think mattermost does unfurling...
              # # Sometimes the message is nested in a 'message' subproperty. This could be
              # # if the message contained a link that was unfurled.  We would receive a
              # # 'message_changed' message and need to look in the 'message' subproperty
              # # to see who the message was from.  Slack is weird
              # # https://api.slack.com/events/message/message_changed
              # if ($mmMessage.message) {
              #   if ($mmMessage.message.user) {
              #     $msg.From = $mmMessage.message.user
              #   }
              #   if ($mmMessage.message.text) {
              #     $msg.Text = $mmMessage.message.text
              #   }
              # }

              # TODO Mattermost doesn't do this.
              # # Slack displays @mentions like '@devblackops' but internally in the message
              # # it is <@U4AM3SYI8>
              # # Fix that so we actually see the @username
              # $processed = $this._ProcessMentions($msg.Text)
              # $msg.Text = $processed

              # ** Important safety tip, don't cross the streams **
              # Only return messages that didn't come from the bot
              # else we'd cause a feedback loop with the bot processing
              # it's own responses
              if (-not $this.MsgFromBot($msg.From)) {
                $messages.Add($msg) > $null
              }

              Write-host "##3"
              Write-Host ($msg | ConvertTo-JSON -Depth 10) -ForegroundColor Red

            } else {
              $this.LogDebug("Message type is [$($mmMessage.event)]. Ignoring")
            }
          }
        }
      } catch {
          Write-Error $_
      }

      return $messages
    }

    # Send a Slack ping
    [void]Ping() {
        # $msg = @{
        #     id = 1
        #     type = 'ping'
        #     time = [System.Math]::Truncate((Get-Date -Date (Get-Date) -UFormat %s))
        # }
        # $json = $msg | ConvertTo-Json
        # $bytes = ([System.Text.Encoding]::UTF8).GetBytes($json)
        # Write-Debug -Message '[SlackBackend:Ping]: One ping only Vasili'
        # $cts = New-Object System.Threading.CancellationTokenSource -ArgumentList 5000

        # $task = $this.Connection.WebSocket.SendAsync($bytes, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $cts.Token)
        # do { Start-Sleep -Milliseconds 100 }
        # until ($task.IsCompleted)
        #$result = $this.Connection.WebSocket.SendAsync($bytes, [System.Net.WebSockets.WebSocketMessageType]::Text, $true, $cts.Token).GetAwaiter().GetResult()
    }

    # Send a message back to Mattermost
    [void]SendMessage([Response]$Response) {
      $this.LogDebug("SendMessage Hit")
        # Process any custom responses
        $this.LogDebug("[$($Response.Data.Count)] custom responses")
        foreach ($customResponse in $Response.Data) {

            [string]$sendTo = $Response.To
            if ($customResponse.DM) {
                $sendTo = "@$($this.UserIdToUsername($Response.MessageFrom))"
            }

            switch -Regex ($customResponse.PSObject.TypeNames[0]) {
                '(.*?)PoshBot\.Card\.Response' {
                  $this.LogDebug('Custom response is [PoshBot.Card.Response]')

                  $text = $customResponse.Text
                  if ($customResponse.AsCode) {
                    $text = '```' + "`n" + $text + "`n" + '```'
                  }

                  if ($customResponse.Title) {
                    $text = "*$($customResponse.Title)*`n`n" + $text
                  }

                  $body = @{
                    "channel_id"= $sendTo
                    "message" = $text
                  }
                  $this.LogDebug("Sending text response back to channel [$sendTo]", $body)
                  $this.Connection.InvokeMattermostAPI('posts', 'POST', $body)

                  # TODO How do we do cards in Mattermost?

                  # $this.LogDebug('Custom response is [PoshBot.Card.Response]')
                    # $chunks = $this._ChunkString($customResponse.Text)
                    # $x = 0
                    # foreach ($chunk in $chunks) {
                    #     $attParams = @{
                    #         MarkdownFields = 'text'
                    #         Color = $customResponse.Color
                    #     }
                    #     $fbText = 'no data'
                    #     if (-not [string]::IsNullOrEmpty($chunk.Text)) {
                    #         $this.LogDebug("Response size [$($chunk.Text.Length)]")
                    #         $fbText = $chunk.Text
                    #     }
                    #     $attParams.Fallback = $fbText
                    #     if ($customResponse.Title) {

                    #         # If we chunked up the response, only display the title on the first one
                    #         if ($x -eq 0) {
                    #             $attParams.Title = $customResponse.Title
                    #         }
                    #     }
                    #     if ($customResponse.ImageUrl) {
                    #         $attParams.ImageURL = $customResponse.ImageUrl
                    #     }
                    #     if ($customResponse.ThumbnailUrl) {
                    #         $attParams.ThumbURL = $customResponse.ThumbnailUrl
                    #     }
                    #     if ($customResponse.LinkUrl) {
                    #         $attParams.TitleLink = $customResponse.LinkUrl
                    #     }
                    #     if ($customResponse.Fields) {
                    #         $arr = New-Object System.Collections.ArrayList
                    #         foreach ($key in $customResponse.Fields.Keys) {
                    #             $arr.Add(
                    #                 @{
                    #                     title = $key;
                    #                     value = $customResponse.Fields[$key];
                    #                     short = $true
                    #                 }
                    #             )
                    #         }
                    #         $attParams.Fields = $arr
                    #     }

                    #     if (-not [string]::IsNullOrEmpty($chunk)) {
                    #         $attParams.Text = '```' + $chunk + '```'
                    #     } else {
                    #         $attParams.Text = [string]::Empty
                    #     }
                    #     $att = New-SlackMessageAttachment @attParams
                    #     $msg = $att | New-SlackMessage -Channel $sendTo -AsUser
                    #     $this.LogDebug("Sending card response back to Slack channel [$sendTo]", $att)
                    #     $slackResponse = $msg | Send-SlackMessage -Token $this.Connection.Config.Credential.GetNetworkCredential().Password -Verbose:$false
                    # }
                    break
                }
                '(.*?)PoshBot\.Text\.Response' {
                    $this.LogDebug('Custom response is [PoshBot.Text.Response]')

                    $text = $customResponse.Text
                    if ($customResponse.AsCode) {
                      $text = '```' + "`n" + $text + "`n" + '```'
                    }

                    $body = @{
                      "channel_id"= $sendTo
                      "message" = $text
                    }
                    $this.LogDebug("Sending text response back to channel [$sendTo]", $body)

                    $this.Connection.InvokeMattermostAPI('posts', 'POST', $body)

                    break
                }
                # '(.*?)PoshBot\.File\.Upload' {
                #     $this.LogDebug('Custom response is [PoshBot.File.Upload]')
                #     $uploadParams = @{
                #         Token = $this.Connection.Config.Credential.GetNetworkCredential().Password
                #         Channel = $sendTo
                #         Path = $customResponse.Path
                #     }
                #     if ((Test-Path $uploadParams.Path -ErrorAction SilentlyContinue)) {
                #         if (-not [string]::IsNullOrEmpty($customResponse.Title)) {
                #             $uploadParams.Title = $customResponse.Title
                #         } else {
                #             $uploadParams.Title = Split-Path -Path $customResponse.Path -Leaf
                #         }
                #         $this.LogDebug("Title is $($uploadParams.Title)")

                #         $this.LogDebug("Uploading [$($customResponse.Path)] to Slack channel [$sendTo]")
                #         Send-SlackFile @uploadParams -Verbose:$false
                #         if (-not $customResponse.KeepFile) {
                #             Remove-Item -LiteralPath $customResponse.Path -Force
                #         }
                #     } else {
                #         # Mark command as failed since we could't find the file to upload
                #         $this.RemoveReaction($Response.OriginalMessage, [ReactionType]::Success)
                #         $this.AddReaction($Response.OriginalMessage, [ReactionType]::Failure)
                #         $att = New-SlackMessageAttachment -Color '#FF0000' -Title 'Rut row' -Text "File [$($uploadParams.Path)] not found" -Fallback 'Rut row'
                #         $msg = $att | New-SlackMessage -Channel $sendTo -AsUser
                #         $this.LogDebug("Sending card response back to Slack channel [$sendTo]", $att)
                #         $null = $msg | Send-SlackMessage -Token $this.Connection.Config.Credential.GetNetworkCredential().Password -Verbose:$false
                #     }
                #     break
                # }
            }
        }

        # if ($Response.Text.Count -gt 0) {
        #     foreach ($t in $Response.Text) {
        #         $this.LogDebug("Sending response back to Slack channel [$($Response.To)]", $t)
        #         $slackResponse = Send-SlackMessage -Token $this.Connection.Config.Credential.GetNetworkCredential().Password -Channel $Response.To -Text $t -Verbose:$false -AsUser
        #     }
        # }
    }

    # Add a reaction to an existing chat message
    [void]AddReaction([Message]$Message, [ReactionType]$Type, [string]$Reaction) {
      if ($Type -eq [ReactionType]::Custom) {
        $emoji = $Reaction
      } else {
        $emoji = $this._ResolveEmoji($Type)
      }

      $postData = ($Message.RawMessage.data.post | ConvertFrom-Json)

      $body = @{
        "user_id"    = $this.GetBotIdentity()
        "post_id"    = $postData.id
        "emoji_name" = $emoji
        "create_at"  = 0
      }

      $this.LogDebug("Adding reaction [$emoji] to message Id [$($postData.id)]")
      $this.Connection.InvokeMattermostAPI('reactions', 'POST', $body) | Out-Null
    }

    # Remove a reaction from an existing chat message
    [void]RemoveReaction([Message]$Message, [ReactionType]$Type, [string]$Reaction) {
      if ($Type -eq [ReactionType]::Custom) {
        $emoji = $Reaction
      } else {
        $emoji = $this._ResolveEmoji($Type)
      }

      $postData = ($Message.RawMessage.data.post | ConvertFrom-Json)

      $this.LogDebug("Removing reaction [$emoji] from message Id [$($postData.id)]")
      $this.Connection.InvokeMattermostAPI("users/$($this.GetBotIdentity())/posts/$($postData.id)/reactions/$($emoji)", 'DELETE', @{}) | Out-Null
    }

    # # Resolve a channel name to an Id
    # [string]ResolveChannelId([string]$ChannelName) {
    #     if ($ChannelName -match '^#') {
    #         $ChannelName = $ChannelName.TrimStart('#')
    #     }
    #     $channelId = ($this.Connection.LoginData.channels | Where-Object name -eq $ChannelName).id
    #     if (-not $ChannelId) {
    #         $channelId = ($this.Connection.LoginData.channels | Where-Object id -eq $ChannelName).id
    #     }
    #     $this.LogDebug("Resolved channel [$ChannelName] to [$channelId]")
    #     return $channelId
    # }

    # Populate the list of users the Mattermost team
    [void]LoadUsers() {
      $this.LogDebug('Getting Mattermost users')
      $allUsers = $this.Connection.InvokeMattermostAPI('users', 'GET', @{})
      $this.LogDebug("[$($allUsers.Count)] users returned")
      $allUsers | ForEach-Object {
        $user = [MattermostPerson]::new()
        # TODO Not sure these Slack properties match Mattermost
        $user.Id = $_.ID
        $user.Nickname = $_.nickname
        $user.FullName = $_.RealName
        $user.FirstName = $_.FirstName
        $user.LastName = $_.LastName
        $user.Email = $_.Email
        $user.Phone = $_.Phone
        $user.Skype = $_.Skype
        $user.IsBot = $_.IsBot
        $user.IsAdmin = $_.IsAdmin
        $user.IsOwner = $_.IsOwner
        $user.IsPrimaryOwner = $_.IsPrimaryOwner
        $user.IsUltraRestricted = $_.IsUltraRestricted
        $user.Status = $_.Status
        $user.TimeZoneLabel = $_.TimeZoneLabel
        $user.TimeZone = $_.TimeZone
        $user.Presence = $_.Presence
        $user.Deleted = $_.Deleted
        if ($user.Nickname -eq '') { $user.Nickname = $_.username }

        if (-not $this.Users.ContainsKey($_.ID)) {
          $this.LogDebug("Adding user [$($_.ID):$($_.Name)]")
          $this.Users[$_.ID] =  $user
        }
      }

      foreach ($key in $this.Users.Keys) {
        if ($key -notin $allUsers.ID) {
          $this.LogDebug("Removing outdated user [$key]")
          $this.Users.Remove($key)
        }
      }
    }

    # Populate the list of channels in the Mattermost team
    [void]LoadRooms() {
      $this.LogDebug('Getting Mattermost channels')
      $allChannels = $this.Connection.InvokeMattermostAPI('teams/' + $this.Connection.BotTeamID + '/channels', 'GET', @{})
      $this.LogDebug("[$($allChannels.Count)] channels returned")

      $allChannels | ForEach-Object {
        $channel = [MattermostChannel]::new()
        $channel.Id = $_.ID
        $channel.Name = $_.Name
        $channel.Topic = $_.Topic
        $channel.Purpose = $_.Purpose
        #$channel.Created = $_.Created
        $channel.Creator = $_.Creator
        $channel.IsArchived = $_.IsArchived
        $channel.IsGeneral = $_.IsGeneral
        $channel.MemberCount = $_.MemberCount
        foreach ($member in $_.Members) {
          $channel.Members.Add($member, $null)
        }
        $this.LogDebug("Adding channel: $($_.ID):$($_.Name)")
        $this.Rooms[$_.ID] = $channel
      }

      foreach ($key in $this.Rooms.Keys) {
        if ($key -notin $allChannels.ID) {
          $this.LogDebug("Removing outdated channel [$key]")
          $this.Rooms.Remove($key)
        }
      }
    }

    # Get the bot identity Id
    [string]GetBotIdentity() {
      $id = $this.Connection.LoginData.id
      $this.LogVerbose("Bot identity is [$id]")
      return $id
    }

    # Determine if incoming message was from the bot
    [bool]MsgFromBot([string]$From) {
      $frombot = ($this.BotId -eq $From)
      if ($fromBot) {
        $this.LogDebug("Message is from bot [From: $From == Bot: $($this.BotId)]. Ignoring")
      } else {
        $this.LogDebug("Message is not from bot [From: $From <> Bot: $($this.BotId)]")
      }
      return $fromBot
    }

    # Get a user by their Id
    [MattermostPerson]GetUser([string]$UserId) {
      $user = $this.Users[$UserId]
      if (-not $user) {
        $this.LogDebug([LogSeverity]::Warning, "User [$UserId] not found. Refreshing users")
        $this.LoadUsers()
        $user = $this.Users[$UserId]
      }

      if ($user) {
        $this.LogDebug("Resolved user [$UserId]", $user)
      } else {
        $this.LogDebug([LogSeverity]::Warning, "Could not resolve user [$UserId]")
      }
      return $user
    }

    # Get a user Id by their name
    [string]UsernameToUserId([string]$Username) {
      $Username = $Username.TrimStart('@')
      $user = $this.Users.Values | Where-Object {$_.Nickname -eq $Username}
      $id = $null
      if ($user) {
        $id = $user.Id
      } else {
        # User each doesn't exist or is not in the local cache
        # Refresh it and try again
        $this.LogDebug([LogSeverity]::Warning, "User [$Username] not found. Refreshing users")
        $this.LoadUsers()
        $user = $this.Users.Values | Where-Object {$_.Nickname -eq $Username}
        if (-not $user) {
          $id = $null
        } else {
          $id = $user.Id
        }
      }
      if ($id) {
        $this.LogDebug("Resolved [$Username] to [$id]")
      } else {
        $this.LogDebug([LogSeverity]::Warning, "Could not resolve user [$Username]")
      }
      return $id
    }

    # Get a user name by their Id
    [string]UserIdToUsername([string]$UserId) {
      $name = $null
      if ($this.Users.ContainsKey($UserId)) {
        $name = $this.Users[$UserId].Nickname
      } else {
        $this.LogDebug([LogSeverity]::Warning, "User [$UserId] not found. Refreshing users")
        $this.LoadUsers()
        $name = $this.Users[$UserId].Nickname
      }
      if ($name) {
        $this.LogDebug("Resolved [$UserId] to [$name]")
      } else {
        $this.LogDebug([LogSeverity]::Warning, "Could not resolve user [$UserId]")
      }
      return $name
    }

    # Get the channel name by Id
    [string]ChannelIdToName([string]$ChannelId) {
      $name = $null
      if ($this.Rooms.ContainsKey($ChannelId)) {
        $name = $this.Rooms[$ChannelId].Name
      } else {
        $this.LogDebug([LogSeverity]::Warning, "Channel [$ChannelId] not found. Refreshing channels")
        $this.LoadRooms()
        $name = $this.Rooms[$ChannelId].Name
      }
      if ($name) {
        $this.LogDebug("Resolved [$ChannelId] to [$name]")
      } else {
        $this.LogDebug([LogSeverity]::Warning, "Could not resolve channel [$ChannelId]")
      }
      return $name
    }

    # Get all user info by their ID
    [hashtable]GetUserInfo([string]$UserId) {
      $user = $null
      if ($this.Users.ContainsKey($UserId)) {
        $user = $this.Users[$UserId]
      } else {
        $this.LogDebug([LogSeverity]::Warning, "User [$UserId] not found. Refreshing users")
        $this.LoadUsers()
        $user = $this.Users[$UserId]
      }

      if ($user) {
        $this.LogDebug("Resolved [$UserId] to [$($user.Nickname)]")
        return $user.ToHash()
      } else {
        $this.LogDebug([LogSeverity]::Warning, "Could not resolve channel [$UserId]")
        return $null
      }
    }

    # Remove extra characters that Slack decorates urls with
    hidden [string] _SanitizeURIs([string]$Text) {
      return $Text  # Do we need this method still?
      # $sanitizedText = $Text -replace '<([^\|>]+)\|([^\|>]+)>', '$2'
      # $sanitizedText = $sanitizedText -replace '<(http([^>]+))>', '$1'
      # return $sanitizedText
    }

    # # Break apart a string by number of characters
    # hidden [System.Collections.ArrayList] _ChunkString([string]$Text) {
    #     $chunks = [regex]::Split($Text, "(?<=\G.{$($this.MaxMessageLength)})", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    #     $this.LogDebug("Split response into [$($chunks.Count)] chunks")
    #     return $chunks
    # }

    # Resolve a reaction type to an emoji
    hidden [string]_ResolveEmoji([ReactionType]$Type) {
      $emoji = [string]::Empty
      Switch ($Type) {
        'Success'        { return 'white_check_mark' }
        'Failure'        { return 'exclamation' }
        'Processing'     { return 'gear' }
        'Warning'        { return 'warning' }
        'ApprovalNeeded' { return 'closed_lock_with_key'}
        'Cancelled'      { return 'no_entry_sign'}
        'Denied'         { return 'x'}
      }
      return $emoji
    }

    # # Translate formatted @mentions like <@U4AM3SYI8> into @devblackops
    # hidden [string]_ProcessMentions([string]$Text) {
    #     $processed = $Text

    #     $mentions = $processed | Select-String -Pattern '(?<name><@[^>]*>*)' -AllMatches | ForEach-Object {
    #         $_.Matches | ForEach-Object {
    #             [pscustomobject]@{
    #                 FormattedId = $_.Value
    #                 UnformattedId = $_.Value.TrimStart('<@').TrimEnd('>')
    #             }
    #         }
    #     }
    #     $mentions | ForEach-Object {
    #         if ($name = $this.UserIdToUsername($_.UnformattedId)) {
    #             $processed = $processed -replace $_.FormattedId, "@$name"
    #             $this.LogDebug($processed)
    #         } else {
    #             $this.LogDebug([LogSeverity]::Warning, "Unable to translate @mention [$($_.FormattedId)] into a username")
    #         }
    #     }

    #     return $processed
    # }
}
