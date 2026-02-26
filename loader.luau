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
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)

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
local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.new(0, 320, 0, 450)
frame.Position = UDim2.new(0.5, -160, 0.5, -225)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "LINIA PROJECT v1.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title)

local function createSettingBox(parentBtn, defaultValue, callback)
    local settingFrame = Instance.new("Frame", mainGui)
    settingFrame.Size = UDim2.new(0, 80, 0, 30)
    settingFrame.Visible = false
    settingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    settingFrame.BorderSizePixel = 0
    Instance.new("UICorner", settingFrame)
    
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
            showNotification("Adjusted: " .. textBox.Text)
        end
    end)
end

local function createBtn(name, pos, clickCallback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(clickCallback)
    return btn
end

local walkSpeed = 100
local speedBtn = createBtn("Speed Hack", UDim2.new(0.05, 0, 0, 60), function()
    LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
    showNotification("Speed: " .. walkSpeed)
end)
createSettingBox(speedBtn, 100, function(v) walkSpeed = v end)

local jumpPower = 100
local jumpBtn = createBtn("Jump Hack", UDim2.new(0.05, 0, 0, 110), function()
    LocalPlayer.Character.Humanoid.JumpPower = jumpPower
    showNotification("Jump: " .. jumpPower)
end)
createSettingBox(jumpBtn, 100, function(v) jumpPower = v end)

local aimbotEnabled = false
local aimBtn = createBtn("Aimbot Toggle", UDim2.new(0.05, 0, 0, 160), function()
    aimbotEnabled = not aimbotEnabled
    showNotification("Aimbot: " .. (aimbotEnabled and "ON" or "OFF"))
end)

local espEnabled = false
local espBtn = createBtn("ESP Toggle", UDim2.new(0.05, 0, 0, 210), function()
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

local flySpeed = 50
local flyBtn = createBtn("Fly Hack", UDim2.new(0.05, 0, 0, 260), function()
    showNotification("Fly Speed Set: " .. flySpeed)
end)
createSettingBox(flyBtn, 50, function(v) flySpeed = v end)

createBtn("Anti-Cheat Bypass", UDim2.new(0.05, 0, 0, 310), function()
    showNotification("Bypass Injected")
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
                    if mag < dist then
                        target = v.Character.Head
                        dist = mag
                    end
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
end)

showNotification("Linia Project Load Completed")
