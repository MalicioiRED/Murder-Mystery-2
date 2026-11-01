
--[[
    LEOHUB - Trade Security Auditor
    Client-side interface
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local GUI = Instance.new("ScreenGui")
GUI.Name = "LEOHUB"
GUI.ResetOnSpawn = false
GUI.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(340, 410)
Main.Position = UDim2.new(0.5, -170, 0.5, -205)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 48)
Title.BackgroundColor3 = Color3.fromRGB(105, 65, 210)
Title.Text = "LEOHUB | TRADE SECURITY"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.Parent = Main

local function createButton(name, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 36)
    button.Position = UDim2.fromOffset(12, position)
    button.BackgroundColor3 = Color3.fromRGB(45, 43, 58)
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 12
    button.Text = name
    button.Parent = Main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

local Log = Instance.new("TextLabel")
Log.Size = UDim2.new(1, -24, 0, 145)
Log.Position = UDim2.fromOffset(12, 250)
Log.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Log.TextColor3 = Color3.fromRGB(120, 255, 170)
Log.Font = Enum.Font.Code
Log.TextSize = 11
Log.TextXAlignment = Enum.TextXAlignment.Left
Log.TextYAlignment = Enum.TextYAlignment.Top
Log.TextWrapped = true
Log.Text = "LEOHUB initialized.\nWaiting for audit..."
Log.Parent = Main

local function writeLog(message)
    Log.Text = Log.Text .. "\n" .. message
end

createButton("SCAN PLAYERS", 65, function()
    local count = #Players:GetPlayers()
    writeLog("Players detected: " .. count)

    for _, player in ipairs(Players:GetPlayers()) do
        writeLog("Player: " .. player.Name)
    end
end)


createButton("SCAN TRADE REMOTES", 110, function()
    writeLog("Starting recursive RemoteEvent scan...")

    local found = 0

    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            found += 1
            writeLog("[REMOTE EVENT] " .. obj:GetFullName())

        elseif obj:IsA("RemoteFunction") then
            found += 1
            writeLog("[REMOTE FUNCTION] " .. obj:GetFullName())
        end
    end

    writeLog("Scan completed.")
    writeLog("Total remotes found: " .. found)
end)


createButton("SCAN MY INVENTORY", 155, function()
    local inventory = LocalPlayer:FindFirstChild("Inventory")

    if not inventory then
        writeLog("Inventory not visible.")
        return
    end

    local count = 0

    for _, item in ipairs(inventory:GetDescendants()) do
        if item:IsA("Tool") or item:IsA("StringValue") then
            count += 1
            writeLog("Item: " .. item.Name)
        end
    end

    writeLog("Visible items: " .. count)
end)

createButton("CLEAR LOGS", 200, function()
    Log.Text = "Logs cleared."
end)

createButton("CLOSE LEOHUB", 365, function()
    GUI:Destroy()
end)

writeLog("User: " .. LocalPlayer.Name)
writeLog("Audit interface ready.")
