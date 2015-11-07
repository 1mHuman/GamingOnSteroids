if GetObjectName(GetMyHero()) ~= "Akali" then return end

if not pcall( require, "Inspired" ) then PrintChat("You are missing Inspired.lua - Go download it and save it Common!") return end

local AkaliMenu = MenuConfig("Akali", "Akali")
AkaliMenu:Menu("Combo", "Combo")
AkaliMenu.Combo:Boolean("Q", "Use Q", true)
AkaliMenu.Combo:Boolean("E", "Use E", true)
AkaliMenu.Combo:Boolean("R", "Use R", true)
AkaliMenu.Combo:Slider("Rhp", "Use R if Target Health % <", 50, 1, 100, 1)

AkaliMenu:Menu("Harass", "Harass")
AkaliMenu.Harass:Boolean("Q", "Use Q", true)
AkaliMenu.Harass:Boolean("E", "Use E", true)

AkaliMenu:Menu("Killsteal", "Killsteal")
AkaliMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
AkaliMenu.Killsteal:Boolean("E", "Killsteal with E", true)
AkaliMenu.Killsteal:Boolean("R", "Killsteal with R", true)

AkaliMenu:Menu("Lasthit", "Lasthit")
AkaliMenu.Lasthit:Boolean("Q", "Lasthit with Q", false)
AkaliMenu.Lasthit:Boolean("E", "Lasthit with E", false)

AkaliMenu:Menu("Laneclear", "Laneclear")
AkaliMenu.Laneclear:Boolean("Q", "Use Q", false)
AkaliMenu.Laneclear:Boolean("E", "Use E", false)

AkaliMenu:Menu("JungleClear", "JungleClear")
AkaliMenu.JungleClear:Boolean("Q", "Use Q", true)
AkaliMenu.JungleClear:Boolean("E", "Use E", true)

AkaliMenu:Menu("Misc", "Misc")
AkaliMenu.Misc:Boolean("W", "Auto W", true)
AkaliMenu.Misc:Slider("Whp", "Use W if Health % <", 60, 1, 100, 1)
AkaliMenu.Misc:Boolean("Autolvl", "Auto level", true)
AkaliMenu.Misc:DropDown("Autolvltable", "Priority", 1, {"Q-E-W", "Q-W-E"})

AkaliMenu:Menu("Drawings", "Drawings")
AkaliMenu.Drawings:Boolean("Q", "Draw Q Range", true)
AkaliMenu.Drawings:Boolean("W", "Draw W Range", true)
AkaliMenu.Drawings:Boolean("E", "Draw E Range", true)
AkaliMenu.Drawings:Boolean("R", "Draw R Range", true)
AkaliMenu.Drawings:ColorPick("color", "Color Picker", {255,255,255,0})
AkaliMenu.Drawings:Boolean("Dmg", "Draw Combo Dmg", true)

local LudensStacks = 0

OnDraw(function(myHero)
local col = AkaliMenu.Drawings.color:Value()
if AkaliMenu.Drawings.Q:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_Q),1,0,col) end
if AkaliMenu.Drawings.W:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_W),1,0,col) end
if AkaliMenu.Drawings.E:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_E),1,0,col) end
if AkaliMenu.Drawings.R:Value() then DrawCircle(myHeroPos(),GetCastRange(myHero,_R),1,0,col) end
if AkaliMenu.Drawings.Dmg:Value() then
	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
		        local enemyPos = GetOrigin(enemy)
			local drawpos = WorldToScreen(1,enemyPos.x, enemyPos.y, enemyPos.z)
			local enemyText, color = GetDrawText(enemy)
			DrawText(enemyText, 20, drawpos.x, drawpos.y, color)
		end
	end
  end
end)

OnTick(function(myHero)

local target = GetCurrentTarget()
local myHeroPos = myHeroPos()
local mousePos = GetMousePos()

if IOW:Mode() == "Combo" then

	if CanUseSpell(myHero,_Q) == READY and AkaliMenu.Combo.Q:Value() and ValidTarget(target, 600) then
      CastTargetSpell(target, _Q)
	end

	if CanUseSpell(myHero,_E) == READY and AkaliMenu.Combo.E:Value() and ValidTarget(target, 325) then
      CastSpell(_E)
	end

	if CanUseSpell(myHero,_R) == READY and AkaliMenu.Combo.R:Value() and ValidTarget(target, 700) and UnderTower(myHero) == false and 100*GetCurrentHP(target)/GetMaxHP(target) <= AkaliMenu.Combo.Rhp:Value() then
      CastTargetSpell(target, _R)
	end

end

if IOW:Mode() == "Harass"  then

	if CanUseSpell(myHero,_Q) == READY and AkaliMenu.Harass.Q:Value() and ValidTarget(target, 600) then
      CastTargetSpell(target, _Q)
	end

	if CanUseSpell(myHero,_E) == READY and AkaliMenu.Harass.E:Value() and ValidTarget(target, 325) then
      CastSpell(_E)
	end

end


if AkaliMenu.Killsteal.Q:Value() or AkaliMenu.Killsteal.E:Value() or AkaliMenu.Killsteal.R:Value() then
    for _, enemy in pairs(GetEnemyHeroes()) do
	   if AkaliMenu.Killsteal.Q:Value() and CanUseSpell(myHero,_Q) == READY and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero) + Ludens()) and ValidTarget(enemy, 600) then
	CastTargetSpell(enemy, _Q)
    end
		if AkaliMenu.Killsteal.E:Value() and CanUseSpell(myHero,_E) == READY and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) + Ludens()) and ValidTarget(enemy, 325) then
	CastSpell(_E)
    end
		if AkaliMenu.Killsteal.R:Value() and CanUseSpell(myHero,_R) == READY and GetCurrentHP(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 75*GetCastLevel(myHero,_R)+25+.5*GetBonusAP(myHero) + Ludens()) and ValidTarget(enemy, 700) then
	CastTargetSpell(enemy, _R)
    end
  end
end

for i=1, IOW.mobs.maxObjects do
        local minion = IOW.mobs.objects[i]

        if IOW:Mode() == "LaneClear" then
		if CanUseSpell(myHero,_Q) == READY and AkaliMenu.Laneclear.Q:Value() and ValidTarget(minion, 600) then
		CastTargetSpell(minion, _Q)
		end

		if CanUseSpell(myHero,_E) == READY and AkaliMenu.Laneclear.E:Value() and ValidTarget(minion, 325) then
		CastSpell(_E)
		end
	end

	if IOW:Mode() == "LastHit" then

	        if CanUseSpell(myHero,_Q) == READY and AkaliMenu.Lasthit.Q:Value() and ValidTarget(minion, 600) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 5 + 20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero) + Ludens()) then
		CastTargetSpell(minion, _Q)
		elseif CanUseSpell(myHero,_E) == READY and AkaliMenu.Lasthit.E:Value() and ValidTarget(minion, 325) and GetCurrentHP(minion) < CalcDamage(myHero, minion, 0, 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) + Ludens()) then
		CastSpell(_E)
		end
	end

end

for _,mob in pairs(minionManager.objects) do

   if GetTeam(mob) == 300 and IOW:Mode() == "LaneClear" then

		if CanUseSpell(myHero,_Q) == READY and AkaliMenu.JungleClear.Q:Value() and ValidTarget(mob, 600) then
		CastTargetSpell(mob, _Q)
		end

		if CanUseSpell(myHero,_E) == READY and AkaliMenu.JungleClear.E:Value() and ValidTarget(mob, 325) then
		CastSpell(_E)
		end
	end
end

local WPred = GetPredictionForPlayer(GetOrigin(myHero),myHero,GetMoveSpeed(myHero),0,250,700,390,false,true)
	if CanUseSpell(myHero, _W) == READY and WPred.HitChance == 1 and ValidTarget(target, 700) and AkaliMenu.Misc.W:Value() and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) <= AkaliMenu.Misc.Whp:Value()  then
		CastSkillShot(_W,WPred.PredPos)
	end

	objectManager2.maxObjects = 0
    for _, obj in pairs(objectManager2.objects) do
      objectManager2.maxObjects = objectManager2.maxObjects + 1
      local type = GetObjectType(obj)
      if type == Obj_AI_SpawnPoint then
        objectManager2.spawnpoints[_] = obj
      elseif type == Obj_AI_Camp then
        objectManage2r.camps[_] = obj
      elseif type == Obj_AI_Barracks then
        objectManager2.barracks[_] = obj
      elseif type == Obj_AI_Hero then
        objectManager2.heroes[_] = obj
      elseif type == Obj_AI_Minion then
        objectManager2.minions[_] = obj
      elseif type == Obj_AI_Turret then
        objectManager2.turrets[_] = obj
      elseif type == Obj_AI_LineMissle then
        objectManager2.missiles[_] = obj
      elseif type == Obj_AI_Shop then
        objectManager2.shops[_] = obj
      else
        local objName = GetObjectBaseName(obj)
        if objName:lower():find("ward") or objName:lower():find("totem") then
          objectManager2.wards[_] = obj
        else
          objectManager2.unknown[_] = obj
        end
      end
    end


	if AkaliMenu.Misc.Autolvl:Value() then
   if AkaliMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_Q, _E, _W, _Q, _Q , _R, _Q, _E, _Q , _E, _R, _E, _E, _W, _W, _R, _W, _W}
   elseif AkaliMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _W, _Q, _W, _R, _W, _W, _E, _E, _R, _E, _E}
   end
   LevelSpell(leveltable[GetLevel(myHero)])
end
end)

function UnderTower(p1)
local p1 = GetOrigin(p1) or p1
for i,turrent in pairs(objectManager2.turrets) do
if GetTeam(turrent) ~= GetTeam(myHero) and ValidTarget(turrent, 1450) then
local turretPos = GetOrigin(turrent)
if GetDistance(myHero, turrentPos) <= 900 then
	return true
end
end
end
	return false
end


OnUpdateBuff(function(unit,buff)
  if unit == myHero and buff.Name == "itemmagicshankcharge" then
  LudensStacks = buff.Count
  end
end)

OnRemoveBuff(function(unit,buff)
  if unit == myHero and buff.Name == "itemmagicshankcharge" then
  LudensStacks = 0
  end
end)

function Ludens()
    return LudensStacks == 100 and 100+0.1*GetBonusAP(myHero) or 0
end

function GetDrawText(enemy)
	local IgniteDmg = 0
	if Ignite and CanUseSpell(myHero,Ignite) then
	IgniteDmg = IgniteDmg + 20*GetLevel(myHero)+50
	end

	if CanUseSpell(myHero,_Q) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero) + Ludens()) then
		return 'Q = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_Q) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 45*GetCastLevel(myHero,_Q)+35+.9*GetBonusAP(myHero) + Ludens()) then
		return 'Q + AA = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_E) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) + Ludens()) then
		return 'E = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + Ludens())) then
		return 'Q + E = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 45*GetCastLevel(myHero,_Q)+35+.9*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + Ludens())) then
		return 'Q + AA + E = Kill!', ARGB(255, 200, 160, 0)
	elseif IgniteDmg > 0 and CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < IgniteDmg + CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + Ludens())) then
		return 'Q + E + Ign = Kill!', ARGB(255, 200, 160, 0)
	elseif IgniteDmg > 0 and CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < IgniteDmg + CalcDamage(myHero, enemy, 0, 45*GetCastLevel(myHero,_Q)+35+.9*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + Ludens())) then
		return 'Q + AA + E + Ign = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and CanUseSpell(myHero,_R) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + 75*GetCastLevel(myHero,_R)+25+.5*GetBonusAP(myHero) + Ludens())) then
		return 'Q + E + R = Kill!', ARGB(255, 200, 160, 0)
	elseif CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < CalcDamage(myHero, enemy, 0, 45*GetCastLevel(myHero,_Q)+35+.9*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + 75*GetCastLevel(myHero,_R)+25+.5*GetBonusAP(myHero) + Ludens())) then
		return 'Q + AA + E + R = Kill!', ARGB(255, 200, 160, 0)
	elseif IgniteDmg > 0 and CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and CanUseSpell(myHero,_R) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < IgniteDmg + CalcDamage(myHero, enemy, 0, 20*GetCastLevel(myHero,_Q)+15+.4*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + 75*GetCastLevel(myHero,_R)+25+.5*GetBonusAP(myHero) + Ludens())) then
		return 'Q + E + R + Ign = Kill!', ARGB(255, 200, 160, 0)
	elseif IgniteDmg > 0 and CanUseSpell(myHero,_Q) and CanUseSpell(myHero,_E) and CanUseSpell(myHero,_R) and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < IgniteDmg + CalcDamage(myHero, enemy, 0, 45*GetCastLevel(myHero,_Q)+35+.9*GetBonusAP(myHero) + 25*GetCastLevel(myHero,_E)+5+.4*GetBonusAP(myHero)+.6*(GetBonusDmg(myHero)+GetBaseDamage(myHero) + 75*GetCastLevel(myHero,_R)+25+.5*GetBonusAP(myHero) + Ludens())) then
		return 'Q + AA + E + R + Ign = Kill!', ARGB(255, 200, 160, 0)
	else
		return 'Cant Kill Yet', ARGB(255, 200, 160, 0)
	end
end

do
  _G.objectManager2 = {}
  objectManager2.maxObjects = 0
  objectManager2.objects = {}
  objectManager2.spawnpoints = {}
  objectManager2.camps = {}
  objectManager2.barracks = {}
  objectManager2.heroes = {}
  objectManager2.minions = {}
  objectManager2.turrets = {}
  objectManager2.missiles = {}
  objectManager2.shops = {}
  objectManager2.wards = {}
  objectManager2.unknown = {}
  OnObjectLoop(function(object, myHero)
    objectManager2.objects[GetNetworkID(object)] = object
  end)

  DelayAction(function() EmptyObjManager() end, 60000)
end

function EmptyObjManager()
  _G.objectManager2 = {}
  objectManager2.maxObjects = 0
  objectManager2.objects = {}
  objectManager2.spawnpoints = {}
  objectManager2.camps = {}
  objectManager2.barracks = {}
  objectManager2.heroes = {}
  objectManager2.minions = {}
  objectManager2.turrets = {}
  objectManager2.missiles = {}
  objectManager2.shops = {}
  objectManager2.wards = {}
  objectManager2.unknown = {}
  collectgarbage()
  DelayAction(function() EmptyObjManager() end, 60000)
end
