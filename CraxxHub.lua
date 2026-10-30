local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

if CoreGui:FindFirstChild("CleanHubAndroid") then
    CoreGui.CleanHubAndroid:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CleanHubAndroid"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 20, 0.4, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.GothamBold
Toggle.Text = "Craxx"
Toggle.TextSize = 16
Toggle.Active = true
Toggle.Draggable = true
Toggle.Parent = gui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

local Window = Instance.new("Frame")
Window.Size = UDim2.new(0, 440, 0, 300)
Window.Position = UDim2.new(0.5, -220, 0.5, -150)
Window.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Window.Parent = gui
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 140, 0)
Stroke.Thickness = 2
Stroke.Parent = Window

Toggle.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, 36)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "CleanHub Mobile"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Window

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Position = UDim2.new(1, -28, 0, 6)
Close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
Close.Font = Enum.Font.GothamBold
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 12
Close.Parent = Window
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 4)

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 24, 0, 24)
Minimize.Position = UDim2.new(1, -56, 0, 6)
Minimize.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
Minimize.Font = Enum.Font.GothamBold
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
Minimize.TextSize = 14
Minimize.Parent = Window
Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 4)

local isMinimized = false
Minimize.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    for _, child in ipairs(Window:GetChildren()) do
        if child ~= Close and child ~= Minimize and child ~= Title and child ~= Stroke and child.ClassName ~= "UICorner" and child.Name ~= "ConfirmOverlay" then
            if child:IsA("GuiObject") then
                child.Visible = not isMinimized
            end
        end
    end
    if isMinimized then
        Window.Size = UDim2.new(0, 440, 0, 36)
    else
        Window.Size = UDim2.new(0, 440, 0, 300)
    end
end)

local ConfirmOverlay = Instance.new("Frame")
ConfirmOverlay.Name = "ConfirmOverlay"
ConfirmOverlay.Size = UDim2.new(1, 0, 1, 0)
ConfirmOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ConfirmOverlay.BackgroundTransparency = 0.1
ConfirmOverlay.Visible = false
ConfirmOverlay.ZIndex = 10
ConfirmOverlay.Parent = Window
Instance.new("UICorner", ConfirmOverlay).CornerRadius = UDim.new(0, 8)

local ConfirmText = Instance.new("TextLabel")
ConfirmText.Size = UDim2.new(1, 0, 0, 40)
ConfirmText.Position = UDim2.new(0, 0, 0.3, 0)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Font = Enum.Font.GothamBold
ConfirmText.Text = "Close Hub?"
ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfirmText.TextSize = 14
ConfirmText.ZIndex = 11
ConfirmText.Parent = ConfirmOverlay

local YesBtn = Instance.new("TextButton")
YesBtn.Size = UDim2.new(0, 90, 0, 30)
YesBtn.Position = UDim2.new(0.5, -96, 0.6, 0)
YesBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
YesBtn.Font = Enum.Font.GothamBold
YesBtn.Text = "Confirm"
YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
YesBtn.TextSize = 12
YesBtn.ZIndex = 11
YesBtn.Parent = ConfirmOverlay
Instance.new("UICorner", YesBtn).CornerRadius = UDim.new(0, 6)

local NoBtn = Instance.new("TextButton")
NoBtn.Size = UDim2.new(0, 90, 0, 30)
NoBtn.Position = UDim2.new(0.5, 6, 0.6, 0)
NoBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoBtn.Font = Enum.Font.GothamBold
NoBtn.Text = "Cancel"
NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoBtn.TextSize = 12
NoBtn.ZIndex = 11
NoBtn.Parent = ConfirmOverlay
Instance.new("UICorner", NoBtn).CornerRadius = UDim.new(0, 6)

Close.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = true
end)

NoBtn.MouseButton1Click:Connect(function()
    ConfirmOverlay.Visible = false
end)

YesBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 110, 1, -48)
Sidebar.Position = UDim2.new(0, 6, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 2
Sidebar.Parent = Window
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
SidebarLayout.Parent = Sidebar

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -126, 1, -48)
Container.Position = UDim2.new(0, 122, 0, 42)
Container.BackgroundTransparency = 1
Container.Parent = Window

local pages = {}
local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 550)
    page.ScrollBarThickness = 4
    page.Parent = Container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = page

    pages[name] = page
    return page
end

local playerPage = createPage("Player")
local targetPage = createPage("Target")
local tpPage = createPage("TP")
local visualPage = createPage("Visual")

local function createTab(name, targetPageObj)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 98, 0, 32)
    tabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabBtn.TextSize = 13
    tabBtn.Parent = Sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        targetPageObj.Visible = true
    end)
end

createTab("Player", playerPage)
createTab("Target", targetPage)
createTab("TP", tpPage)
createTab("Visual", visualPage)
playerPage.Visible = true

local function createButtonOnPage(page, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 290, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = name .. ": [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Text = name .. ": [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Text = name .. ": [OFF]"
        end
        callback(toggled)
    end)
end

local function createActionBtn(page, txt, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 290, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    b.Font = Enum.Font.GothamMedium
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 13
    b.Parent = page
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

local function createSliderOnPage(page, title, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 290, 0, 46)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = page
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 18)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.Text = title .. ": " .. default
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.Parent = frame

    local bar = Instance.new("TextButton")
    bar.Size = UDim2.new(0, 260, 0, 10)
    bar.Position = UDim2.new(0.5, -130, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    bar.Text = ""
    bar.AutoButtonColor = false
    bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
    fill.BorderSizePixel = 0
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local sliderBtn = Instance.new("Frame")
    sliderBtn.Size = UDim2.new(0, 16, 0, 16)
    sliderBtn.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderBtn.Parent = bar
    Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

    local dragging = false

    local function updateSlider(input)
        local p = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(p, 0, 1, 0)
        sliderBtn.Position = UDim2.new(p, -8, 0.5, -8)
        local val = math.floor(min + (max - min) * p)
        label.Text = title .. ": " .. val
        callback(val)
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(i)
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(i)
        end
    end)
end

local flying = false
local flySpeed = 50
local bv, bg = nil, nil

createButtonOnPage(playerPage, "Fly", function(state)
    flying = state
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    if flying then
        hum.PlatformStand = true
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.zero
        bv.Parent = root

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = root.CFrame
        bg.Parent = root
    else
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        hum.PlatformStand = false
    end
end)

createSliderOnPage(playerPage, "Fly Speed", 10, 500, 50, function(val)
    flySpeed = val
end)

createSliderOnPage(playerPage, "WalkSpeed", 16, 300, 16, function(val)
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = val end
end)

local noclipEnabled = false
createButtonOnPage(playerPage, "Noclip", function(state)
    noclipEnabled = state
end)

RunService.Stepped:Connect(function()
    if noclipEnabled then
        local char = player.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local infJumpEnabled = false
createButtonOnPage(playerPage, "Infinite Jump", function(state) infJumpEnabled = state end)
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local godConn = nil
createButtonOnPage(playerPage, "Unlimited Health", function(state)
    if state then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            godConn = hum.HealthChanged:Connect(function()
                if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
            end)
        end
    else
        if godConn then godConn:Disconnect() end
    end
end)

local hazardShieldEnabled = false
createButtonOnPage(playerPage, "No-Touch Hazard Shield", function(state)
    hazardShieldEnabled = state
end)

RunService.Stepped:Connect(function()
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanTouch = not hazardShieldEnabled
            end
        end
    end
end)

local antiVoidEnabled = false
createButtonOnPage(playerPage, "Anti-Void Protection", function(state)
    antiVoidEnabled = state
end)

local lastSafePos = CFrame.new(0, 10, 0)
RunService.Heartbeat:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and root.Position.Y > -30 then
        lastSafePos = root.CFrame
    end

    if antiVoidEnabled then
        if root and root.Position.Y < -50 then
            root.CFrame = lastSafePos
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
end)

local savedPos = nil
local smoothSpeed = 50

createActionBtn(tpPage, "Save Position", function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then savedPos = root.CFrame end
end)

createActionBtn(tpPage, "Instant TP to Waypoint", function()
    if savedPos then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = savedPos end
    end
end)

createSliderOnPage(tpPage, "Smooth TP Speed", 10, 500, 50, function(val)
    smoothSpeed = val
end)

createActionBtn(tpPage, "Smooth TP to Waypoint", function()
    if savedPos then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            local dist = (root.Position - savedPos.Position).Magnitude
            TweenService:Create(root, TweenInfo.new(dist / smoothSpeed, Enum.EasingStyle.Linear), {CFrame = savedPos}):Play()
        end
    end
end)

createButtonOnPage(visualPage, "Fullbright", function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

createButtonOnPage(visualPage, "Player ESP", function(state)
    local espOn = state
    for _, op in ipairs(Players:GetPlayers()) do
        if op ~= player and op.Character then
            local hl = op.Character:FindFirstChild("HubHighlight")
            if espOn and not hl then
                local h = Instance.new("Highlight")
                h.Name = "HubHighlight"
                h.Adornee = op.Character
                h.FillColor = Color3.fromRGB(0, 170, 127)
                h.Parent = op.Character
            elseif not espOn and hl then
                hl:Destroy()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bv and bg then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum and root then
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.zero
                if hum.MoveDirection.Magnitude > 0 then
                    local localDir = cam.CFrame:VectorToObjectSpace(hum.MoveDirection)
                    moveDir = (cam.CFrame.RightVector * localDir.X) + (cam.CFrame.LookVector * (-localDir.Z))
                end
                bv.Velocity = moveDir * flySpeed
                bg.CFrame = cam.CFrame
            end
        end
    end
end)
