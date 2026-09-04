-- Astra Main Script (main.lua)

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/miniature-goggles/main/lib.lua"))()
local ESPModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/sosalgpt258-stack111/miniature-goggles/main/esp.lua"))()

-- Инициализация окна
local Window = Library.New()

-- Создание вкладок
local AimbotTab = Window:CreateTab("Aimbot", 1)
local VisualsTab = Window:CreateTab("Visuals", 2)
local MiscTab = Window:CreateTab("Misc", 3)
local SettingsTab = Window:CreateTab("Settings", 4)
local InfoTab = Window:CreateTab("Info", 5)

-- Колонка визуалов
local visualsCol = VisualsTab:CreateColumn("esp settings", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))
local esp = ESPModule.Init()

esp.SetMaxDistance(500)

visualsCol:CreateToggle("box corners", function(state)
    esp.SetEnabled(state)
end)

visualsCol:CreateToggle("health bar", function(state)
    esp.SetHealthBarEnabled(state)
end)

visualsCol:CreateToggle("name esp", function(state)
    esp.SetNameEnabled(state)
end)

visualsCol:CreateToggle("distance esp", function(state)
    esp.SetDistanceEnabled(state)
end)

-- Колонка настроек
local settingsCol = SettingsTab:CreateColumn("management", UDim2.new(0, 12, 0, 10), UDim2.new(0, 195, 0, 355))

settingsCol:CreateButton("unload script", function()
    esp.Destroy()
    Window:Unload()
end)
