local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- Safe UI Parent (Supports gethui() for advanced Android executors or falls back to CoreGui)
local guiParent = nil
if syn and syn.protect_gui then
    guiParent = CoreGui
elseif gethui then
    guiParent = gethui()
else
    guiParent = CoreGui
end

if guiParent:FindFirstChild("CleanHubAndroid") then
    guiParent.CleanHubAndroid:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CleanHubAndroid"
gui.ResetOnSpawn = false
gui.Parent = guiParent

-- Connection tracker for memory leak prevention
local connections = {}
local function trackConnection(conn)
    table.insert(connections, conn)
    return conn
end

-- Safe Drawing check for Android executors
local hasDrawing = (Drawing ~= nil and Drawing.new ~= nil)
local tracerLines = {}

local function cleanupTracers()
    for _, line in pairs(tracerLines) do
        if line and typeof(line.Remove) == "function" then
            pcall(function() line:Remove() end)
        end
    end
    tracerLines = {}
end

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0, 20, 0.4, 0)
Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.Font = Enum.Font.GothamBold
Toggle.Text = "UI"
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
Title.Text = "CleanHub Mobile (Live Target)"
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
ConfirmText.Text = "Close Hub & Clean Up?"
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
    for _, conn in ipairs(connections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    cleanupTracers()
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
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
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
local miscPage = createPage("Misc")

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
createTab("Misc", miscPage)
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

-- ==================== PLAYER FEATURES ====================
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

trackConnection(RunService.Stepped:Connect(function()
    if not noclipEnabled then return end
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
        end
    end
end))

local infJumpEnabled = false
createButtonOnPage(playerPage, "Infinite Jump", function(state) infJumpEnabled = state end)
trackConnection(UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

local godConn = nil
createButtonOnPage(playerPage, "Unlimited Health", function(state)
    if state then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = hum.MaxHealth
            if godConn then godConn:Disconnect() end
            godConn = hum.HealthChanged:Connect(function()
                if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
            end)
            trackConnection(godConn)
        end
    else
        if godConn then godConn:Disconnect() godConn = nil end
    end
end)

local hazardShieldEnabled = false
createButtonOnPage(playerPage, "No-Touch Hazard Shield", function(state)
    hazardShieldEnabled = state
end)

trackConnection(RunService.Stepped:Connect(function()
    if not hazardShieldEnabled then return end
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanTouch = false
        end
    end
end))

local antiVoidEnabled = false
createButtonOnPage(playerPage, "Anti-Void Protection", function(state)
    antiVoidEnabled = state
end)

local lastSafePos = CFrame.new(0, 10, 0)
trackConnection(RunService.Heartbeat:Connect(function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    
    if root and hum and hum.Health > 0 then
        if root.Position.Y > -20 and math.abs(root.AssemblyLinearVelocity.Y) < 50 then
            lastSafePos = root.CFrame
        end

        if antiVoidEnabled and root.Position.Y < -50 then
            root.CFrame = lastSafePos + Vector3.new(0, 5, 0)
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
end))

-- ==================== ADVANCED LIVE TARGET FEATURES ====================
local selectedTarget = nil

local function createLiveTargetMenu(page)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 290, 0, 140)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = page
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0, 0, 26)
    header.BackgroundTransparency = 1
    header.Font = Enum.Font.GothamBold
    header.Text = "Live Target Selection: [None]"
    header.TextColor3 = Color3.fromRGB(255, 140, 0)
    header.TextSize = 12
    header.Parent = mainFrame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -8, 1, -32)
    scroll.Position = UDim2.new(0, 4, 0, 28)
    scroll.BackgroundTransparency = 1
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.Parent = scroll

    local function refreshPlayerList()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, op in ipairs(Players:GetPlayers()) do
            if op ~= player then
                local pBtn = Instance.new("TextButton")
                pBtn.Size = UDim2.new(1, -4, 0, 28)
                pBtn.BackgroundColor3 = (selectedTarget == op) and Color3.fromRGB(0, 170, 127) or Color3.fromRGB(45, 45, 45)
                pBtn.Font = Enum.Font.GothamMedium
                pBtn.Text = op.Name .. " (" .. op.DisplayName .. ")"
                pBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                pBtn.TextSize = 11
                pBtn.Parent = scroll
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)

                pBtn.MouseButton1Click:Connect(function()
                    selectedTarget = op
                    header.Text = "Live Target: " .. op.Name
                    refreshPlayerList()
                end)
            end
        end
    end

    refreshPlayerList()
    trackConnection(Players.PlayerAdded:Connect(refreshPlayerList))
    trackConnection(Players.PlayerRemoving:Connect(refreshPlayerList))
end

createLiveTargetMenu(targetPage)

createActionBtn(targetPage, "TP Behind Target", function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

-- Spectate Target Toggle
local spectating = false
createButtonOnPage(targetPage, "Spectate Target", function(state)
    spectating = state
end)

trackConnection(RunService.RenderStepped:Connect(function()
    local cam = Workspace.CurrentCamera
    if spectating and selectedTarget and selectedTarget.Character then
        local targetHum = selectedTarget.Character:FindFirstChildOfClass("Humanoid")
        if targetHum then
            cam.CameraSubject = targetHum
        end
    else
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and cam.CameraSubject ~= hum then
                cam.CameraSubject = hum
            end
        end
    end
end))

-- Hug Target Toggle
local hugging = false
createButtonOnPage(targetPage, "Hug Target", function(state)
    hugging = state
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hugging and hum then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://5918726674" -- Hug / Emote pose
        local track = hum:LoadAnimation(anim)
        track:Play()
    end
end)

trackConnection(RunService.Heartbeat:Connect(function()
    if hugging and selectedTarget and selectedTarget.Character then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if root and targetRoot then
            root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -1.2) -- Stay right in front (hug position)
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
end))

-- Sit on Target Toggle
local sittingOnTarget = false
createButtonOnPage(targetPage, "Sit On Target", function(state)
    sittingOnTarget = state
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if sittingOnTarget then
            hum:ChangeState(Enum.HumanoidStateType.Seated)
        else
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end)

trackConnection(RunService.Heartbeat:Connect(function()
    if sittingOnTarget and selectedTarget and selectedTarget.Character then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local targetHead = selectedTarget.Character:FindFirstChild("Head") or selectedTarget.Character:FindFirstChild("HumanoidRootPart")
        if root and targetHead then
            root.CFrame = targetHead.CFrame + Vector3.new(0, 2.2, 0) -- Hover right on top of their head
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
end))

-- ==================== TP FEATURES ====================
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

-- ==================== VISUAL FEATURES ====================
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

local espEnabled = false
local espActiveConnections = {}

local function updateESPForPlayer(op)
    if op == player then return end
    local function setupCharacter(char)
        if not espEnabled then return end
        if not char:FindFirstChild("HubHighlight") then
            local h = Instance.new("Highlight")
            h.Name = "HubHighlight"
            h.Adornee = char
            h.FillColor = Color3.fromRGB(0, 170, 127)
            h.Parent = char
        end
    end
    if op.Character then setupCharacter(op.Character) end
    local conn = op.CharacterAdded:Connect(setupCharacter)
    table.insert(espActiveConnections, conn)
    trackConnection(conn)
end

createButtonOnPage(visualPage, "Player ESP", function(state)
    espEnabled = state
    if espEnabled then
        for _, op in ipairs(Players:GetPlayers()) do updateESPForPlayer(op) end
        local playerAddedConn = Players.PlayerAdded:Connect(updateESPForPlayer)
        table.insert(espActiveConnections, playerAddedConn)
        trackConnection(playerAddedConn)
    else
        for _, conn in ipairs(espActiveConnections) do
            if conn.Connected then conn:Disconnect() end
        end
        espActiveConnections = {}
        for _, op in ipairs(Players:GetPlayers()) do
            if op.Character then
                local hl = op.Character:FindFirstChild("HubHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end)

local tracersEnabled = false
createButtonOnPage(visualPage, "Player Tracers", function(state)
    if not hasDrawing then
        warn("CleanHub: Tracers are disabled because your executor lacks the Drawing library.")
        return
    end
    tracersEnabled = state
    if not tracersEnabled then cleanupTracers() end
end)

trackConnection(RunService.RenderStepped:Connect(function()
    if not tracersEnabled or not hasDrawing then return end
    local cam = Workspace.CurrentCamera
    local viewportSize = cam.ViewportSize
    
    for _, op in ipairs(Players:GetPlayers()) do
        if op ~= player and op.Character then
            local root = op.Character:FindFirstChild("HumanoidRootPart")
            local hum = op.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local pos, onScreen = cam:WorldToViewportPoint(root.Position)
                local line = tracerLines[op]
                if not line then
                    pcall(function()
                        line = Drawing.new("Line")
                        line.Thickness = 1.5
                        line.Color = Color3.fromRGB(0, 170, 127)
                        line.Transparency = 0.7
                        tracerLines[op] = line
                    end)
                end
                if line then
                    if onScreen then
                        line.Visible = true
                        line.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                        line.To = Vector2.new(pos.X, pos.Y)
                    else
                        line.Visible = false
                    end
                end
            else
                if tracerLines[op] then tracerLines[op].Visible = false end
            end
        else
            if tracerLines[op] then tracerLines[op].Visible = false end
        end
    end
end))

local fogRemoved = false
createButtonOnPage(visualPage, "Remove Fog", function(state)
    fogRemoved = state
    if fogRemoved then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("Atmosphere") then child.Parent = nil end
        end
    else
        Lighting.FogEnd = 1000
        Lighting.FogStart = 0
    end
end)

-- ==================== MISC FEATURES ====================
createActionBtn(miscPage, "Rejoin Server", function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end)
end)

createActionBtn(miscPage, "Server Hop", function()
    pcall(function()
        local servers = {}
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/public?sortOrder=Asc&limit=100"
        local success, response = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success and response then
            local decoded = HttpService:JSONDecode(response)
            if decoded and decoded.data then
                for _, server in ipairs(decoded.data) do
                    if type(server) == "table" and server.maxPlayers and server.playing and server.id then
                        if server.playing < server.maxPlayers and server.id ~= game.JobId then
                            table.insert(servers, server.id)
                        end
                    end
                end
            end
        end
        
        if #servers > 0 then
            local targetServerId = servers[math.random(1, #servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServerId, player)
        else
            warn("CleanHub: Could not find an alternative server to hop into.")
        end
    end)
end)

createButtonOnPage(miscPage, "FPS Booster", function(state)
    Lighting.GlobalShadows = not state
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then v.Enabled = not state end
    end
    Workspace.Terrain.WaterWaveSize = state and 0 or 0.1
    Workspace.Terrain.WaterWaveTransparency = state and 1 or 0.3
    Workspace.Terrain.WaterReflectance = state and 0 or 1
end)

createButtonOnPage(miscPage, "Potato Graphics", function(state)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if state then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
            end
        elseif obj:IsA("Texture") or obj:IsA("Decal") then
            obj.Transparency = state and 1 or 0
        end
    end
end)

-- ==================== FLY RENDER LOOP ====================
trackConnection(RunService.RenderStepped:Connect(function()
    if flying and bv and bg then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum and root then
                local cam = Workspace.CurrentCamera
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
end))
