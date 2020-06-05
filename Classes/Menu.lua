--[[
	polypastel
	
	Menu class
--]]

local Controller = require(script.Parent.Parent.Controller)
local Utilities = require(script.Parent.Parent.Utilities)

local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")

local MenuActions = script.Parent.Parent.CustomData.Menus

local Menu = {}
Menu.__index = Menu

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

function Menu:Create(element, extraData)
	local newMenu = {
		Display = element,
		Transitioning = false,
		Open = false
	}
	
	if extraData then
		for key, value in pairs(extraData) do
			newMenu[key] = value
		end
	end
	
	setmetatable(newMenu, Menu)
	return newMenu
end

function Menu:Toggle()
	if self.Transitioning == false then
		self.Transitioning = true
		
		local menuAction
		if MenuActions:FindFirstChild(self.Display.Name) then
			menuAction = require(MenuActions:FindFirstChild(self.Display.Name))
		end
		
		if self.Open == false then
			Controller:Blur(12)
			
			local SlideFrame = Utilities:Create("Frame", {
				Name = self.Display.Name .. "Transition",
				Size = UDim2.new(0, self.Display.AbsoluteSize.X, 0, self.Display.AbsoluteSize.Y),
				BackgroundTransparency = 1,
				AnchorPoint = self.Display.AnchorPoint,
				Position = self.Display.Position,
				ClipsDescendants = true,
				Parent = self.Display.Parent
			})
				
			local originalSize, originalAnchor, originalPos = self.Display.Size, self.Display.AnchorPoint, self.Display.Position
			
			self.Display.Parent = SlideFrame
			self.Display.AnchorPoint = Vector2.new(0.5, 0)
			self.Display.Position = UDim2.new(0.5, 0, 1, 0)
			self.Display.Size = UDim2.new(1, 0, 1, 0)
			self.Display.Visible = true
			
			Utilities:Tween(self.Display, {Time = 0.25, EasingDirection = Enum.EasingDirection.Out, EasingStyle = Enum.EasingStyle.Cubic}, {AnchorPoint = originalAnchor, Position = originalPos})
			
			if menuAction then menuAction:OnOpen(self) end
			delay(0.25, function()
				self.Display.Size = originalSize
				self.Display.Parent = SlideFrame.Parent
				
				SlideFrame:Destroy()
				
				self.Transitioning = false
				self.Open = true
			end)
		else
			local tweenClone = self.Display:Clone()
			tweenClone.Parent = self.Display.Parent
			
			self.Display.Visible = false
			
			Controller:Blur(0)
			Controller:FadeAllDescendants(tweenClone, 1, true)
			
			if menuAction then menuAction:OnClose(self) end
			delay(0.15, function()
				self.Transitioning = false
				self.Open = false
				
				tweenClone:Destroy()
			end)
		end
	end
end

function Menu:Init()
	
end

return Menu
