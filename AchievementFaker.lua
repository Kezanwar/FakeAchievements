-- Achievement Faker Addon
local addonName = "AchievementFaker"
local AF = {}

-- Default settings
local defaults = {
    lastChannel = "GUILD",
    customAchievements = {}
}

-- Channel options
local channels = {
    {key = "SAY", display = "Say"},
    {key = "YELL", display = "Yell"},
    {key = "PARTY", display = "Party"},
    {key = "RAID", display = "Raid"},
    {key = "GUILD", display = "Guild"},
    {key = "OFFICER", display = "Officer"},
}

-- Initialize saved variables
local function InitDB()
    if not AchievementFakerDB then
        AchievementFakerDB = {}
    end
    for k, v in pairs(defaults) do
        if AchievementFakerDB[k] == nil then
            AchievementFakerDB[k] = v
        end
    end
end

-- Send fake achievement
local function SendFakeAchievement(achievement, channel, customName)
    local playerName = customName and customName ~= "" and customName or UnitName("player")
    local message = string.format("%s has earned the achievement [%s]!", playerName, achievement)
    
    -- Validate channel
    if channel == "PARTY" and not IsInGroup() then
        print("|cffff0000You are not in a party!|r")
        return
    end
    if channel == "RAID" and not IsInRaid() then
        print("|cffff0000You are not in a raid!|r")
        return
    end
    if channel == "GUILD" and not IsInGuild() then
        print("|cffff0000You are not in a guild!|r")
        return
    end
    if channel == "OFFICER" and not IsInGuild() then
        print("|cffff0000You are not in a guild!|r")
        return
    end
    
    -- Send the message
    SendChatMessage(message, channel)
    print("|cff00ff00Achievement sent to " .. channel .. "!|r")
end

-- Create the main frame
local function CreateMainFrame()
    local frame = CreateFrame("Frame", "AchievementFakerFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(400, 500)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:Hide()
    
    frame.title = frame:CreateFontString(nil, "OVERLAY")
    frame.title:SetFontObject("GameFontHighlight")
    frame.title:SetPoint("TOP", frame, "TOP", 0, -5)
    frame.title:SetText("Achievement Faker")
    
    -- Channel dropdown
    local channelLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    channelLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -40)
    channelLabel:SetText("Channel:")
    
    local channelDropdown = CreateFrame("Frame", "AchievementFakerChannelDropdown", frame, "UIDropDownMenuTemplate")
    channelDropdown:SetPoint("TOPLEFT", channelLabel, "BOTTOMLEFT", -15, -5)
    UIDropDownMenu_SetWidth(channelDropdown, 150)
    
    -- Initialize dropdown
    UIDropDownMenu_Initialize(channelDropdown, function(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for _, ch in ipairs(channels) do
            info.text = ch.display
            info.value = ch.key
            info.func = function(self)
                AchievementFakerDB.lastChannel = self.value
                UIDropDownMenu_SetSelectedValue(channelDropdown, self.value)
            end
            info.checked = (AchievementFakerDB.lastChannel == ch.key)
            UIDropDownMenu_AddButton(info)
        end
    end)
    
    -- Set initial value
    UIDropDownMenu_SetSelectedValue(channelDropdown, AchievementFakerDB.lastChannel)
    
    -- Player name input
    local nameLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -100)
    nameLabel:SetText("Player Name (leave empty for yourself):")
    
    local nameInput = CreateFrame("EditBox", "AchievementFakerNameInput", frame, "InputBoxTemplate")
    nameInput:SetSize(200, 30)
    nameInput:SetPoint("TOPLEFT", nameLabel, "BOTTOMLEFT", 10, -5)
    nameInput:SetAutoFocus(false)
    nameInput:SetMaxLetters(12)
    nameInput:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    
    -- Use Target button
    local useTargetBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    useTargetBtn:SetSize(90, 30)
    useTargetBtn:SetPoint("LEFT", nameInput, "RIGHT", 5, 0)
    useTargetBtn:SetText("Use Target")
    useTargetBtn:SetScript("OnClick", function()
        if UnitExists("target") and UnitIsPlayer("target") then
            local targetName = UnitName("target")
            nameInput:SetText(targetName)
            print("|cff00ff00Target name set to: " .. targetName .. "|r")
        else
            print("|cffff0000No valid player target!|r")
        end
    end)
    
    frame.nameInput = nameInput
    
    -- Custom achievement section
    local customLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    customLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -160)
    customLabel:SetText("Custom Achievement:")
    
    -- Text input box
    local customInput = CreateFrame("EditBox", "AchievementFakerCustomInput", frame, "InputBoxTemplate")
    customInput:SetSize(280, 30)
    customInput:SetPoint("TOPLEFT", customLabel, "BOTTOMLEFT", 10, -5)
    customInput:SetAutoFocus(false)
    customInput:SetMaxLetters(100)
    
    -- Send custom button
    local sendCustomBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    sendCustomBtn:SetSize(60, 30)
    sendCustomBtn:SetPoint("LEFT", customInput, "RIGHT", 5, 0)
    sendCustomBtn:SetText("Send")
    sendCustomBtn:SetScript("OnClick", function()
        local text = customInput:GetText()
        if text and text ~= "" then
            -- Check if it already exists
            local exists = false
            for _, ach in ipairs(AchievementFakerDB.customAchievements) do
                if ach == text then
                    exists = true
                    break
                end
            end
            
            -- Add to saved achievements if new
            if not exists then
                table.insert(AchievementFakerDB.customAchievements, text)
                frame.RefreshAchievementList()
                print("|cff00ff00Achievement saved!|r")
            end
            
            local customName = frame.nameInput:GetText()
            SendFakeAchievement(text, AchievementFakerDB.lastChannel, customName)
            customInput:SetText("")
            customInput:ClearFocus()
        else
            print("|cffff0000Please enter an achievement text!|r")
        end
    end)
    
    -- Also send on Enter key
    customInput:SetScript("OnEnterPressed", function(self)
        sendCustomBtn:GetScript("OnClick")()
    end)
    customInput:SetScript("OnEscapePressed", function(self)
        self:ClearFocus()
    end)
    
    -- Achievement list title
    local listLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    listLabel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -240)
    listLabel:SetText("Saved Achievements:")
    
    -- Scroll frame for achievements
    local scrollFrame = CreateFrame("ScrollFrame", "AchievementFakerScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", listLabel, "BOTTOMLEFT", 0, -10)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)
    
    local scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(scrollFrame:GetWidth())
    scrollChild:SetHeight(1)
    
    local emptyText = nil
    
    -- Function to refresh the achievement list
    local function RefreshAchievementList()
        -- Clear existing buttons
        local children = {scrollChild:GetChildren()}
        for _, child in ipairs(children) do
            child:Hide()
            child:SetParent(nil)
        end
        
        -- Clear empty text if it exists
        if emptyText then
            emptyText:Hide()
            emptyText = nil
        end
        
        -- Create buttons for saved achievements
        local yOffset = 0
        for i, ach in ipairs(AchievementFakerDB.customAchievements) do
            -- Achievement button
            local btn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
            btn:SetSize(260, 30)
            btn:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -yOffset)
            btn:SetText(ach)
            btn:SetScript("OnClick", function()
                local customName = frame.nameInput:GetText()
                SendFakeAchievement(ach, AchievementFakerDB.lastChannel, customName)
            end)
            
            -- Remove button
            local removeBtn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
            removeBtn:SetSize(50, 30)
            removeBtn:SetPoint("LEFT", btn, "RIGHT", 5, 0)
            removeBtn:SetText("X")
            removeBtn:SetScript("OnClick", function()
                table.remove(AchievementFakerDB.customAchievements, i)
                RefreshAchievementList()
                print("|cffff9900Achievement removed!|r")
            end)
            
            yOffset = yOffset + 35
        end
        
        -- Show message if no achievements
        if #AchievementFakerDB.customAchievements == 0 then
            emptyText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            emptyText:SetPoint("TOP", scrollChild, "TOP", 0, -10)
            emptyText:SetText("No saved achievements yet!\nType one above and send it to save.")
            emptyText:SetTextColor(0.7, 0.7, 0.7)
        end
        
        scrollChild:SetHeight(math.max(yOffset, 50))
    end
    
    frame.RefreshAchievementList = RefreshAchievementList
    
    -- Initial list population
    RefreshAchievementList()
    
    return frame
end

-- Slash command handler
local function SlashCommandHandler(msg)
    if not AF.mainFrame then
        AF.mainFrame = CreateMainFrame()
    end
    
    if AF.mainFrame:IsShown() then
        AF.mainFrame:Hide()
    else
        AF.mainFrame:Show()
    end
end

-- Event handler
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, loadedAddon)
    if loadedAddon == addonName then
        InitDB()
        print("|cff00ff00Achievement Faker loaded! Type /achfake to open.|r")
    end
end)

-- Register slash commands
SLASH_ACHIEVEMENTFAKER1 = "/achfake"
SlashCmdList["ACHIEVEMENTFAKER"] = SlashCommandHandler