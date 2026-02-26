local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function showNotification(text)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LiniaNotify"
    screenGui.Parent = CoreGui

    local island = Instance.new("Frame")
    island.Size = UDim2.new(0, 50, 0, 30)
    island.Position = UDim2.new(0.5, 0, 0, -50)
    island.AnchorPoint = Vector2.new(0.5, 0)
    island.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    island.Parent = screenGui
    Instance.new("UICorner", island).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = island

    island:TweenPosition(UDim2.new(0.5, 0, 0, 25), "Out", "Back", 0.5, true)
    TweenService:Create(island, TweenInfo.new(0.5), {Size = UDim2.new(0, 200, 0, 35)}):Play()
    task.wait(0.3)
    TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

    task.delay(3, function()
        TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.2)
        island:TweenPosition(UDim2.new(0.5, 0, 0, -50), "In", "Back", 0.5, true)
        task.wait(0.6)
        screenGui:Destroy()
    end)
end

local mainGui = Instance.new("ScreenGui")
mainGui.Name = "LiniaMenu"
mainGui.Parent = CoreGui
mainGui.Enabled = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0.5, -160, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = mainGui
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "LINIA PROJECT v1.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Font = Enum.Font.GothamBold
title.Parent = frame
Instance.new("UICorner", title)

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        mainGui.Enabled = not mainGui.Enabled
    end
end)

showNotification("Load Completed")
