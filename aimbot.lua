-- Astra Aimbot Module (aimbot.lua)
local AimbotModule = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

function AimbotModule.Init()
    local enabled = false
    local teamCheck = false
    local fov = 120
    local smoothing = 0.15
    local targetPart = "Head"
    local aimKey = Enum.KeyCode.E
    local renderConn = nil

    local fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.Filled = false
    fovCircle.NumSides = 64
    fovCircle.Radius = fov
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local function GetViewportCenter()
        return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end

    local function IsSameTeam(player)
        return player.Team ~= nil and player.Team == localPlayer.Team
    end

    local function GetClosestTarget()
        local center = GetViewportCenter()
        local closestDist = math.huge
        local closestPart = nil

        for _, player in ipairs(Players:GetPlayers()) do
            if player == localPlayer then continue end
            if teamCheck and IsSameTeam(player) then continue end

            local character = player.Character
            if not character then continue end

            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then continue end

            local part = character:FindFirstChild(targetPart)
            if not part then continue end

            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end

            local screenVec = Vector2.new(screenPos.X, screenPos.Y)
            local dist = (screenVec - center).Magnitude

            if dist < fov and dist < closestDist then
                closestDist = dist
                closestPart = part
            end
        end

        return closestPart
    end

    renderConn = RunService.RenderStepped:Connect(function()
        local center = GetViewportCenter()
        fovCircle.Position = center

        if not enabled then
            fovCircle.Visible = false
            return
        end

        fovCircle.Visible = true
        fovCircle.Radius = fov

        local holding = UserInputService:IsKeyDown(aimKey)
        if not holding then return end

        local target = GetClosestTarget()
        if not target then return end

        local screenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
        if not onScreen then return end

        local targetVec = Vector2.new(screenPos.X, screenPos.Y)
        local currentAngle = Camera.CFrame
        local targetAngle = Camera.CFrame * CFrame.new(Camera:ScreenPointToRay(targetVec.X, targetVec.Y).Direction * 100)

        local targetCF = CFrame.lookAt(currentAngle.Position, target.Position)
        Camera.CFrame = currentAngle:Lerp(targetCF, smoothing)
    end)

    return {
        SetEnabled    = function(state) enabled = state end,
        SetTeamCheck  = function(state) teamCheck = state end,
        SetFOV        = function(value) fov = value end,
        SetSmoothing  = function(value) smoothing = value end,
        SetTargetPart = function(part) targetPart = part end,
        SetAimKey     = function(key) aimKey = key end,
        Destroy = function()
            enabled = false
            if renderConn then renderConn:Disconnect() end
            pcall(function() fovCircle:Remove() end)
        end
    }
end

return AimbotModule
