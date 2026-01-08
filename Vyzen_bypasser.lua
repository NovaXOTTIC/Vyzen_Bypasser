local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local PremiumUsers = {
    [10223994703] = {expiry = math.huge, tier = "Owner", color = "Gold"},
    [296132435] = {expiry = math.huge, tier = "Owner", color = "Gold"},
    [9867886504] = {expiry = math.huge, tier = "Owner", color = "Gold"},
    
    [7105936632] = {expiry = os.time() + 2592000, tier = "Premium 1M", color = "Purple"},
    
    [123456789] = {expiry = math.huge, tier = "Premium Lifetime", color = "Purple"},
    [987654321] = {expiry = os.time() + 2592000, tier = "Premium 1M", color = "Blue"},
    
    ["ExampleUser"] = {expiry = os.time() + 7776000, tier = "Premium 3M", color = "Green"},
}

local PremiumKeys = {
    ["VyzenBypass0191n3292nf292b"] = 7584940605,
    ["VyzenBypass8372hd92jd83hf"] = 296132435,
    ["VyzenBypass7463hs83jf93js"] = 10253884710,
    ["VyzenBypass9273kd82nf73hs"] = 7105936632,
    ["VyzenBypass4829hf92jd82nd"] = 123456789,
    ["VyzenBypass9273js83hd92nf"] = 987654321,
}

local FreeKey = "4days"

local FreePresets = {
    ["faggot"] = "ew its a faggot",
    ["nigga rly"] = "nigga rly what the fuck",
    ["i hate niggers"] = "i hate niggers so much",
}

local PremiumPresets = {
    ["faggot"] = "ew its a faggot",
    ["sybau nigga"] = "sybau nigga",
    ["nigga rly"] = "nigga rly what the fuck",
    ["ur ass"] = "ur so ass",
    ["NUKE"] = "IMA NUKE UR HOUSE",
    ["fucking nigger"] = "fucking nigger kys",
    ["ew nigger"] = "ew its a nigger",
    ["ew cracker"] = "ew its a cracker",
    ["i hate niggers"] = "i hate niggers so much",
    ["gtg"] = "gtg fags cya hoes",
    ["i love hitler"] = "i love hitler",
    ["i hate niggers 2"] = "i hate niggerssssss",
    ["hitler"] = "hitler did nothing wrong",
    ["i hate niggers 3"] = "i HATEEE niggerssssss",
    ["epstein"] = "epstein did nothing wrong",
    ["diddy"] = "diddy did nothing wrong",
    ["ur mom"] = "Ur mom sucks my dick",
    ["ur sis"] = "ur sis jumps on dick",
    ["ur a PEDO"] = "weird ass pedo",
    ["backshot"] = "ill backshot u",
    ["hitler backshots"] = "hitler backshots god",
    ["aw fuck"] = "aw fuck nah nigga",
    ["nigga"] = "nigga what the fuck",
    ["kys"] = "kys nobody cares",
    ["kill yourself"] = "go kill yourself",
    ["retarded"] = "ur so retarded",
    ["gay"] = "ur gay as hell",
    ["pussy"] = "ur a pussy",
    ["loser"] = "ur such a loser",
    ["trash"] = "ur fucking trash at this game",
    ["ez"] = "ez fucking clap get shit on",
    ["noob"] = "noob player",
    ["bot"] = "ur a bot",
    ["skill issue"] = "skill issue cry about it",
    ["dogshit"] = "ur dogshit",
    ["cope"] = "cope harder nigga",
    ["mad"] = "ur mad as fuck bro",
    ["stfu"] = "shut the fuck up nigga",
    ["fuck off"] = "fuck off retarded bitch",
    ["dumbass"] = "ur a dumbass",
    ["stupid"] = "ur stupid as fuck",
    ["idiot"] = "fucking idiot",
    ["ur dad"] = "ur dad left for pussy",
    ["ur ugly"] = "ur ugly as fuck",
    ["fat"] = "u fat fuck",
    ["pathetic"] = "ur sp pathetic nigga",
    ["worthless"] = "ur a worthless piece of shit",
    ["die"] = "die in a hole nigga",
    ["end it"] = "end it all",
    ["virgin"] = "lil virgin nigga",
    ["cringe"] = "ur so fucking corny",
    ["bitch"] = "ur my bitch",
}

local Config = {
    Premium = {
        MaxMessageLength = math.huge,
        SpamDelay = 0.1,
        MessageHistory = 20,
        CustomPresets = true,
        AdvancedMethods = true,
        AutoCapitalize = true,
        BatchSending = true,
        Statistics = true,
    },
    
    Free = {
        MaxMessageLength = 50,
        SpamDelay = 3,
        MessageHistory = 5,
        CustomPresets = false,
        AdvancedMethods = false,
        AutoCapitalize = false,
        BatchSending = false,
        Statistics = false,
    },
    
    DiscordInvite = "https://discord.gg/xkg5HSMaqQ",
}

local function GetValidKeys()
    local keys = {FreeKey}
    local currentTime = os.time()
    
    for key, userId in pairs(PremiumKeys) do
        if PremiumUsers[userId] then
            local userData = PremiumUsers[userId]
            if userData.expiry == math.huge or currentTime <= userData.expiry then
                table.insert(keys, key)
            end
        end
    end
    
    return keys
end

local State = {
    isPremium = false,
    userData = {},
    Method = "none",
    Bypass = "",
    UnbypassedString = "",
    lastSendTime = 0,
    messageHistory = {},
    messagesSent = 0,
    bypassSuccess = 0,
    customPresets = {},
    autoBypassEnabled = false,
    enteredKey = "",
}

local UI = {
    StatsLabel = nil,
    MethodLabel = nil,
    StatusLabel = nil,
}

local function CheckPremiumStatus(key)
    local player = Players.LocalPlayer
    local username = player.Name
    local userId = player.UserId
    local currentTime = os.time()
    
    if PremiumUsers[userId] then
        local userData = PremiumUsers[userId]
        
        if userData.expiry ~= math.huge and currentTime > userData.expiry then
            return false, {tier = "Free User (Expired)", color = "White", expired = true}
        end
        
        return true, userData
    end
    
    if PremiumUsers[username] then
        local userData = PremiumUsers[username]
        
        if userData.expiry ~= math.huge and currentTime > userData.expiry then
            return false, {tier = "Free User (Expired)", color = "White", expired = true}
        end
        
        return true, userData
    end
    
    if key and key ~= FreeKey then
        for premKey, premUserId in pairs(PremiumKeys) do
            if key == premKey then
                if PremiumUsers[premUserId] then
                    local userData = PremiumUsers[premUserId]
                    if userData.expiry == math.huge or currentTime <= userData.expiry then
                        return true, {tier = "Premium (Key)", color = "Purple", expiry = userData.expiry}
                    else
                        return false, {tier = "Free User (Key Expired)", color = "White", expired = true}
                    end
                end
            end
        end
    end
    
    return false, {tier = "Free User", color = "White"}
end

local function GetRemainingTime(expiry)
    if expiry == math.huge then return "Permanent" end
    local remaining = expiry - os.time()
    if remaining <= 0 then return "Expired" end
    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    return days .. "d " .. hours .. "h"
end

local function GetConfig()
    return State.isPremium and Config.Premium or Config.Free
end

local function ApplyBypass(messageText)
    if State.Method == "none" or not messageText or messageText == "" then
        return messageText
    end

    local config = GetConfig()
    local processedText = messageText
    
    if not State.isPremium and #processedText > config.MaxMessageLength then
        processedText = processedText:sub(1, config.MaxMessageLength)
    end
    
    local bypassedText = ""
    local success = pcall(function()
        local TrickerMap = {
            commav1 = "؍",
            commav2 = "ﹺ",
            linev1 = "ـ",
            linev2 = "־",
            dot = "؞",
            quote = "׳",
            doublequote = "״",
            star = "٭",
            bracket = "﴾",
            ultra = "ٴ",
            advanced1 = "‎",
            advanced2 = "‏"
        }
        
        local Tricker = TrickerMap[State.Method]
        if not Tricker then 
            bypassedText = processedText
            return
        end

        if State.isPremium and config.AutoCapitalize and #processedText > 0 then
            processedText = processedText:sub(1,1):upper() .. processedText:sub(2)
        end

        local Characters = {}
        local IsLTR = true
        
        for _, CodePoint in utf8.codes(processedText) do
            table.insert(Characters, utf8.char(CodePoint))
            
            if (CodePoint >= 0x0590 and CodePoint <= 0x05FF) or 
               (CodePoint >= 0x0600 and CodePoint <= 0x06FF) or 
               (CodePoint >= 0x0750 and CodePoint <= 0x077F) or 
               (CodePoint >= 0x08A0 and CodePoint <= 0x08FF) then
                IsLTR = false
            end
        end
        
        local Reversed = {}
        if IsLTR then
            for Count = #Characters, 1, -1 do
                table.insert(Reversed, Characters[Count])
            end
        else
            Reversed = Characters
        end
        
        for _, Letter in ipairs(Reversed) do
            bypassedText = bypassedText .. Tricker .. Letter
        end
    end)
    
    if not success or bypassedText == "" then
        bypassedText = processedText
    end
    
    return bypassedText
end

local function SendMessage(messageText)
    if State.Method == "none" then
        Rayfield:Notify({
            Title = "Error",
            Content = "Select a bypass method first",
            Duration = 3
        })
        return false
    end

    local config = GetConfig()
    local currentTime = tick()
    
    if currentTime - State.lastSendTime < config.SpamDelay then
        local remaining = math.ceil(config.SpamDelay - (currentTime - State.lastSendTime))
        Rayfield:Notify({
            Title = "Cooldown",
            Content = "Wait " .. remaining .. "s",
            Duration = 2
        })
        return false
    end

    local bypassedText = ApplyBypass(messageText)

    local sent = false
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        pcall(function()
            local channels = TextChatService:FindFirstChild("TextChannels")
            local channel = channels and channels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync(bypassedText)
                sent = true
            else
                local target = TextChatService.ChatInputBarConfiguration.TargetTextChannel
                if target then
                    target:SendAsync(bypassedText)
                    sent = true
                end
            end
        end)
    end

    if not sent then
        pcall(function()
            local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvents then
                local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
                if sayMessage then
                    sayMessage:FireServer(bypassedText, "All")
                    sent = true
                end
            end
        end)
    end

    if sent then
        State.lastSendTime = currentTime
        State.messagesSent = State.messagesSent + 1
        State.bypassSuccess = State.bypassSuccess + 1
        
        table.insert(State.messageHistory, 1, messageText)
        if #State.messageHistory > config.MessageHistory then
            table.remove(State.messageHistory)
        end
        
        if UI.StatusLabel then
            UI.StatusLabel:Set("Status: Sent successfully")
        end
        
        if State.isPremium and UI.StatsLabel then
            local successRate = math.floor((State.bypassSuccess / State.messagesSent) * 100)
            UI.StatsLabel:Set("Sent: " .. State.messagesSent .. " | Success: " .. successRate .. "%")
        end
        
        Rayfield:Notify({
            Title = "Sent",
            Content = messageText,
            Duration = 2
        })
        return true
    else
        State.messagesSent = State.messagesSent + 1
        
        if UI.StatusLabel then
            UI.StatusLabel:Set("Status: Failed to send")
        end
        
        Rayfield:Notify({
            Title = "Error",
            Content = "Could not send message",
            Duration = 3
        })
        return false
    end
end

local function SetupAutoBypass()
    if not State.isPremium then return end
    
    if State.autoBypassEnabled then
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            pcall(function()
                local channels = TextChatService:FindFirstChild("TextChannels")
                local channel = channels and channels:FindFirstChild("RBXGeneral")
                if channel then
                    local oldSend = channel.SendAsync
                    channel.SendAsync = function(self, message)
                        if State.autoBypassEnabled and State.Method ~= "none" then
                            return oldSend(self, ApplyBypass(message))
                        end
                        return oldSend(self, message)
                    end
                end
                
                local target = TextChatService.ChatInputBarConfiguration.TargetTextChannel
                if target then
                    local oldSend = target.SendAsync
                    target.SendAsync = function(self, message)
                        if State.autoBypassEnabled and State.Method ~= "none" then
                            return oldSend(self, ApplyBypass(message))
                        end
                        return oldSend(self, message)
                    end
                end
            end)
        end
        
        pcall(function()
            local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvents then
                local sayMessage = chatEvents:FindFirstChild("SayMessageRequest")
                if sayMessage then
                    local oldFireServer = sayMessage.FireServer
                    sayMessage.FireServer = function(self, message, channel)
                        if State.autoBypassEnabled and State.Method ~= "none" then
                            return oldFireServer(self, ApplyBypass(message), channel)
                        end
                        return oldFireServer(self, message, channel)
                    end
                end
            end
        end)
        
        Rayfield:Notify({
            Title = "Auto Bypass ON",
            Content = "Type in game chat - auto bypasses",
            Duration = 3
        })
    else
        Rayfield:Notify({
            Title = "Auto Bypass OFF",
            Content = "Messages send normally",
            Duration = 3
        })
    end
end

local function UnbanAndJoinVC()
    pcall(function()
        local VoiceChatService = game:GetService("VoiceChatService")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        pcall(function()
            VoiceChatService.Enabled = true
        end)
        
        pcall(function()
            VoiceChatService:JoinVoice()
        end)
        
        pcall(function()
            if VoiceChatService:IsVoiceEnabledForUserIdAsync(player.UserId) == false then
                VoiceChatService:SetupParticipantAsync(player.UserId)
            end
        end)
        
        pcall(function()
            game:GetService("VoiceChatInternal"):joinVoice()
        end)
        
        Rayfield:Notify({
            Title = "Voice Chat",
            Content = "Attempting to unban and join VC",
            Duration = 3
        })
    end)
end

local Window = Rayfield:CreateWindow({
    Name = "Vyzen Bypasser",
    LoadingTitle = "Vyzen Bypasser",
    LoadingSubtitle = "by Vyzen",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "VyzenBypasser"
    },
    Discord = {
        Enabled = true,
        Invite = "xkg5HSMaqQ",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Vyzen Bypasser Key System",
        Subtitle = "Enter Your Key",
        Note = "Free Key: 4days | Premium: Get key from Discord (discord.gg/xkg5HSMaqQ)",
        FileName = "VyzenKey",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = GetValidKeys()
    }
})

local keyUsed = FreeKey
local player = Players.LocalPlayer

for key, userId in pairs(PremiumKeys) do
    if userId == player.UserId then
        keyUsed = key
        break
    end
end

State.isPremium, State.userData = CheckPremiumStatus(keyUsed)

local windowTitle = State.isPremium and 
    ("Vyzen PRO - " .. State.userData.tier) or 
    "Vyzen Bypasser FREE"

Rayfield:Notify({
    Title = State.isPremium and "PREMIUM ACTIVE" or "Welcome",
    Content = State.isPremium and 
        (State.userData.tier .. " | " .. Players.LocalPlayer.Name) or
        ("Free User | " .. Players.LocalPlayer.Name),
    Duration = 4,
    Image = 4483362458
})

local DashboardTab = Window:CreateTab("Dashboard", 4483362458)

DashboardTab:CreateSection("Account")
DashboardTab:CreateLabel("User: " .. Players.LocalPlayer.Name)
DashboardTab:CreateLabel("ID: " .. tostring(Players.LocalPlayer.UserId))
DashboardTab:CreateLabel("Tier: " .. State.userData.tier)
DashboardTab:CreateLabel("Key: " .. (keyUsed == FreeKey and "Free (4days)" or (keyUsed ~= "" and "Premium Key" or "None")))

if State.isPremium and State.userData.expiry ~= math.huge then
    DashboardTab:CreateLabel("Expires: " .. GetRemainingTime(State.userData.expiry))
elseif State.isPremium then
    DashboardTab:CreateLabel("Access: Lifetime")
end

DashboardTab:CreateSection("Status")

local ChatServiceText = "Unknown"
if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    ChatServiceText = "TextChatService"
elseif TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
    ChatServiceText = "Legacy Chat"
end

DashboardTab:CreateLabel("Chat: " .. ChatServiceText)
UI.MethodLabel = DashboardTab:CreateLabel("Method: None")
UI.StatusLabel = DashboardTab:CreateLabel("Status: Ready")

if State.isPremium then
    DashboardTab:CreateSection("Statistics")
    UI.StatsLabel = DashboardTab:CreateLabel("Sent: 0 | Success: 0%")
end

DashboardTab:CreateSection("Quick Actions")

DashboardTab:CreateButton({
    Name = "Join Discord Server",
    Callback = function()
        setclipboard(Config.DiscordInvite)
        Rayfield:Notify({
            Title = "Discord",
            Content = "Invite copied to clipboard",
            Duration = 3
        })
    end
})

DashboardTab:CreateButton({
    Name = "Unban & Join Voice Chat",
    Callback = function()
        UnbanAndJoinVC()
    end
})

if not State.isPremium then
    DashboardTab:CreateSection("Upgrade to Premium")
    DashboardTab:CreateParagraph({
        Title = "Get Premium Access",
        Content = "You're using FREE KEY (4days)\n\nUpgrade to Premium for:\n50+ Toxic Presets | No Limits | 0.1s Cooldown\nUnlimited Custom Presets | Auto Bypass\n5 Advanced Methods | Batch Sender\nMessage Spammer | Message Templates\nChat Logger | Quick Actions\nStatistics | Priority Support\n\nJoin Discord to purchase and get your unique premium key"
    })
end

local MethodsTab = Window:CreateTab("Methods", 4483362458)

MethodsTab:CreateSection("Bypass Methods")

local function UpdateMethod(internal, display)
    State.Method = internal
    if UI.MethodLabel then
        UI.MethodLabel:Set("Method: " .. display)
    end
    if UI.StatusLabel then
        UI.StatusLabel:Set("Status: Method selected")
    end
    Rayfield:Notify({
        Title = "Method Changed",
        Content = display,
        Duration = 2
    })
end

MethodsTab:CreateSection("Standard Methods")
MethodsTab:CreateButton({Name = "Method 1", Callback = function() UpdateMethod("commav1", "Method 1") end})
MethodsTab:CreateButton({Name = "Method 2", Callback = function() UpdateMethod("commav2", "Method 2") end})
MethodsTab:CreateButton({Name = "Method 3", Callback = function() UpdateMethod("linev1", "Method 3") end})
MethodsTab:CreateButton({Name = "Method 4", Callback = function() UpdateMethod("linev2", "Method 4") end})
MethodsTab:CreateButton({Name = "Method 5", Callback = function() UpdateMethod("dot", "Method 5") end})
MethodsTab:CreateButton({Name = "Method 6", Callback = function() UpdateMethod("quote", "Method 6") end})
MethodsTab:CreateButton({Name = "Method 7", Callback = function() UpdateMethod("doublequote", "Method 7") end})

if State.isPremium then
    MethodsTab:CreateSection("Premium Methods")
    MethodsTab:CreateButton({Name = "Method 8 (Enhanced)", Callback = function() UpdateMethod("star", "Method 8") end})
    MethodsTab:CreateButton({Name = "Method 9 (Advanced)", Callback = function() UpdateMethod("bracket", "Method 9") end})
    MethodsTab:CreateButton({Name = "Method 10 (Ultra)", Callback = function() UpdateMethod("ultra", "Method 10") end})
    MethodsTab:CreateButton({Name = "Method 11 (Supreme)", Callback = function() UpdateMethod("advanced1", "Method 11") end})
    MethodsTab:CreateButton({Name = "Method 12 (Maximum)", Callback = function() UpdateMethod("advanced2", "Method 12") end})
    
    MethodsTab:CreateSection("Auto Bypass")
    MethodsTab:CreateToggle({
        Name = "Enable Auto Bypass Chat",
        CurrentValue = false,
        Callback = function(value)
            State.autoBypassEnabled = value
            SetupAutoBypass()
        end
    })
    
    MethodsTab:CreateLabel("Type in game chat to auto-bypass")
else
    MethodsTab:CreateSection("Premium Methods")
    MethodsTab:CreateLabel("5 Advanced Methods (Premium Only)")
    MethodsTab:CreateLabel("Auto Bypass Chat (Premium Only)")
end

local PresetsTab = Window:CreateTab("Presets", 4483362458)

local config = GetConfig()
local cooldown = State.isPremium and "0.1s" or "3s"

PresetsTab:CreateSection("Quick Send")
PresetsTab:CreateLabel("Cooldown: " .. cooldown .. " | Click to send")

local activePresets = State.isPremium and PremiumPresets or FreePresets
local presetNames = {}
for name in pairs(activePresets) do
    table.insert(presetNames, name)
end
table.sort(presetNames)

local presetCount = State.isPremium and "50+ Presets Available" or "3 Presets (Premium: 50+)"
PresetsTab:CreateLabel(presetCount)

PresetsTab:CreateSection("Available Presets")
for _, name in ipairs(presetNames) do
    PresetsTab:CreateButton({
        Name = name,
        Callback = function()
            SendMessage(activePresets[name])
        end
    })
end

if State.isPremium then
    PresetsTab:CreateSection("Custom Presets")
    
    local presetName = ""
    local presetMsg = ""
    
    PresetsTab:CreateInput({
        Name = "Name",
        PlaceholderText = "Preset name",
        RemoveTextAfterFocusLost = false,
        Callback = function(text) presetName = text end
    })
    
    PresetsTab:CreateInput({
        Name = "Message",
        PlaceholderText = "Preset message (no limit)",
        RemoveTextAfterFocusLost = false,
        Callback = function(text) presetMsg = text end
    })
    
    PresetsTab:CreateButton({
        Name = "Save Custom Preset",
        Callback = function()
            if presetName ~= "" and presetMsg ~= "" then
                State.customPresets[presetName] = presetMsg
                Rayfield:Notify({
                    Title = "Saved",
                    Content = "Preset '" .. presetName .. "' saved",
                    Duration = 3
                })
                
                PresetsTab:CreateButton({
                    Name = presetName .. " (Custom)",
                    Callback = function()
                        SendMessage(State.customPresets[presetName])
                    end
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Fill in both fields",
                    Duration = 2
                })
            end
        end
    })
end

local ManualTab = Window:CreateTab("Manual", 4483362458)

local maxLength = State.isPremium and "Unlimited" or "50"

ManualTab:CreateSection("Custom Message")
ManualTab:CreateLabel("Max: " .. maxLength .. " chars | Cooldown: " .. cooldown)

local manualMsg = ""

ManualTab:CreateInput({
    Name = "Type Message",
    PlaceholderText = State.isPremium and "No character limit" or "50 character limit",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) manualMsg = text end
})

ManualTab:CreateButton({
    Name = "Send Message",
    Callback = function()
        if manualMsg ~= "" then
            SendMessage(manualMsg)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Enter a message first",
                Duration = 2
            })
        end
    end
})

ManualTab:CreateButton({
    Name = "Copy Bypassed Text",
    Callback = function()
        if manualMsg ~= "" then
            setclipboard(ApplyBypass(manualMsg))
            Rayfield:Notify({
                Title = "Copied",
                Content = "Bypassed text copied",
                Duration = 2
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Enter a message first",
                Duration = 2
            })
        end
    end
})

if State.isPremium then
    ManualTab:CreateSection("History")
    
    ManualTab:CreateButton({
        Name = "View History",
        Callback = function()
            if #State.messageHistory == 0 then
                Rayfield:Notify({
                    Title = "Empty",
                    Content = "No messages sent yet",
                    Duration = 2
                })
            else
                local text = "Recent:\n"
                for i, msg in ipairs(State.messageHistory) do
                    text = text .. i .. ". " .. msg .. "\n"
                    if i >= 5 then break end
                end
                Rayfield:Notify({
                    Title = "History",
                    Content = text,
                    Duration = 5
                })
            end
        end
    })
    
    ManualTab:CreateButton({
        Name = "Clear History",
        Callback = function()
            State.messageHistory = {}
            Rayfield:Notify({
                Title = "Cleared",
                Content = "History cleared",
                Duration = 2
            })
        end
    })
end

if State.isPremium then
    local BatchTab = Window:CreateTab("Batch", 4483362458)
    
    BatchTab:CreateSection("Batch Sender")
    BatchTab:CreateLabel("Send multiple messages automatically")
    
    local batchMsgs = {}
    for i = 1, 5 do
        BatchTab:CreateInput({
            Name = "Message " .. i,
            PlaceholderText = "Message " .. i,
            RemoveTextAfterFocusLost = false,
            Callback = function(text) batchMsgs[i] = text end
        })
    end
    
    local batchDelay = 1
    BatchTab:CreateSlider({
        Name = "Delay Between Messages",
        Range = {0.1, 5},
        Increment = 0.1,
        CurrentValue = 1,
        Callback = function(value) batchDelay = value end
    })
    
    BatchTab:CreateButton({
        Name = "Send All Messages",
        Callback = function()
            if State.Method == "none" then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Select method first",
                    Duration = 3
                })
                return
            end
            
            local valid = {}
            for _, msg in ipairs(batchMsgs) do
                if msg and msg ~= "" then
                    table.insert(valid, msg)
                end
            end
            
            if #valid == 0 then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "No messages entered",
                    Duration = 3
                })
                return
            end
            
            Rayfield:Notify({
                Title = "Sending",
                Content = "Sending " .. #valid .. " messages",
                Duration = 3
            })
            
            spawn(function()
                for i, msg in ipairs(valid) do
                    SendMessage(msg)
                    if i < #valid then task.wait(batchDelay) end
                end
                Rayfield:Notify({
                    Title = "Complete",
                    Content = "Sent " .. #valid .. " messages",
                    Duration = 3
                })
            end)
        end
    })
    
    BatchTab:CreateSection("Message Spammer")
    
    local spamMsg = ""
    local spamCount = 5
    local spamActive = false
    
    BatchTab:CreateInput({
        Name = "Spam Message",
        PlaceholderText = "Message to spam",
        RemoveTextAfterFocusLost = false,
        Callback = function(text) spamMsg = text end
    })
    
    BatchTab:CreateSlider({
        Name = "Spam Count",
        Range = {1, 50},
        Increment = 1,
        CurrentValue = 5,
        Callback = function(value) spamCount = value end
    })
    
    BatchTab:CreateButton({
        Name = "Start Spam",
        Callback = function()
            if State.Method == "none" then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Select method first",
                    Duration = 3
                })
                return
            end
            
            if spamMsg == "" then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Enter spam message",
                    Duration = 3
                })
                return
            end
            
            spamActive = true
            Rayfield:Notify({
                Title = "Spamming",
                Content = "Sending " .. spamCount .. " messages",
                Duration = 3
            })
            
            spawn(function()
                for i = 1, spamCount do
                    if not spamActive then break end
                    SendMessage(spamMsg)
                    task.wait(0.1)
                end
                spamActive = false
            end)
        end
    })
    
    BatchTab:CreateButton({
        Name = "Stop Spam",
        Callback = function()
            spamActive = false
            Rayfield:Notify({
                Title = "Stopped",
                Content = "Spam stopped",
                Duration = 2
            })
        end
    })
    
    local PremiumTab = Window:CreateTab("Premium", 4483362458)
    
    PremiumTab:CreateSection("Premium Features")
    
    PremiumTab:CreateParagraph({
        Title = "You Have Premium Access",
        Content = "Tier: " .. State.userData.tier .. "\nAccess: " .. (State.userData.expiry == math.huge and "Lifetime" or GetRemainingTime(State.userData.expiry)) .. "\n\nThank you for supporting Vyzen Bypasser!"
    })
    
    PremiumTab:CreateSection("Message Templates")
    
    local templates = {
        ["Toxic Combo"] = {"ur fucking trash", "ez clap", "cope harder bitch"},
        ["Roast Chain"] = {"ur a bot", "ur dogshit", "uninstall"},
        ["Spam Pack"] = {"L", "ratio", "cope"},
    }
    
    for name, msgs in pairs(templates) do
        PremiumTab:CreateButton({
            Name = name,
            Callback = function()
                if State.Method == "none" then
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Select method first",
                        Duration = 3
                    })
                    return
                end
                
                spawn(function()
                    for _, msg in ipairs(msgs) do
                        SendMessage(msg)
                        task.wait(0.2)
                    end
                end)
            end
        })
    end
    
    PremiumTab:CreateSection("Quick Actions")
    
    PremiumTab:CreateButton({
        Name = "Clear All Chat (Visual)",
        Callback = function()
            for i = 1, 50 do
                SendMessage(" ")
                task.wait(0.05)
            end
        end
    })
    
    PremiumTab:CreateButton({
        Name = "Spam Current Method Test",
        Callback = function()
            if State.Method == "none" then
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Select method first",
                    Duration = 3
                })
                return
            end
            
            Rayfield:Notify({
                Title = "Testing",
                Content = "Testing bypass method",
                Duration = 2
            })
            
            local testMsg = "test message"
            SendMessage(testMsg)
        end
    })
    
    PremiumTab:CreateSection("Chat Logger")
    
    local chatLog = {}
    local loggingEnabled = false
    
    PremiumTab:CreateToggle({
        Name = "Enable Chat Logger",
        CurrentValue = false,
        Callback = function(value)
            loggingEnabled = value
            if value then
                Rayfield:Notify({
                    Title = "Logger ON",
                    Content = "Logging all chat messages",
                    Duration = 3
                })
            else
                Rayfield:Notify({
                    Title = "Logger OFF",
                    Content = "Chat logging disabled",
                    Duration = 3
                })
            end
        end
    })
    
    spawn(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local channels = TextChatService:FindFirstChild("TextChannels")
            if channels then
                local channel = channels:FindFirstChild("RBXGeneral")
                if channel then
                    channel.MessageReceived:Connect(function(message)
                        if loggingEnabled then
                            table.insert(chatLog, 1, {
                                user = message.TextSource.Name,
                                text = message.Text,
                                time = os.date("%H:%M:%S")
                            })
                            if #chatLog > 50 then
                                table.remove(chatLog)
                            end
                        end
                    end)
                end
            end
        end
    end)
    
    PremiumTab:CreateButton({
        Name = "View Chat Log",
        Callback = function()
            if #chatLog == 0 then
                Rayfield:Notify({
                    Title = "Empty",
                    Content = "No messages logged yet",
                    Duration = 2
                })
            else
                local text = "Recent Chat:\n"
                for i, msg in ipairs(chatLog) do
                    text = text .. msg.time .. " | " .. msg.user .. ": " .. msg.text .. "\n"
                    if i >= 5 then break end
                end
                Rayfield:Notify({
                    Title = "Chat Log",
                    Content = text,
                    Duration = 5
                })
            end
        end
    })
    
    PremiumTab:CreateButton({
        Name = "Clear Chat Log",
        Callback = function()
            chatLog = {}
            Rayfield:Notify({
                Title = "Cleared",
                Content = "Chat log cleared",
                Duration = 2
            })
        end
    })
    
    PremiumTab:CreateButton({
        Name = "Export Chat Log",
        Callback = function()
            if #chatLog == 0 then
                Rayfield:Notify({
                    Title = "Empty",
                    Content = "No messages to export",
                    Duration = 2
                })
                return
            end
            
            local export = "CHAT LOG EXPORT\n\n"
            for _, msg in ipairs(chatLog) do
                export = export .. msg.time .. " | " .. msg.user .. ": " .. msg.text .. "\n"
            end
            
            setclipboard(export)
            Rayfield:Notify({
                Title = "Exported",
                Content = "Chat log copied to clipboard",
                Duration = 3
            })
        end
    })
end

local ScriptsTab = Window:CreateTab("Scripts", 4483362458)

ScriptsTab:CreateSection("Universal Scripts")

ScriptsTab:CreateButton({
    Name = "Infinite Yield (Admin)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Infinite Yield loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Fly Script V3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Fly Script V3 loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Universal ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Universal ESP loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Universal Aimbot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/main.lua"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Universal Aimbot loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Keyboard Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/advxzivhsjjdhxhsidifvsh/mobkeyboard/main/main.txt"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Keyboard script loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateSection("Movement Scripts")

ScriptsTab:CreateButton({
    Name = "The Chosen One Hub (Fling/FTap)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/blueEa1532/thechosenone/refs/heads/main/The_Chosen_One_Lite"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "The Chosen One Hub loaded",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Speed Hub X",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Speed Hub X loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Universal Noclip",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/b486ZCAM"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Noclip loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateSection("Game-Specific Scripts")

ScriptsTab:CreateButton({
    Name = "Universal Obby Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/blueEa1532/thechosenone/refs/heads/main/universalobbyMOONTCOH"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Universal Obby script loaded",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Work at a Pizza Place",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/blueEa1532/thechosenone/refs/heads/main/trollpizzagui"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Pizza Place script loaded",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Brookhaven RP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMael/NewIceHub/main/Brookhaven"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Brookhaven script loaded",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Blox Fruits",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ThunderZ-05/HohoHub/main/Main"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Blox Fruits script loaded",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Arsenal",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubArsenal"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Arsenal script loaded",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Da Hood",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/lerkermer/lua-projects/master/SwagModeV002"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Da Hood script loaded",
            Duration = 3
        })
    end
})

ScriptsTab:CreateSection("Utility Scripts")

ScriptsTab:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/9fFu43FF"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Anti-AFK loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "FPS Booster",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "FPS Booster loaded successfully",
            Duration = 3
        })
    end
})

ScriptsTab:CreateButton({
    Name = "Remote Spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
        Rayfield:Notify({
            Title = "Script Loaded",
            Content = "Remote Spy loaded successfully",
            Duration = 3
        })
    end
})

local SettingsTab = Window:CreateTab("Settings", 4483362458)

SettingsTab:CreateSection("Script Information")

SettingsTab:CreateParagraph({
    Title = "Vyzen Bypasser V2.0",
    Content = "Version: 2.0\nCreated by: Vyzen\nLast Updated: 2025\n\nDiscord: discord.gg/xkg5HSMaqQ\n\nThis script includes chat bypassing, auto bypass, custom presets, and a collection of popular scripts."
})

SettingsTab:CreateSection("How to Use")

SettingsTab:CreateParagraph({
    Title = "Chat Bypass Guide",
    Content = "1. Select a bypass method in Methods tab\n2. Click presets in Presets tab for quick send\n3. Use Manual tab for custom messages\n4. Premium: Enable Auto Bypass to type directly in game chat"
})

SettingsTab:CreateParagraph({
    Title = "Scripts Tab Guide",
    Content = "Click any script button to load it instantly. Scripts are organized by category:\n- Universal Scripts\n- Movement Scripts\n- Game-Specific Scripts\n- Utility Scripts"
})

SettingsTab:CreateSection("Account Information")

SettingsTab:CreateParagraph({
    Title = "Your Account Details",
    Content = "Username: " .. Players.LocalPlayer.Name ..
              "\nDisplay Name: " .. Players.LocalPlayer.DisplayName ..
              "\nUser ID: " .. tostring(Players.LocalPlayer.UserId) ..
              "\nAccount Age: " .. Players.LocalPlayer.AccountAge .. " days" ..
              "\nMembership: " .. tostring(Players.LocalPlayer.MembershipType) ..
              "\n\nStatus: " .. State.userData.tier ..
              "\n\nCopy your User ID to give to script owner for premium access"
})

SettingsTab:CreateSection("Performance Settings")

local FPSCounter = SettingsTab:CreateLabel("FPS: Calculating...")

spawn(function()
    local RunService = game:GetService("RunService")
    while task.wait(1) do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        if FPSCounter then
            FPSCounter:Set("Current FPS: " .. tostring(fps))
        end
    end
end)

local PingCounter = SettingsTab:CreateLabel("Ping: Calculating...")

spawn(function()
    while task.wait(2) do
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        if PingCounter then
            PingCounter:Set("Current Ping: " .. math.floor(ping) .. "ms")
        end
    end
end)

SettingsTab:CreateButton({
    Name = "Reduce Graphics (Boost FPS)",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            end
        end
        Rayfield:Notify({
            Title = "Graphics Reduced",
            Content = "Graphics optimized for better FPS",
            Duration = 3
        })
    end
})

SettingsTab:CreateButton({
    Name = "Remove Textures (Max Performance)",
    Callback = function()
        for i,v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
        Rayfield:Notify({
            Title = "Textures Removed",
            Content = "All textures removed for max FPS",
            Duration = 3
        })
    end
})

SettingsTab:CreateSection("Quick Actions")

SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
})

SettingsTab:CreateButton({
    Name = "Server Hop (New Server)",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        Rayfield:Notify({
            Title = "Server Hopping",
            Content = "Finding new server...",
            Duration = 3
        })
    end
})

SettingsTab:CreateButton({
    Name = "Copy Game Link",
    Callback = function()
        setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
        Rayfield:Notify({
            Title = "Copied",
            Content = "Game link copied to clipboard",
            Duration = 2
        })
    end
})

SettingsTab:CreateButton({
    Name = "Copy Your Profile Link",
    Callback = function()
        setclipboard("https://www.roblox.com/users/" .. Players.LocalPlayer.UserId .. "/profile")
        Rayfield:Notify({
            Title = "Copied",
            Content = "Profile link copied to clipboard",
            Duration = 2
        })
    end
})

if not State.isPremium then
    SettingsTab:CreateSection("Get Premium")
    SettingsTab:CreateParagraph({
        Title = "Premium Features",
        Content = "60+ Toxic Presets\nNo Character Limit\n0.1s Cooldown (vs 3s)\nUnlimited Custom Presets\nAuto Bypass Chat\n5 Advanced Methods\nBatch Message Sender\nMessage Spammer (1-50 messages)\nMessage Templates\nChat Logger & Export\nQuick Actions\nMessage History\nStatistics\nPriority Support\n\nJoin Discord to purchase premium"
    })
end

SettingsTab:CreateSection("Key Information")

SettingsTab:CreateParagraph({
    Title = "Your Current Key",
    Content = "Key Type: " .. (keyUsed == FreeKey and "FREE (4days)" or (State.isPremium and "PREMIUM" or "Unknown")) ..
              "\nAccess Level: " .. State.userData.tier ..
              "\n\n" .. (State.isPremium and "Your premium key gives you full access to all features!" or "You're using the free key. Get a premium key from Discord for full access!")
})

if not State.isPremium then
    SettingsTab:CreateSection("Get Premium Key")
    SettingsTab:CreateParagraph({
        Title = "How to Get Premium",
        Content = "1. Join Discord: discord.gg/xkg5HSMaqQ\n2. Purchase premium access\n3. Receive your unique premium key\n4. Enter key when loading script\n5. Enjoy all premium features!\n\nYour key will work as long as your premium is active. Keys automatically expire when premium ends."
    })
end

SettingsTab:CreateParagraph({
    Title = "Key System Explained",
    Content = "FREE KEY: 4days (Everyone can use)\n\nPREMIUM KEYS: Unique keys that link to premium users\n\nFormat: VyzenBypass + random characters\n\nKeys automatically become invalid when the linked premium expires. Add premium keys in PremiumKeys table at top of script."
})

SettingsTab:CreateParagraph({
    Title = "Add Premium Users",
    Content = "1. Add user to PremiumUsers table:\n[UserID] = {expiry = math.huge, tier = \"Premium\", color = \"Gold\"}\n\n2. Generate a unique key like:\nVyzenBypass4829hf92jd82nd\n\n3. Add to PremiumKeys table:\n[\"YourKey\"] = UserID\n\n4. Give key to user - it will work as long as their premium is active"
})

SettingsTab:CreateParagraph({
    Title = "Generate Random Keys",
    Content = "Use this format:\nVyzenBypass + 16 random characters\n\nExample:\nVyzenBypass7392hd82jf93ks\nVyzenBypass2847hs92jd73nf\nVyzenBypass9273js83hd92nf\n\nMake each key unique!"
})

SettingsTab:CreateSection("Support & Links")

SettingsTab:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard(Config.DiscordInvite)
        Rayfield:Notify({
            Title = "Copied",
            Content = "Discord invite copied to clipboard",
            Duration = 2
        })
    end
})

SettingsTab:CreateButton({
    Name = "Join Discord Server",
    Callback = function()
        setclipboard(Config.DiscordInvite)
        Rayfield:Notify({
            Title = "Discord",
            Content = "Link copied - Opening browser if possible",
            Duration = 3
        })
    end
})

SettingsTab:CreateSection("Script Controls")

SettingsTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Rayfield:Destroy()
    end
})
