if SERVER then
  AddCSLuaFile()
  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_psy.vmt")
  resource.AddFile("materials/vgui/ttt/icons/timer.png")
  resource.AddFile("materials/vgui/ttt/icons/dmgup.png")
end

function ROLE:PreInitialize()
  self.color = Color(99, 17, 11, 255)

  self.abbr = "psy" -- abbreviation
  self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
  self.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
  self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
  self.preventFindCredits = false
  self.preventKillCredits = false
  self.preventTraitorAloneCredits = false
  
  self.isOmniscientRole = true

  self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
  self.defaultTeam = TEAM_TRAITOR

  self.conVarData = {
    pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    credits = 0, -- the starting credits of a specific role
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 50,
    traitorButton = 1, -- can use traitor buttons
    shopFallback = SHOP_DISABLED --cannot buy items
  }
end

-- now link this subrole with its baserole
function ROLE:Initialize()
  roles.SetBaseRole(self, ROLE_TRAITOR)
end


function ROLE:GiveRoleLoadout(ply, isRoleChange)
	ply:GiveEquipmentWeapon("psycho_transform")
	ply:GiveEquipmentItem("item_ttt_armor")
end

function ROLE:RemoveRoleLoadout(ply, isRoleChange)
	ply:StripWeapon("psycho_transform")
	ply:RemoveEquipmentItem("item_ttt_armor")
end

--bonus damage while transformed
hook.Add("EntityTakeDamage", "ttt2_psy_transform_dmg", function(target, dmginfo)
	-- get the attacker
	local attacker = dmginfo:GetAttacker()

	-- make sure the attacker is valid and also the attacker must be a psycho
	if not IsValid(target) or not target:IsPlayer() then return end
	if not IsValid(attacker) or not attacker:IsPlayer() then return end
	if not (attacker:GetSubRole() == ROLE_PSYCHO) then return end
	
	if attacker:HasEquipmentItem("item_psycho") then
		dmginfo:SetDamage(dmginfo:GetDamage() * GetConVar("ttt2_psy_transform_dmg_multi"):GetFloat())
	end
end)



CreateConVar("ttt2_psy_transform_delay", 20, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_psy_transform_dmg_multi", "1.2", {FCVAR_ARCHIVE, FCVAR_NOTFIY, FCVAR_REPLICATED})
CreateConVar("ttt2_psy_transform_spd_multi", "1.2", {FCVAR_ARCHIVE, FCVAR_NOTFIY, FCVAR_REPLICATED})

if CLIENT then
  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

	form:MakeSlider({
      serverConvar = "ttt2_psy_transform_delay",
      label = "label_psy_transform_delay",
      min = 1,
      max = 120,
      decimal = 0
	})
	
	form:MakeSlider({
		serverConvar = "ttt2_psy_transform_dmg_multi",
		label = "label_psy_transform_dmg_multi",
		min = 1.0,
		max = 2.0,
		decimal = 2
	})
	
	form:MakeSlider({
		serverConvar = "ttt2_psy_transform_spd_multi",
		label = "label_psy_transform_spd_multi",
		min = 1.0,
		max = 2.0,
		decimal = 2
	})
  end
end