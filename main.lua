-- Astra Main Script (main.lua) — Triggerbot Only
local Library    = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt25block111/AstraUI/main/lib.lua"))()
local ESPModule  = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/esp.lua"))()
local AimModule  = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/aimbot.lua"))()
local Triggerbot = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/triggerbot.lua"))()

local Window = Library.New()

local AimbotTab   = Window:CreateTab("Aimbot",   1)
local CombatTab   = Window:CreateTab("Combat",   2)
local VisualsTab  = Window:CreateTab("Visuals",  3)
local SettingsTab = Window:CreateTab("Settings", 4)
local InfoTab     = Window:CreateTab("Info",     5)

local esp = ESPModule.Init()
local aim = AimModule.Init()
local trigger = Triggerbot.Init()
esp.SetMaxDistance(500)

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function CreateSettingsPanel(title, buildCallback)
    local ScreenGui = CoreGui:FindFirstChild("AstraStyleMenu")
    if not ScreenGui then return end

    local Overlay = Instance.new("Frame")
    Overlay.Name = "SettingsOverlay"
    Overlay.Parent = ScreenGui
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.ZIndex = 20

    local Panel = Instance.new("Frame")
    Panel.Parent = Overlay
    Panel.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    Panel.BorderSizePixel = 0
    Panel.AnchorPoint = Vector2.new(0.5, 0.5)
    Panel.Position = UDim2.new(0.5, 0, 0.5, 0)
    Panel.Size = UDim2.new(0, 240, 0, 0)
    Panel.AutomaticSize = Enum.AutomaticSize.Y
    Panel.ZIndex = 21
    Panel.ClipsDescendants = true

    local PanelCorner = Instance.new("UICorner")
    PanelCorner.CornerRadius = UDim.new(0, 6)
    PanelCorner.Parent = Panel

    local PanelStroke = Instance.new("UIStroke")
    PanelStroke.Color = Color3.fromRGB(35, 35, 45)
    PanelStroke.Thickness = 1
    PanelStroke.Parent = Panel

    local PanelPadding = Instance.new("UIPadding")
    PanelPadding.PaddingTop    = UDim.new(0, 12)
    PanelPadding.PaddingBottom = UDim.new(0, 14)
    PanelPadding.PaddingLeft   = UDim.new(0, 14)
    PanelPadding.PaddingRight  = UDim.new(0, 14)
    PanelPadding.Parent = Panel

    local PanelList = Instance.new("UIListLayout")
    PanelList.SortOrder = Enum.SortOrder.LayoutOrder
    PanelList.Padding = UDim.new(0, 10)
    PanelList.Parent = Panel

    local TitleRow = Instance.new("Frame")
    TitleRow.BackgroundTransparency = 1
    TitleRow.Size = UDim2.new(1, 0, 0, 22)
    TitleRow.LayoutOrder = 0
    TitleRow.Parent = Panel

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleRow
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -26, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 22

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TitleRow
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Position = UDim2.new(1, 0, 0.5, 0)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(120, 120, 130)
    CloseBtn.TextSize = 12
    CloseBtn.ZIndex = 22
    CloseBtn.MouseButton1Click:Connect(function() Overlay:Destroy() end)
    Overlay.MouseButton1Click:Connect(function() Overlay:Destroy() end)

    local Divider = Instance.new("Frame")
    Divider.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Divider.BorderSizePixel = 0
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.LayoutOrder = 1
    Divider.Parent = Panel

    local ContentFrame = Instance.new("Frame")
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Size = UDim2.new(1, 0, 0, 0)
    ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
    ContentFrame.LayoutOrder = 2
    ContentFrame.Parent = Panel

    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 8)
    ContentList.Parent = ContentFrame

    buildCallback(ContentFrame, Panel)
end

local function CreateSlider(parent, labelText, minVal, maxVal, defaultVal, layoutOrder, onChange)
    local currentVal = defaultVal

    local Container = Instance.new("Frame")
    Container.Parent = parent
    Container.BackgroundTransparency = 1
    Container.Size = UDim2.new(1, 0, 0, 42)
    Container.LayoutOrder = layoutOrder
    Container.ZIndex = 22

    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = labelText .. ": " .. tostring(defaultVal)
    Label.TextColor3 = Color3.fromRGB(150, 150, 160)
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 22

    local Track = Instance.new("Frame")
    Track.Parent = parent
    Track.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Track.BorderSizePixel = 0
    Track.Position = UDim2.new(0, 0, 0, 24)
    Track.Size = UDim2.new(1, 0, 0, 8)
    Track.ZIndex = 22

    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Parent = Track
    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.ZIndex = 22

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Parent = Track
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 0.5, 0)
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.ZIndex = 23

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = Color3.fromRGB(45, 45, 55)
    KnobStroke.Thickness = 1
    KnobStroke.Parent = Knob

    local dragging = false
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            currentVal = math.floor(minVal + (maxVal - minVal) * relX)
            Fill.Size = UDim2.new(relX, 0, 1, 0)
            Knob.Position = UDim2.new(relX, 0, 0.5, 0)
            Label.Text = labelText .. ": " .. tostring(currentVal)
            onChange(currentVal)
        end
    end)
end

local function OpenTriggerbotSettings()
    CreateSettingsPanel("triggerbot settings", function(content, panel)
        CreateSlider(content, "delay (ms)", 0, 500, 50, 0, function(val)
            trigger.SetDelay(val / 1000)
        end)
    end)
end

local aimbotCol = AimbotTab:CreateColumn("aim settings", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

aimbotCol:CreateToggle("enable aimbot", function(state)
    aim.SetEnabled(state)
end)

aimbotCol:CreateToggle("team check", function(state)
    aim.SetTeamCheck(state)
end)

local combatCol = CombatTab:CreateColumn("triggerbot", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

combatCol:CreateToggle("enable triggerbot", function(state)
    trigger.SetEnabled(state)
end, function()
    OpenTriggerbotSettings()
end)

combatCol:CreateToggle("trigger team check", function(state)
    trigger.SetTeamCheck(state)
end)

local visualsCol = VisualsTab:CreateColumn("esp settings", UDim2.new(0, 12, 0, 10), UDim2.new(0, 120, 0, 355))

visualsCol:CreateToggle("box corners", function(state)
    esp.SetEnabled(state)
end)

visualsCol:CreateToggle("box team check", function(state)
    esp.SetBoxTeamCheck(state)
end)

visualsCol:CreateToggle("health bar", function(state)
    esp.SetHealthBarEnabled(state)
end)

visualsCol:CreateToggle("health team check", function(state)
    esp.SetHealthTeamCheck(state)
end)

visualsCol:CreateToggle("name esp", function(state)
    esp.SetNameEnabled(state)
end)

visualsCol:CreateToggle("distance esp", function(state)
    esp.SetDistanceEnabled(state)
end)

local settingsCol = SettingsTab:CreateColumn("management", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

settingsCol:CreateButton("unload script", function()
    esp.Destroy()
    aim.Destroy()
    trigger.Destroy()
    Window:Unload()
end)

local infoCol = InfoTab:CreateColumn("about", UDim2.new(0, 12, 0, 0, 10), UDim2.new(0, 195, 0, 355))

infoCol:CreateButton("Astra v2.1 | Triggerbot Edition", function() end)
infoCol:CreateButton("Insert — открыть/закрыть меню", function() end)
