-- Astra Main Script (main.lua)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/lib.lua"))()
local ESPModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/AstraUI/main/esp.lua"))()

-- Инициализация интерфейса
local Window = Library.New()

-- Вкладки
local AimbotTab = Window:CreateTab("Aimbot", 1)
local VisualsTab = Window:CreateTab("Visuals", 2)
local MiscTab = Window:CreateTab("Misc", 3)
local SettingsTab = Window:CreateTab("Settings", 4)
local InfoTab = Window:CreateTab("Info", 5)

-- Модуль ESP
local esp = ESPModule.Init()
esp.SetMaxDistance(500)

-- Visuals
local visualsCol = VisualsTab:CreateColumn("esp settings", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

visualsCol:CreateToggle("box corners", function(state)
    esp.SetEnabled(state)
end, function()
    print("Открыты настройки box corners")
end)

visualsCol:CreateToggle("health bar", function(state)
    esp.SetHealthBarEnabled(state)
end, function()
    print("Открыты настройки health bar")
end)

visualsCol:CreateToggle("name esp", function(state)
    esp.SetNameEnabled(state)
end)

visualsCol:CreateToggle("distance esp", function(state)
    esp.SetDistanceEnabled(state)
end)

-- Aimbot
local aimbotCol = AimbotTab:CreateColumn("aim settings", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

aimbotCol:CreateToggle("enable aimbot", function(state)
    print("Aimbot:", state)
end)

aimbotCol:CreateToggle("team check", function(state)
    print("Team check:", state)
end)

-- Misc
local miscCol = MiscTab:CreateColumn("player options", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

miscCol:CreateToggle("speedhack", function(state)
    print("Speedhack:", state)
end)

-- Settings
local settingsCol = SettingsTab:CreateColumn("management", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

settingsCol:CreateButton("unload script", function()
    esp.Destroy()
    Window:Unload()
end)
