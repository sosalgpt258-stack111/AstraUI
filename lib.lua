-- Astra Library (lib.lua)
local Library = {}

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

function Library.New()
    if CoreGui:FindFirstChild("AstraStyleMenu") then
        CoreGui.AstraStyleMenu:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AstraStyleMenu"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Водяная марка
    local WatermarkFrame = Instance.new("Frame")
    WatermarkFrame.Name = "Watermark"
    WatermarkFrame.Parent = ScreenGui
    WatermarkFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    WatermarkFrame.BorderSizePixel = 0
    WatermarkFrame.AnchorPoint = Vector2.new(0.5, 0)
    WatermarkFrame.Position = UDim2.new(0.5, 0, 0, 0)
    WatermarkFrame.Size = UDim2.new(0, 185, 0, 30)

    local WatermarkCorner = Instance.new("UICorner")
    WatermarkCorner.CornerRadius = UDim.new(1, 0)
    WatermarkCorner.Parent = WatermarkFrame

    local WatermarkStroke = Instance.new("UIStroke")
    WatermarkStroke.Color = Color3.fromRGB(45, 45, 55)
    WatermarkStroke.Thickness = 1
    WatermarkStroke.Parent = WatermarkFrame

    local WatermarkText = Instance.new("TextLabel")
    WatermarkText.Parent = WatermarkFrame
    WatermarkText.BackgroundTransparency = 1
    WatermarkText.Size = UDim2.new(1, 0, 1, 0)
    WatermarkText.Font = Enum.Font.GothamBold
    WatermarkText.TextSize = 12
    WatermarkText.TextColor3 = Color3.fromRGB(220, 220, 230)
    WatermarkText.TextXAlignment = Enum.TextXAlignment.Center

    local lastUpdate = 0
    local fpsSamples = {}
    local pingSamples = {}

    RunService.RenderStepped:Connect(function(dt)
        local currentFps = dt > 0 and (1 / dt) or 0
        table.insert(fpsSamples, currentFps)
        if #fpsSamples > 20 then table.remove(fpsSamples, 1) end

        local success, currentPing = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if success and currentPing then
            table.insert(pingSamples, currentPing)
            if #pingSamples > 20 then table.remove(pingSamples, 1) end
        end

        if tick() - lastUpdate > 1.0 then
            lastUpdate = tick()
            local avgFps = 0
            for _, v in ipairs(fpsSamples) do avgFps = avgFps + v end
            avgFps = math.floor(avgFps / #fpsSamples)

            local avgPing = 0
            if #pingSamples > 0 then
                for _, v in ipairs(pingSamples) do avgPing = avgPing + v end
                avgPing = math.floor(avgPing / #pingSamples)
            end

            WatermarkText.Text = "Astra | " .. avgFps .. " fps | " .. avgPing .. " ms"
        end
    end)

    -- Главное меню
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    MainFrame.BorderSizePixel = 0
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
    MainFrame.Size = UDim2.new(0, 630, 0, 420)
    MainFrame.Visible = false

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 6)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(35, 35, 45)
    MainStroke.Thickness = 1
    MainStroke.Parent = MainFrame

    local TabsBackground = Instance.new("Frame")
    TabsBackground.Name = "TabsBackground"
    TabsBackground.Parent = MainFrame
    TabsBackground.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    TabsBackground.BorderSizePixel = 0
    TabsBackground.Position = UDim2.new(0, 12, 0, 8)
    TabsBackground.Size = UDim2.new(0, 606, 0, 28)

    local TabsBgCorner = Instance.new("UICorner")
    TabsBgCorner.CornerRadius = UDim.new(0, 4)
    TabsBgCorner.Parent = TabsBackground

    local TabsBgStroke = Instance.new("UIStroke")
    TabsBgStroke.Color = Color3.fromRGB(30, 30, 40)
    TabsBgStroke.Thickness = 1
    TabsBgStroke.Parent = TabsBackground

    local AstraTitle = Instance.new("TextLabel")
    AstraTitle.Parent = TabsBackground
    AstraTitle.BackgroundTransparency = 1
    AstraTitle.Position = UDim2.new(0, 15, 0, 0)
    AstraTitle.Size = UDim2.new(0, 80, 1, 0)
    AstraTitle.Font = Enum.Font.GothamBold
    AstraTitle.Text = "ASTRA"
    AstraTitle.TextColor3 = Color3.fromRGB(240, 240, 255)
    AstraTitle.TextSize = 15
    AstraTitle.TextXAlignment = Enum.TextXAlignment.Left
    AstraTitle.ZIndex = 3

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = TabsBackground
    TopBar.BackgroundTransparency = 1
    TopBar.Position = UDim2.new(0, 120, 0, 0)
    TopBar.Size = UDim2.new(1, -130, 1, 0)

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TopBar
    TabListLayout.FillDirection = Enum.FillDirection.Horizontal
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)

    local SlidingIndicator = Instance.new("Frame")
    SlidingIndicator.Name = "SlidingIndicator"
    SlidingIndicator.Parent = TabsBackground
    SlidingIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SlidingIndicator.BorderSizePixel = 0
    SlidingIndicator.Size = UDim2.new(0, 50, 0, 2)
    SlidingIndicator.Position = UDim2.new(0, 0, 1, -2)
    SlidingIndicator.ZIndex = 4

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = SlidingIndicator

    local PagesContainer = Instance.new("Frame")
    PagesContainer.Name = "PagesContainer"
    PagesContainer.Parent = MainFrame
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Position = UDim2.new(0, 0, 0, 45)
    PagesContainer.Size = UDim2.new(1, 0, 1, -45)

    local tabs = {}
    local pages = {}

    local function SwitchTab(targetPage, targetBtn)
        for _, p in pairs(pages) do p.Visible = (p == targetPage) end
        for _, t in pairs(tabs) do t.TextColor3 = Color3.fromRGB(120, 120, 130) end
        targetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

        local btnAbsPos = targetBtn.AbsolutePosition.X
        local parentAbsPos = TabsBackground.AbsolutePosition.X
        local relativeX = btnAbsPos - parentAbsPos
        local targetWidth = targetBtn.AbsoluteSize.X

        TweenService:Create(SlidingIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, relativeX + 4, 1, -2),
            Size = UDim2.new(0, targetWidth - 8, 0, 2)
        }):Play()
    end

    local Window = {}

    function Window:CreateTab(name, order)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "Tab"
        TabBtn.Parent = TopBar
        TabBtn.BackgroundTransparency = 1
        TabBtn.Size = UDim2.new(0, 65, 1, 0)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(120, 120, 130)
        TabBtn.TextSize = 12
        TabBtn.LayoutOrder = order
        TabBtn.ZIndex = 3

        local Page = Instance.new("Frame")
        Page.Name = name .. "Page"
        Page.Parent = PagesContainer
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false

        TabBtn.MouseButton1Click:Connect(function()
            SwitchTab(Page, TabBtn)
        end)

        table.insert(tabs, TabBtn)
        table.insert(pages, Page)

        if #tabs == 1 then
            Page.Visible = true
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.spawn(function()
                task.wait()
                local btnAbsPos = TabBtn.AbsolutePosition.X
                local parentAbsPos = TabsBackground.AbsolutePosition.X
                local relativeX = btnAbsPos - parentAbsPos
                SlidingIndicator.Position = UDim2.new(0, relativeX + 4, 1, -2)
                SlidingIndicator.Size = UDim2.new(0, TabBtn.AbsoluteSize.X - 8, 0, 2)
            end)
        end

        local TabObj = {}

        function TabObj:CreateColumn(title, positionX, sizeWidth)
            local Col = Instance.new("Frame")
            Col.Name = title .. "Col"
            Col.Parent = Page
            Col.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
            Col.BorderSizePixel = 0
            Col.Position = positionX
            Col.Size = sizeWidth

            local ColCorner = Instance.new("UICorner")
            ColCorner.CornerRadius = UDim.new(0, 6)
            ColCorner.Parent = Col

            local ColStroke = Instance.new("UIStroke")
            ColStroke.Color = Color3.fromRGB(30, 30, 40)
            ColStroke.Thickness = 1
            ColStroke.Parent = Col

            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Parent = Col
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 0, 0, 10)
            TitleLabel.Size = UDim2.new(1, 0, 0, 20)
            TitleLabel.Font = Enum.Font.GothamMedium
            TitleLabel.Text = title
            TitleLabel.TextColor3 = Color3.fromRGB(170, 170, 180)
            TitleLabel.TextSize = 13

            local Line = Instance.new("Frame")
            Line.Parent = Col
            Line.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
            Line.BorderSizePixel = 0
            Line.Position = UDim2.new(0.08, 0, 0, 35)
            Line.Size = UDim2.new(0.84, 0, 0, 1)

            local ListContainer = Instance.new("ScrollingFrame")
            ListContainer.Parent = Col
            ListContainer.Active = true
            ListContainer.BackgroundTransparency = 1
            ListContainer.Position = UDim2.new(0, 0, 0, 42)
            ListContainer.Size = UDim2.new(1, 0, 1, -45)
            ListContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
            ListContainer.ScrollBarThickness = 0

            local UIList = Instance.new("UIListLayout")
            UIList.Parent = ListContainer
            UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIList.SortOrder = Enum.SortOrder.LayoutOrder
            UIList.Padding = UDim.new(0, 8)

            local ColObj = {}

            function ColObj:CreateButton(text, callback)
                local Btn = Instance.new("TextButton")
                Btn.Parent = ListContainer
                Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                Btn.Size = UDim2.new(0.9, 0, 0, 30)
                Btn.AutoButtonColor = false
                Btn.Font = Enum.Font.GothamMedium
                Btn.Text = text
                Btn.TextColor3 = Color3.fromRGB(200, 200, 210)
                Btn.TextSize = 12

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 4)
                BtnCorner.Parent = Btn

                local BtnStroke = Instance.new("UIStroke")
                BtnStroke.Color = Color3.fromRGB(45, 45, 55)
                BtnStroke.Thickness = 1
                BtnStroke.Parent = Btn

                Btn.MouseButton1Click:Connect(callback)
            end

            function ColObj:CreateToggle(text, callback)
                local Tgl = Instance.new("TextButton")
                Tgl.Parent = ListContainer
                Tgl.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                Tgl.Size = UDim2.new(0.9, 0, 0, 30)
                Tgl.AutoButtonColor = false
                Tgl.Font = Enum.Font.GothamMedium
                Tgl.Text = "   " .. text
                Tgl.TextColor3 = Color3.fromRGB(200, 200, 210)
                Tgl.TextSize = 12
                Tgl.TextXAlignment = Enum.TextXAlignment.Left

                local TglCorner = Instance.new("UICorner")
                TglCorner.CornerRadius = UDim.new(0, 4)
                TglCorner.Parent = Tgl

                local TglStroke = Instance.new("UIStroke")
                TglStroke.Color = Color3.fromRGB(45, 45, 55)
                TglStroke.Thickness = 1
                TglStroke.Parent = Tgl

                local Indicator = Instance.new("Frame")
                Indicator.Parent = Tgl
                Indicator.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
                Indicator.BorderSizePixel = 0
                Indicator.AnchorPoint = Vector2.new(1, 0.5)
                Indicator.Position = UDim2.new(1, -10, 0.5, 0)
                Indicator.Size = UDim2.new(0, 18, 0, 18)

                local IndCorner = Instance.new("UICorner")
                IndCorner.CornerRadius = UDim.new(0, 4)
                IndCorner.Parent = Indicator

                local IndStroke = Instance.new("UIStroke")
                IndStroke.Color = Color3.fromRGB(45, 45, 55)
                IndStroke.Thickness = 1
                IndStroke.Parent = Indicator

                local Checkmark = Instance.new("TextLabel")
                Checkmark.Parent = Indicator
                Checkmark.BackgroundTransparency = 1
                Checkmark.Size = UDim2.new(1, 0, 1, 0)
                Checkmark.Font = Enum.Font.GothamBold
                Checkmark.Text = "✓"
                Checkmark.TextColor3 = Color3.fromRGB(12, 12, 15)
                Checkmark.TextSize = 13
                Checkmark.TextTransparency = 1

                local state = false
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    if state then
                        TweenService:Create(Indicator, info, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                        TweenService:Create(IndStroke, info, {Color = Color3.fromRGB(255, 255, 255)}):Play()
                        TweenService:Create(Checkmark, info, {TextTransparency = 0}):Play()
                    else
                        TweenService:Create(Indicator, info, {BackgroundColor3 = Color3.fromRGB(16, 16, 20)}):Play()
                        TweenService:Create(IndStroke, info, {Color = Color3.fromRGB(45, 45, 55)}):Play()
                        TweenService:Create(Checkmark, info, {TextTransparency = 1}):Play()
                    end
                    callback(state)
                end)
            end

            return ColObj
        end

        return TabObj
    end

    -- Логика вылета по Insert
    local menuVisible = false
    local animating = false

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert and not animating then
            animating = true
            menuVisible = not menuVisible
            
            local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            local hideTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

            if menuVisible then
                MainFrame.Visible = true
                MainFrame.Position = UDim2.new(0.5, 0, -0.5, 0)
                local tw = TweenService:Create(MainFrame, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 0)})
                tw:Play()
                tw.Completed:Connect(function() animating = false end)
            else
                local tw = TweenService:Create(MainFrame, hideTweenInfo, {Position = UDim2.new(0.5, 0, -0.5, 0)})
                tw:Play()
                tw.Completed:Connect(function()
                    MainFrame.Visible = false
                    animating = false
                end)
            end
        end
    end)

    function Window:Unload()
        if ScreenGui then ScreenGui:Destroy() end
    end

    return Window
end

return Library
