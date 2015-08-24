require('DLib')
PrintChat("ImHuman's Auto Level Up Utility Loaded!")
local submenu = menu.addItem(SubMenu.new("Auto Level Up"))
local active = submenu.addItem(MenuBool.new("Active"))
local level = submenu.addItem(MenuSlider.new("Begin at Level :", 2,1,17,1))
local s1 = submenu.addItem(MenuStringList.new("First", {"R", "Q", "W", "E"}))
local s2 = submenu.addItem(MenuStringList.new("Second", {"Q", "W", "E", "R"}))
local s3 = submenu.addItem(MenuStringList.new("Third", {"W", "Q", "E", "R"}))
local s4 = submenu.addItem(MenuStringList.new("Fourth", {"E", "Q", "W", "R"}))

OnLoop(function(myHero)

local up = nil
local up2 = nil
local up3 = nil
local up4 = nil
if active.getValue() == true then
if GetLevel(myHero) >= level.getValue() then
if level.getValue() == 1 or level.getValue() == 2 then
if GetLevel(myHero) == 3 then
if s4.getValue() == 1 then
LevelSpell(_E)
elseif s4.getValue() == 2 then
LevelSpell(_Q)
elseif s4.getValue() == 3 then
LevelSpell(_W)
elseif s4.getValue() == 4 then
LevelSpell(_R)
end
end
end
if s1.getValue() == 1 then
up = LevelSpell(_R)
elseif s1.getValue() == 2 then
up = LevelSpell(_Q)
elseif s1.getValue() == 3 then
up = LevelSpell(_W)
elseif s1.getValue() == 4 then
up = LevelSpell(_E)
end

if s2.getValue() == 1 and up == false then
up2 = LevelSpell(_Q)
elseif s2.getValue() == 2 and up == false then
up2 = LevelSpell(_W)
elseif s2.getValue() == 3 and up == false then
up2 = LevelSpell(_E)
elseif s2.getValue() == 4 and up == false then
up2 = LevelSpell(_R)
end

if s3.getValue() == 1 and up == false and up2 == false then
up3 = LevelSpell(_W)
elseif s3.getValue() == 2 and up == false and up2 == false then
up3 = LevelSpell(_Q)
elseif s3.getValue() == 3 and up == false and up2 == false then
up3 = LevelSpell(_E)
elseif s3.getValue() == 4 and up == false and up2 == false then
up3 = LevelSpell(_R)
end


if s4.getValue() == 1 and up == false and up2 == false and up3 == false then
up4 = LevelSpell(_E)
elseif s4.getValue() == 2 and up == false and up2 == false and up3 == false then
up4 = LevelSpell(_Q)
elseif s4.getValue() == 3 and up == false and up2 == false and up3 == false then
up4 = LevelSpell(_W)
elseif s4.getValue() == 4 and up == false and up2 == false and up3 == false then
up4 = LevelSpell(_R)
end


end
end
end)
