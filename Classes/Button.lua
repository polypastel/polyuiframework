--[[
	polypastel
	
	Button class
--]]

local Controller = require(script.Parent.Parent.Controller)
local Utilities = require(script.Parent.Parent.Utilities)

local CollectionService = game:GetService("CollectionService")
local Debris = game:GetService("Debris")

local Button = {}
Button.__index = Button

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

function Button:Create(element, extraData)
	local newButton = {
		Display = element
	}
	
	if extraData then
		for key, value in pairs(extraData) do
			newButton[key] = value
		end
	end
	
	element.ClipsDescendants = true
	
	setmetatable(newButton, Button)
	return newButton
end

function Button:Toggle()
	local menus = CollectionService:GetTagged("Menu")
	local menu
	for _, v in pairs(menus) do
		if v.Name == self.OnClick[2] then
			menu = v
			break
		end
	end
	
	if menu then
		Controller:ToggleMenu(menu)
	end
end

function Button:ButtonRipple()
	local display = self.Display
    local ripple = Utilities:Create("ImageLabel", {
        Name = "Ripple",
        Size = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3570695787",
        ImageTransparency = 0.75,
        ZIndex = display.ZIndex + 1,
        Parent = display
    })

    local x, y = (mouse.X - ripple.AbsolutePosition.X), (mouse.Y - ripple.AbsolutePosition.Y)
    local size = display.AbsoluteSize.X >= display.AbsoluteSize.Y and (display.AbsoluteSize.X * 2) or (display.AbsoluteSize.Y * 2)
    ripple.Position = UDim2.new(0, x, 0, y)
    
    Utilities:Tween(ripple, {Time = 0.4, EasingStyle = Enum.EasingStyle.Linear}, {Size = UDim2.new(0, size, 0, size), Position = UDim2.new(0.5, (-size / 2), 0.5, (-size / 2))})
    Utilities:Tween(ripple, {Time = 0.35}, {ImageTransparency = 1})
    Debris:AddItem(ripple, 0.4)
end

function Button:Init()
	local animStyle = self.AnimStyle or "Tween"
	local display = self.Display
	
	local originalColor = display.ImageColor3
	local originalXOffset = display.Size.X.Offset
	local originalYOffset = display.Size.Y.Offset
	local offsetAmount = 4
	local overlay
	
	if animStyle == "Tween" then
		overlay = Controller:CreateOverlay(display)
	    display.AutoButtonColor = false
	    display.HoverImage = ""
	end
	
	display.MouseEnter:Connect(function()
		if animStyle == "Tween" then
	        Utilities:Tween(overlay, {Time = 0.075}, {ImageTransparency = 0.95})
	        Utilities:Tween(display, {Time = 0.1}, {Size = UDim2.new(display.Size.X.Scale, originalXOffset + offsetAmount, display.Size.Y.Scale, originalYOffset + offsetAmount)})
   		elseif animStyle == "Darken" then
			local r,g,b
			r = display.ImageColor3.r - 0.216
			g = display.ImageColor3.g - 0.216
			b = display.ImageColor3.b - 0.216
			
			Utilities:Tween(display, {Time = 0.075}, {ImageColor3 = Color3.new(r, g, b)})
		end
	 end)

    display.MouseLeave:Connect(function()
		if animStyle == "Tween" then
	        Utilities:Tween(overlay, {Time = 0.075}, {ImageTransparency = 1})
	        Utilities:Tween(display, {Time = 0.1}, {Size = UDim2.new(display.Size.X.Scale, originalXOffset, display.Size.Y.Scale, originalYOffset)})
		else
			Utilities:Tween(display, {Time = 0.075}, {ImageColor3 = originalColor})
		end
    end)

    display.MouseButton1Click:Connect(function()
		if self.OnClick then
			if self.OnClick[1] == "Toggle" then self:Toggle() elseif self.OnClick[1] == "Close" then Controller:CloseAllMenus() end
		end
		
		if animStyle == "Tween" then
			self:ButtonRipple(display)
			
	        Utilities:TweenSequence({
	            {display, {Time = 0.075}, {Size = UDim2.new(display.Size.X.Scale, originalXOffset, display.Size.Y.Scale, originalYOffset)}},
	            {display, {Time = 0.075}, {Size = UDim2.new(display.Size.X.Scale, originalXOffset + offsetAmount, display.Size.Y.Scale, originalYOffset + offsetAmount)}}
	        })
		elseif animStyle == "Darken" then
			Utilities:Tween(display, {Time = 0.075}, {ImageColor3 = originalColor})
		end
    end)
end

return Button
