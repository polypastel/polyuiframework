--[[
	polypastel
	
	File created 3/7/2020
--]]

-- SERVICES

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")

local Utilities = require(script.Parent.Utilities)
local Data = require(script.Parent.CustomData)

-- VARIABLES

local player = Players.LocalPlayer
local blur = Lighting:WaitForChild("Blur")
local playerGui = player:WaitForChild("PlayerGui")

-- FRAMEWORK

local Framework = script.Parent
local Classes = Framework:WaitForChild("Classes")
local ActiveClasses = {}

-- UI CONTROLLER

local Controller = {}
Controller.__index = Controller

function Controller:Init()
	print("PolyUIFramework Initialized")
	repeat wait() until #playerGui:GetChildren() > 0
	wait(1)
	
	self:InitializeClasses()
end

function Controller:InitializeClasses()
	for _, Class in pairs(Classes:GetChildren()) do
		local class = require(Class)
		local tagged = CollectionService:GetTagged(Class.Name)
		for _, element in pairs(tagged) do
			local extraData = Data[element.Name]
			local newClass = class:Create(element, extraData)
			newClass:Init()
			
			if not ActiveClasses[Class.Name .. "s"] then ActiveClasses[Class.Name .. "s"] = {} end
			local folder = ActiveClasses[Class.Name .. "s"]
			folder[element] = newClass 
		end
	end
end

function Controller:ToggleMenu(menu)
	local foundMenu = ActiveClasses["Menus"][menu]
	if foundMenu then
		foundMenu:Toggle()
	end
end

function Controller:CloseAllMenus()
	for _, v in pairs(ActiveClasses["Menus"]) do
		if v.Transitioning == false then
			if v.Open == true then v:Toggle() end
		else
			spawn(function()
				repeat wait() until v.Transitioning == false
				if v.Open == true then v:Toggle() end
			end)
		end
	end
end

-- GENERAL METHODS

function Controller:Blur(size)
	Utilities:Tween(Lighting.Blur, {Time = 0.15}, {Size = size})
end

function Controller:FadeAllDescendants(parent, transparency, includesParent)
	local toFade = parent:GetDescendants()
	if includesParent then toFade = Utilities:Combine({parent}, toFade) end
	
	local tInfo = {Time = 0.15}
	for _, v in pairs(toFade) do
		if v:IsA("Frame") then
			Utilities:Tween(v, tInfo, {BackgroundTransparency = transparency})
		elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
			Utilities:Tween(v, tInfo, {ImageTransparency = transparency})
		elseif v:IsA("TextLabel") or v:IsA("TextButton") then
			Utilities:Tween(v, tInfo, {TextTransparency = transparency})
		end
	end
end

function Controller:CreateOverlay(display)
	local overlay = Utilities:Create("ImageLabel", {
        Name = "Overlay",
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = display.ZIndex + 1,
        ImageTransparency = 1,
        ImageColor3 = Color3.new(1, 1, 1),
        Image = "rbxassetid://4760129818",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(50, 50, 50, 50),
        SliceScale = display.SliceScale,
        BackgroundTransparency = 1,
        Parent = display
    })

    return overlay
end

return Controller
