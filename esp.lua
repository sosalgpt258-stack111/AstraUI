-- Astra ESP Module (esp.lua)
local ESPModule = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

function ESPModule.Init()
    local boxEnabled = false
    local healthBarEnabled = false
    local nameEnabled = false
    local distanceEnabled = false
    local maxDistance = 500
    local espCache = {}
    local renderConnection = nil

    local function CreateDrawing(type, properties)
        local drawing = Drawing.new(type)
        for k, v in pairs(properties) do
            drawing[k] = v
        end
        return drawing
    end

    local function CreatePlayerESP(player)
        if espCache[player] then return end
        espCache[player] = {
            TL1 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            TL2 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            TR1 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            TR2 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            BL1 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            BL2 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            BR1 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            BR2 = CreateDrawing("Line", {Visible = false, Thickness = 1.5, Color = Color3.fromRGB(255, 255, 255)}),
            HealthBar = CreateDrawing("Line", {Visible = false, Thickness = 2, Color = Color3.fromRGB(0, 255, 0)}),
            NameText = CreateDrawing("Text", {Visible = false, Size = 14, Center = true, Outline = true, Color = Color3.fromRGB(255, 255, 255)}),
            DistanceText = CreateDrawing("Text", {Visible = false, Size = 13, Center = false, Outline = true, Color = Color3.fromRGB(255, 255, 255)})
        }
    end

    local function RemovePlayerESP(player)
        if espCache[player] then
            for _, drawing in pairs(espCache[player]) do
                pcall(function() drawing:Remove() end)
            end
            espCache[player] = nil
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then CreatePlayerESP(player) end
    end

    local addedConn = Players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then CreatePlayerESP(player) end
    end)

    local removingConn = Players.PlayerRemoving:Connect(function(player)
        RemovePlayerESP(player)
    end)

    renderConnection = RunService.RenderStepped:Connect(function()
        if not boxEnabled and not healthBarEnabled and not nameEnabled and not distanceEnabled then
            for _, lines in pairs(espCache) do
                for _, line in pairs(lines) do
                    line.Visible = false
                end
            end
            return
        end

        local localChar = localPlayer.Character
        local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

        for player, lines in pairs(espCache) do
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")

            local visible = false
            if localRoot and character and rootPart and humanoid and humanoid.Health > 0 then
                local distance = (localRoot.Position - rootPart.Position).Magnitude

                if distance <= maxDistance then
                    local cf, size = character:GetBoundingBox()
                    local topPoint = (cf + Vector3.new(0, size.Y / 2, 0)).Position
                    local bottomPoint = (cf - Vector3.new(0, size.Y / 2, 0)).Position

                    local topVector, topOnScreen = Camera:WorldToViewportPoint(topPoint)
                    local bottomVector, bottomOnScreen = Camera:WorldToViewportPoint(bottomPoint)

                    if topOnScreen or bottomOnScreen then
                        local height = math.abs(topVector.Y - bottomVector.Y)
                        local width = height * 0.65
                        local x = topVector.X - width / 2
                        local y = topVector.Y
                        local length = math.clamp(width / 4, 6, 15)

                        -- 1. Боксы (с исправленными углами)
                        if boxEnabled then
                            lines.TL1.From = Vector2.new(x, y) lines.TL1.To = Vector2.new(x + length, y)
                            lines.TL2.From = Vector2.new(x, y) lines.TL2.To = Vector2.new(x, y + length)

                            lines.TR1.From = Vector2.new(x + width, y) lines.TR1.To = Vector2.new(x + width - length, y)
                            lines.TR2.From = Vector2.new(x + width, y) lines.TR2.To = Vector2.new(x + width, y + length)

                            lines.BL1.From = Vector2.new(x, y + height) lines.BL1.To = Vector2.new(x + length, y + height)
                            lines.BL2.From = Vector2.new(x, y + height) lines.BL2.To = Vector2.new(x, y + height - length)

                            lines.BR1.From = Vector2.new(x + width, y + height) lines.BR1.To = Vector2.new(x + width - length, y + height)
                            lines.BR2.From = Vector2.new(x + width, y + height) lines.BR2.To = Vector2.new(x + width, y + height - length)

                            for _, name in ipairs({"TL1", "TL2", "TR1", "TR2", "BL1", "BL2", "BR1", "BR2"}) do
                                lines[name].Visible = true
                            end
                        else
                            for _, name in ipairs({"TL1", "TL2", "TR1", "TR2", "BL1", "BL2", "BR1", "BR2"}) do
                                lines[name].Visible = false
                            end
                        end

                        -- 2. Хелсбар (слева, толщина 2)
                        if healthBarEnabled then
                            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            local barX = boxEnabled and (x - 6) or (x + 2)
                            
                            local currentHeight = height * healthPercent
                            lines.HealthBar.From = Vector2.new(barX, y + height)
                            lines.HealthBar.To = Vector2.new(barX, y + height - currentHeight)
                            lines.HealthBar.Color = Color3.fromRGB(255 - (healthPercent * 255), healthPercent * 255, 0)
                            lines.HealthBar.Visible = true
                        else
                            lines.HealthBar.Visible = false
                        end

                        -- 3. Никнейм (сверху по центру)
                        if nameEnabled then
                            lines.NameText.Text = player.Name
                            lines.NameText.Position = Vector2.new(x + (width / 2), y - 16)
                            lines.NameText.Visible = true
                        else
                            lines.NameText.Visible = false
                        end

                        -- 4. Дистанция (справа от бокса, по центру высоты)
                        if distanceEnabled then
                            lines.DistanceText.Text = math.floor(distance) .. "m"
                            lines.DistanceText.Position = Vector2.new(x + width + 5, y + (height / 2) - 6)
                            lines.DistanceText.Visible = true
                        else
                            lines.DistanceText.Visible = false
                        end

                        visible = true
                    end
                end
            end

            if not visible then
                for _, line in pairs(lines) do
                    line.Visible = false
                end
            end
        end
    end)

    return {
        SetEnabled = function(state) boxEnabled = state end,
        SetHealthBarEnabled = function(state) healthBarEnabled = state end,
        SetNameEnabled = function(state) nameEnabled = state end,
        SetDistanceEnabled = function(state) distanceEnabled = state end,
        SetMaxDistance = function(distance) maxDistance = distance end,
        Destroy = function()
            boxEnabled = false
            healthBarEnabled = false
            nameEnabled = false
            distanceEnabled = false
            if renderConnection then renderConnection:Disconnect() end
            if addedConn then addedConn:Disconnect() end
            if removingConn then removingConn:Disconnect() end
            for player, _ in pairs(espCache) do
                RemovePlayerESP(player)
            end
        end
    }
end

return ESPModule
