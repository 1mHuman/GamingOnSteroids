if GetObjectName(myHero) ~= "Vi" then return end

ViMenu = Menu("Vi", "Vi")
ViMenu:SubMenu("Combo", "Combo")
ViMenu.Combo:Boolean("Q", "Use Q", true)
ViMenu.Combo:Boolean("E", "Use E", true)
ViMenu.Combo:Boolean("R", "Use R", true)
ViMenu.Combo:Slider("Rhp", "Use if Target Health % <", 30, 1, 100, 1)

ViMenu:SubMenu("Harass", "Harass")
ViMenu.Harass:Boolean("Q", "Use Q", true)
ViMenu.Harass:Boolean("E", "Use E", true)

ViMenu:SubMenu("JungleSteal", "Jungle Steal")
ViMenu.JungleSteal:Boolean("Baron", "Auto smite Baron", true)
ViMenu.JungleSteal:Boolean("Dragon", "Auto smite Dragon", true)

ViMenu:SubMenu("Misc", "Misc")
ViMenu.Misc:Boolean("Interrupt", "Interrupt with Q", true)

ViMenu:SubMenu("Drawings", "Drawings")
ViMenu.Drawings:Boolean("R", "Draw R Range", true)

ViMenu:Info("info0", " ")
ViMenu:Info("info1", "Vi the Heartbreaker")
ViMenu:Info("info2", "By ImHuman - v1.0")

CHANELLING_SPELLS = {
    ["Caitlyn"]                     = {_R},
    ["Katarina"]                    = {_R},
    ["FiddleSticks"]                = {_R},
    ["Galio"]                       = {_R},
    ["Lucian"]                      = {_R},
    ["MissFortune"]                 = {_R},
    ["VelKoz"]                      = {_R},
    ["Nunu"]                        = {_R},
    ["Karthus"]                     = {_R},
    ["Malzahar"]                    = {_R},
    ["Xerath"]                      = {_R},
}


local callback = nil

OnProcessSpell(function(unit, spell)
        if not callback or not unit or GetObjectType(unit) ~= Obj_AI_Hero  or GetTeam(unit) == GetTeam(GetMyHero()) then return end
        local unitChanellingSpells = CHANELLING_SPELLS[GetObjectName(unit)]

        if unitChanellingSpells then
            for _, spellSlot in pairs(unitChanellingSpells) do
                if spell.name == GetCastName(unit, spellSlot) then callback(unit, CHANELLING_SPELLS) end
            end
	end
end)

function addInterrupterCallback( callback0 )
callback = callback0
end

OnLoop(function(myHero)

if IOW:Mode() == "Combo" then

local target = GetCurrentTarget()
local myHeroPos = GoS:myHeroPos()


if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, 800) and ViMenu.Combo.Q:Value() then
      CastSkillShot(_Q, myHeroPos.x, myHeroPos.y, myHeroPos.z)
      for i=250, 750, 125 do
        GoS:DelayAction(function()
              local _Qrange = 250 + math.min(250, i/2)
              local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),math.huge,600,_Qrange,100,false,true)
              if QPred.HitChance == 1 then
                CastSkillShot2(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
              end
          end, i)
      end
    end


if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 175) and ViMenu.Combo.E:Value() then
    CastSpell(_E)
    end


if ViMenu.Combo.R:Value() then
    for _, enemy in pairs(Gos:GetEnemyHeroes()) do
	   if CanUseSpell(myHero,_R) == READY and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) <= ViMenu.Combo.Rhp:Value() and GoS:ValidTarget(target, 800) then
	CastTargetSpell(target, _R)
    end
  end
end

end

if IOW:Mode() == "Harass"  then

local target = GetCurrentTarget()
local myHeroPos = GoS:myHeroPos()

if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, 800) and ViMenu.Harass.Q:Value() then
      CastSkillShot(_Q, myHeroPos.x, myHeroPos.y, myHeroPos.z)
      for i=250, 750, 125 do
        GoS:DelayAction(function()
              local _Qrange = 250 + math.min(250, i/2)
              local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),math.huge,600,_Qrange,100,false,true)
              if QPred.HitChance == 1 then
                CastSkillShot2(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
              end
          end, i)
      end
    end


if CanUseSpell(myHero,_E) == READY and GoS:ValidTarget(target, 175) and ViMenu.Harass.E:Value() then
    CastSpell(_E)
    end


end

local smitetable = {390, 410, 430, 450, 480, 510, 540, 570, 600, 640, 680, 720, 760, 800, 850, 900, 950, 1000}
local smitedamage = smitetable[GetLevel(myHero)]

for _,mob in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do
    if GoS:IsInDistance(mob, 500) then
	  if CanUseSpell(myHero, Smite) == READY and ViMenu.JungleSteal.Baron:Value() and GetObjectName(mob) == "SRU_Baron" and GetCurrentHP(mob) < smitedamage then
	  CastTargetSpell(mob, Smite)
	  elseif CanUseSpell(myHero, Smite) == READY and ViMenu.JungleSteal.Dragon:Value() and GetObjectName(mob) == "SRU_Dragon" and GetCurrentHP(mob) < smitedamage then
	  CastTargetSpell(mob, Smite)
	  end
    end
end


if ViMenu.Drawings.R:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,GetCastRange(myHero,_R),3,100,0xff00ff00) end
end)


addInterrupterCallback(function(target, spellType)
  if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target, 800) and ViMenu.Misc.Interrupt:Value() and spellType == CHANELLING_SPELLS then
  CastSkillShot(_Q, myHeroPos.x, myHeroPos.y, myHeroPos.z)
      for i=250, 750, 125 do
        GoS:DelayAction(function()
              local _Qrange = 250 + math.min(250, i/2)
              local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),math.huge,600,_Qrange,100,false,true)
              if QPred.HitChance == 1 then
                CastSkillShot2(_Q, QPred.PredPos.x, QPred.PredPos.y, QPred.PredPos.z)
              end
          end, i)
      end
  end
end)
