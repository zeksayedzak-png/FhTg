-- إنشاء الواجهة الأساسية
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local AllCopyBtn = Instance.new("TextButton")
local UrlInput = Instance.new("TextBox")
local StartBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

-- إعدادات الواجهة
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "SmartExtractor_V2"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- العنوان
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
TitleLabel.Size = UDim2.new(0, 150, 0, 30)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Script Extractor"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- زر النسخ (All Copy)
AllCopyBtn.Name = "AllCopyBtn"
AllCopyBtn.Parent = MainFrame
AllCopyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AllCopyBtn.Position = UDim2.new(0.65, 0, 0.05, 0)
AllCopyBtn.Size = UDim2.new(0, 90, 0, 30)
AllCopyBtn.Font = Enum.Font.SourceSansBold
AllCopyBtn.Text = "All Copy"
AllCopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AllCopyBtn.TextSize = 14
Instance.new("UICorner", AllCopyBtn)

-- خانة الرابط
UrlInput.Name = "UrlInput"
UrlInput.Parent = MainFrame
UrlInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UrlInput.Position = UDim2.new(0.1, 0, 0.3, 0)
UrlInput.Size = UDim2.new(0, 240, 0, 40)
UrlInput.Font = Enum.Font.SourceSans
UrlInput.PlaceholderText = "Paste Script URL (Pastebin, etc)..."
UrlInput.Text = ""
UrlInput.TextColor3 = Color3.fromRGB(255, 255, 255)
UrlInput.TextSize = 14
Instance.new("UICorner", UrlInput)

-- زر البدء (Extract Only)
StartBtn.Name = "StartBtn"
StartBtn.Parent = MainFrame
StartBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 150) -- لون بنفسجي مميز للاستخراج
StartBtn.Position = UDim2.new(0.25, 0, 0.55, 0)
StartBtn.Size = UDim2.new(0, 150, 0, 35)
StartBtn.Font = Enum.Font.SourceSansBold
StartBtn.Text = "Extract Content"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.TextSize = 18
Instance.new("UICorner", StartBtn)

-- نص الحالة
StatusLabel.Name = "Status"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0.05, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0, 270, 0, 30)
StatusLabel.Font = Enum.Font.SourceSansItalic
StatusLabel.Text = "Ready to pull data"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14

-----------------------------------------------------------
-- البرمجة المعدلة (Logic Only)
-----------------------------------------------------------

local extractedData = "" -- لتخزين الكود المسحوب

-- وظيفة النسخ
AllCopyBtn.MouseButton1Click:Connect(function()
    if extractedData ~= "" then
        setclipboard(extractedData)
        StatusLabel.Text = "✅ Data copied to clipboard!"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        StatusLabel.Text = "❌ Nothing to copy yet!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- وظيفة السحب (بدون تشغيل)
StartBtn.MouseButton1Click:Connect(function()
    local url = UrlInput.Text
    
    if url == "" or not string.find(url, "http") then
        StatusLabel.Text = "⚠️ Enter a valid URL first!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        return
    end

    StatusLabel.Text = "⏳ Extracting source data..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- محاولة جلب البيانات
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        extractedData = content -- حفظ البيانات المسحوبة
        StatusLabel.Text = "✅ Done! Click 'All Copy' to use it."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- ملاحظة: تم حذف الـ task.wait والـ loadstring تماماً
    else
        StatusLabel.Text = "❌ Failed to reach URL!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
