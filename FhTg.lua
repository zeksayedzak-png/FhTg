-- =====================================================
-- 📸 STATE CAPTURE AFTER EXECUTION
-- =====================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- واجهة السكريبت
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StateCapture"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 180)
MainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

-- شريط العنوان
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0, 8, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "📸 State Capture"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 3)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

-- حقل الرابط
local UrlInput = Instance.new("TextBox")
UrlInput.Size = UDim2.new(0.9, 0, 0, 30)
UrlInput.Position = UDim2.new(0.05, 0, 0.15, 0)
UrlInput.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
UrlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UrlInput.Font = Enum.Font.Gotham
UrlInput.TextSize = 12
UrlInput.PlaceholderText = "Paste script URL..."
UrlInput.Text = ""
UrlInput.Parent = MainFrame
Instance.new("UICorner", UrlInput).CornerRadius = UDim.new(0, 8)

-- زر التنفيذ
local ExecBtn = Instance.new("TextButton")
ExecBtn.Size = UDim2.new(0.8, 0, 0, 30)
ExecBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
ExecBtn.Text = "⚡ Execute & Capture"
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecBtn.Font = Enum.Font.GothamBold
ExecBtn.TextSize = 13
ExecBtn.Parent = MainFrame
Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 8)

-- زر النسخ
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.8, 0, 0, 30)
CopyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
CopyBtn.Text = "📋 Copy State"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 13
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 18)
StatusLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "🔹 Ready"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 10
StatusLabel.Parent = MainFrame

-- =====================================================
-- السحب
-- =====================================================
local dragData = {dragging = false, startPos = nil, startMouse = nil}

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = true
        dragData.startPos = MainFrame.Position
        dragData.startMouse = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragData.dragging then
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragData.startMouse
            MainFrame.Position = UDim2.new(0, dragData.startPos.X.Offset + delta.X, 0, dragData.startPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragData.dragging = false
    end
end)

-- =====================================================
-- وظيفة التقاط الحالة
-- =====================================================
local function captureState()
    local state = ""
    
    -- 1. التقاط الـ GUIs
    state = state .. "-- GUIs (PlayerGui):\n"
    for _, gui in pairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            state = state .. "-- " .. gui.Name .. " (ScreenGui)\n"
            state = state .. "--   Position: " .. tostring(gui.Position) .. "\n"
            state = state .. "--   Size: " .. tostring(gui.Size) .. "\n"
            -- الأزرار جوا الواجهة
            for _, btn in pairs(gui:GetDescendants()) do
                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                    state = state .. "--   Button: " .. btn.Name .. " (" .. btn.ClassName .. ")\n"
                    if btn:IsA("TextButton") then
                        state = state .. "--     Text: " .. (btn.Text or "None") .. "\n"
                    end
                end
            end
        end
    end
    
    state = state .. "\n-- GUIs (CoreGui):\n"
    for _, gui in pairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            state = state .. "-- " .. gui.Name .. " (ScreenGui)\n"
        end
    end
    
    -- 2. المتغيرات العامة (_G)
    state = state .. "\n-- Global Variables (_G):\n"
    for key, value in pairs(_G) do
        if type(value) ~= "function" and type(value) ~= "table" then
            state = state .. "-- " .. tostring(key) .. " = " .. tostring(value) .. "\n"
        end
    end
    
    -- 3. التغييرات في Workspace (كائنات جديدة)
    state = state .. "\n-- New Objects in Workspace:\n"
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Part") or obj:IsA("Model") or obj:IsA("Folder") then
            state = state .. "-- " .. obj.Name .. " (" .. obj.ClassName .. ")\n"
        end
    end
    
    return state
end

-- =====================================================
-- الأزرار
-- =====================================================
local capturedState = ""

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

ExecBtn.MouseButton1Click:Connect(function()
    local url = UrlInput.Text
    if url == "" then
        StatusLabel.Text = "⚠️ Paste URL first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end

    StatusLabel.Text = "⏳ Fetching..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local success, content = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        StatusLabel.Text = "✅ Executing..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

        local func, err = loadstring(content)
        if func then
            task.spawn(function()
                pcall(func)
                task.wait(1) -- ننتظر عشان السكريبت يشتغل
                capturedState = captureState()
                StatusLabel.Text = "✅ State captured! Ready to copy."
                StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
                print("📸 State captured successfully!")
            end)
        else
            StatusLabel.Text = "❌ Loadstring error: " .. tostring(err):sub(1, 30)
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    else
        StatusLabel.Text = "❌ Failed to fetch!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

CopyBtn.MouseButton1Click:Connect(function()
    if capturedState ~= "" then
        setclipboard(capturedState)
        StatusLabel.Text = "📋 State copied!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        StatusLabel.Text = "❌ No state to copy!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

print("📸 State Capture is ready!")
