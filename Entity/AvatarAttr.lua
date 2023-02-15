local prop = require "Utils.prop"



local AvatarAttr = {
	Id = prop.prop("Int", "client save"),
	CurrentChar = prop.prop("Char.Char", "client save"),
	Chars = prop.prop("Char.CharDict", "client save")

	-- -- Eid
	-- Eid = prop.prop("ObjId", "client save"),
	-- -- 登录名
	-- LoginName = prop.prop("Str", "client save"),
	-- -- 账号
	-- Account = prop.prop("Str", "client save"),
	-- -- 账号ID
	-- AccountId = prop.prop("Str", "client save"),
	-- -- Hostnum
	-- Hostnum = prop.prop("Int", "client save"),
	-- -- 上次登录时间
	-- LastLoginTime = prop.prop("Float", "client save"),

	-- -- 上次离线区域数据
	-- LastRegionData = prop.prop("Region.LastRegionData", "client save"),
	-- -- 区域数据
	-- CommonRegionDatas = prop.prop("Region.CommonRegionDataDict", "client save"),
	-- QuestRegionDatas = prop.prop("Region.QuestRegionDataDict", "client save"),
	-- RarelyRegionDatas = prop.prop("Region.RarelyRegionDataDict", "client save"),
	-- -- 等级
	-- Level = prop.prop("Int", "client save", 1),
	-- -- 经验
	-- Exp = prop.prop("Int", "client save"),
	-- -- 当前角色
	-- CurrentChar = prop.prop("ObjId", "client save"),
	-- -- 当前近战武器
	-- MeleeWeapon = prop.prop("ObjId", "client save"),
	-- -- 当前远程武器
	-- RangedWeapon = prop.prop("ObjId", "client save"),
	-- -- 角色
	-- Chars = prop.prop("Character.CharDict", "client save"),
	-- -- 角色公共数据
	-- CommonChars = prop.prop("CharacterCommon.CommonCharDict", "client save"),
	-- -- 未拥有角色的皮肤
	-- OtherCharSkins = prop.prop("CustomTypes.Int2IntListDict", "client save"),
	-- -- 武器
	-- Weapons = prop.prop("Weapon.WeaponDict", "client save"),
	-- -- 任务
	-- QuestChains = prop.prop("Quest.QuestChains", "client save"),
	-- -- 资源
	-- Resources = prop.prop("Resource.ResourceDict", "client save"),
	-- -- Mod
	-- Mods = prop.prop("Mod.ModDict", "client save"),
	-- OriginalMods = prop.prop("CustomTypes.Int2ObjIdDict", "client save"),
	-- -- 副本
	-- Dungeons = prop.prop("Dungeon.DungeonDict", "client save"),
	-- --据点看板娘
	-- SignBoardNpc = prop.prop("CustomTypes.IntList", "client save",{-1,-1,-1}),
	-- -- 奖励序列记录
	-- RewardSequences = prop.prop("RewardSequence.SequenceDict", "save"),
	-- -- 成就
	-- Achvs = prop.prop("Achv.AchvDict", "client save"),

}


return AvatarAttr
