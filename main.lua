--A SgtBlackDeer's mod--

local LittleSisterMod = RegisterMod("LittleSister",1);
local LittleSister = Isaac.GetPlayerTypeByName("LittleSister", false);
local TaintedLittleSister = Isaac.GetPlayerTypeByName("Tainted LittleSister", true);
local littlesisterhair = Isaac.GetCostumeIdByPath("gfx/characters/littlesisterhair.anm2");
local Taintedlittlesisterhair = Isaac.GetCostumeIdByPath("gfx/characters/taintedlittlesisterhair.anm2");
local dmgUp = false;

local LittleSisterStats = { 
    DAMAGE = 1.25,
    SPEED = 0.3,
    SHOTSPEED = 0.80,
    TEARHEIGHT = 0,
    TEARFALLINGSPEED = 0,
    LUCK = 1,
    FLYING = false,                                 
    TEARCOLOR = Color(1.0, 0.5, 0.8, 0.9, 0, 0, 0)
}

local TaintedLittleSisterStats = { 
    DAMAGE = 1,
    SPEED = 0.1,
    SHOTSPEED = 0.80,
    TEARHEIGHT = 0,
    TEARFALLINGSPEED = 0,
    LUCK = -1,
    FLYING = false,                                 
    TEARCOLOR = Color(1, 0, 0, 1, 0, 0, 0)
}

local specialTearsLuck = {
	BASE_CHANCE = 30,
    LOW_LUCK = 2,
    MID_LUCK = 4,
	MAX_LUCK = 6
}

--Equiping hairs--
function LittleSisterMod:onPlayerInit(player)    
    if player:GetPlayerType() == LittleSister then
        player:AddNullCostume(littlesisterhair);
        costumeEquipped = true;
	end
    if player:GetPlayerType() == TaintedLittleSister then
        player:AddNullCostume(Taintedlittlesisterhair);
        costumeEquipped = true;
	end
end

--Hearts limit & damage up with special items--
function LittleSisterMod:onUpdate(player)
    local game = Game();
    local red = player:GetMaxHearts();
    local soul = player:GetSoulHearts();
    local limit = red - 12;
    
    if game:GetFrameCount() == 1 then
        dmgUp = false;
    end
    
    if player:GetPlayerType() == LittleSister then        
		if red > 12 then
            player:AddMaxHearts(-limit);
            player:AddSoulHearts(limit);
		end
        
        if dmgUp == false then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_EYESHADOW) == true then
                player.Damage = player.Damage + 1;
                dmgUp = true;
            end
        end
	end
    if player:GetPlayerType() == TaintedLittleSister then
        if soul > 0 then 
            player:AddSoulHearts(-soul);
            player:AddHearts(soul);
        end
        
        if dmgUp == false then
            if player:HasCollectible(CollectibleType.COLLECTIBLE_ROTTEN_TOMATO) == true then
                player.Damage = player.Damage + 1;
                dmgUp = true;
            end
        end
	end
end

--Creeps conditions--
function LittleSisterMod:PostUpdate()
    local player = Isaac.GetPlayer(0);
    
    if player:GetPlayerType() == LittleSister and not player:IsDead() then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
            if player:GetSoulHearts() >= 6 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        else
            if player:GetSoulHearts() >= 3 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        end
    end
    if player:GetPlayerType() == TaintedLittleSister and not player:IsDead() then
        if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
            if player:GetHearts() >= 8 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        else
            if player:GetHearts() >= 4 then
                local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 1, player.Position, Vector(0, 0), player)
                creep:Update();
            end
        end
    end
    
    if (player:GetPlayerType() == LittleSister and player:GetSprite():IsFinished("Death") == true) or (player:GetPlayerType() == TaintedLittleSister and player:GetSprite():IsFinished("Death") == true) then
        dmgUp = false;
    end
end
 
--LittleSister stats--
function LittleSisterStats:onCache(player, cacheFlag)
    if player:GetPlayerType() == LittleSister then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * LittleSisterStats.DAMAGE;
        end
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed * LittleSisterStats.SHOTSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - LittleSisterStats.TEARHEIGHT;
            player.TearFallingSpeed = player.TearFallingSpeed + LittleSisterStats.TEARFALLINGSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + LittleSisterStats.SPEED;
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + LittleSisterStats.LUCK;
        end
        if cacheFlag == CacheFlag.CACHE_FLYING and LittleSisterStats.FLYING then
            player.CanFly = true
        end
        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = LittleSisterStats.TEARCOLOR;
        end
    end
end

--Tainted LittleSister stats--
function TaintedLittleSisterStats:onCache(player, cacheFlag)
    if player:GetPlayerType() == TaintedLittleSister then
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * TaintedLittleSisterStats.DAMAGE;
        end
        if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed * TaintedLittleSisterStats.SHOTSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearHeight = player.TearHeight - TaintedLittleSisterStats.TEARHEIGHT;
            player.TearFallingSpeed = player.TearFallingSpeed + TaintedLittleSisterStats.TEARFALLINGSPEED;
        end
        if cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + TaintedLittleSisterStats.SPEED;
        end
        if cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + TaintedLittleSisterStats.LUCK;
        end
        if cacheFlag == CacheFlag.CACHE_FLYING and TaintedLittleSisterStats.FLYING then
            player.CanFly = true
        end
        if cacheFlag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = TaintedLittleSisterStats.TEARCOLOR;
        end
    end
end

--Special tears chance--
function LittleSisterMod:onFireTear(tear)
    local player = Isaac.GetPlayer(0);
    local roll = math.random(100);
    
    for _, entity in pairs(Isaac.GetRoomEntities()) do   
        if entity.Type == EntityType.ENTITY_TEAR then
            local tear = entity:ToTear();

            if player:GetPlayerType() == LittleSister then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MID_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_CHARM;
                    end
                else
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MAX_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_CHARM;
                    end
                end
            end
            if player:GetPlayerType() == TaintedLittleSister then
                if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) == false then
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MID_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BAIT;
                    end
                else
                    if roll <= ((100 - specialTearsLuck.BASE_CHANCE) * player.Luck / specialTearsLuck.MAX_LUCK) + specialTearsLuck.BASE_CHANCE then

                        tear.TearFlags = tear.TearFlags | TearFlags.TEAR_BAIT;
                    end
                end
            end
        end
    end
end


LittleSisterMod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, LittleSisterMod.onPlayerInit);
LittleSisterMod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, LittleSisterMod.onUpdate);
LittleSisterMod:AddCallback(ModCallbacks.MC_POST_UPDATE, LittleSisterMod.PostUpdate);
LittleSisterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LittleSisterStats.onCache);
LittleSisterMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, TaintedLittleSisterStats.onCache);
LittleSisterMod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, LittleSisterMod.onFireTear);