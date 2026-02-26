local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function showNotification(text)
    local screenGui = Instance.new("ScreenGui", CoreGui)
    local island = Instance.new("Frame", screenGui)
    island.Size = UDim2.new(0, 50, 0, 30)
    island.Position = UDim2.new(0.5, 0, 0, -50)
    island.AnchorPoint = Vector2.new(0.5, 0)
    island.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    local corner = Instance.new("UICorner", island)
    corner.CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel", island)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14

    island:TweenPosition(UDim2.new(0.5, 0, 0, 25), "Out", "Back", 0.5, true)
    TweenService:Create(island, TweenInfo.new(0.5), {Size = UDim2.new(0, 220, 0, 35)}):Play()
    
    task.delay(3, function()
        island:TweenPosition(UDim2.new(0.5, 0, 0, -50), "In", "Back", 0.5, true)
        task.wait(0.6)
        screenGui:Destroy()
    end)
end

local mainGui = Instance.new("ScreenGui", CoreGui)
mainGui.Enabled = false
mainGui.Name = "Linia_GUI"

local mainFrame = Instance.new("Frame", mainGui)
mainFrame.Size = UDim2.new(0, 300, 0, 420)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
local frameCorner = Instance.new("UICorner", mainFrame)
frameCorner.CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Text = "LINIA PROJECT v1.0"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.BackgroundTransparency = 1
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 16

local function createBtn(name, pos, callback)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.AutoButtonColor = true
    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createSettingBox(parentBtn, defaultValue, callback)
    local settingFrame = Instance.new("Frame", mainGui)
    settingFrame.Size = UDim2.new(0, 80, 0, 30)
    settingFrame.Visible = false
    settingFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local settingCorner = Instance.new("UICorner", settingFrame)
    settingCorner.CornerRadius = UDim.new(0, 6)
    
    local textBox = Instance.new("TextBox", settingFrame)
    textBox.Size = UDim2.new(1, 0, 1, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = tostring(defaultValue)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.ClearTextOnFocus = true
    
    parentBtn.MouseButton2Click:Connect(function()
        settingFrame.Position = UDim2.new(0, Mouse.X + 5, 0, Mouse.Y - 15)
        settingFrame.Visible = not settingFrame.Visible
    end)
    
    textBox.FocusLost:Connect(function(enter)
        if enter then
            callback(tonumber(textBox.Text) or defaultValue)
            settingFrame.Visible = false
            showNotification("Value: " .. textBox.Text)
        end
    end)
end

local walkSpeed = 100
local sBtn = createBtn("Speed Hack", UDim2.new(0.05, 0, 0, 60), function()
    LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    showNotification("Speed: " .. walkSpeed)
end)
createSettingBox(sBtn, 100, function(v) walkSpeed = v end)

local jumpPower = 100
local jBtn = createBtn("Jump Hack", UDim2.new(0.05, 0, 0, 110), function()
    LocalPlayer.Character.Humanoid.JumpPower = jumpPower
    showNotification("Jump: " .. jumpPower)
end)
createSettingBox(jBtn, 100, function(v) jumpPower = v end)

local espEnabled = false
createBtn("Toggle ESP", UDim2.new(0.05, 0, 0, 160), function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "LiniaESP"
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("LiniaESP") then
                p.Character.LiniaESP:Destroy()
            end
        end
    end
    showNotification("ESP: " .. (espEnabled and "ON" or "OFF"))
end)

local aimbotEnabled = false
createBtn("Toggle Aimbot", UDim2.new(0.05, 0, 0, 210), function()
    aimbotEnabled = not aimbotEnabled
    showNotification("Aimbot: " .. (aimbotEnabled and "ON" or "OFF"))
end)

createBtn("Anti-Cheat Bypass", UDim2.new(0.05, 0, 0, 260), function()
    showNotification("Bypass Applied")
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        mainGui.Enabled = not mainGui.Enabled
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = nil
        local dist = 1000
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mag < dist then target = v.Character.Head dist = mag end
                end
            end
        end
        if target then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position) end
    end
end)

showNotification("Linia Project Load Completed")
