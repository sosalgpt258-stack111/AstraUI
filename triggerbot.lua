-- Astra Triggerbot Module (triggerbot.lua)
local TriggerbotModule = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

function TriggerbotModule.Init()
    local enabled = false
    local teamCheck = true
    local delay = 0
    local targetPart = "HumanoidRootPart"
    local lastShot = 0

    local function IsSameTeam(player)
        return player.Team ~= nil and player.Team == localPlayer.Team
    end

    local function IsTargetOnCrosshair()
        local mouse = localPlayer:GetMouse()
        local target = mouse.Target

        if not target then return false end

        local character = target.Parent
        if not character then return false end

        local player = Players:GetPlayerFromCharacter(character)
        if not player then return false end

        if player == localPlayer then return false end
        if teamCheck and IsSameTeam(player) then return false end

        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return false end

        return true
    end

    local renderConn
    renderConn = RunService.RenderStepped:Connect(function()
        if not enabled then return end

        local now = tick()
        if now - lastShot < delay then return end

        if IsTargetOnCrosshair() then
            lastShot = now
            mouse1press()
            task.wait()
            mouse1release()
        end
    end)

    return {
        SetEnabled    = function(state) enabled = state end,
        SetTeamCheck  = function(state) teamCheck = state end,
        SetDelay      = function(value) delay = value end,
        SetTargetPart = function(part) targetPart = part end,
        Destroy = function()
            enabled = false
            if renderConn then renderConn:Disconnect() end
        end
    }
end

return TriggerbotModule
