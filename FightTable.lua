--战斗技能函数表，索引是当前的内功ID






--无奶妈、MT



s_tFightFunc = {}
s_tFightFunc[10224] = {}		--惊羽诀
s_tFightFunc[10081] = {}		--冰心诀
s_tFightFunc[10003] = {}		--易筋经
s_tFightFunc[10021] = {}		--花间游		
s_tFightFunc[10242] = {}		--焚影
s_tFightFunc[10243] = {}		--明尊	
s_tFightFunc[10389] = {}		--铁骨衣	
s_tFightFunc[10390] = {}		--分山
s_tFightFunc[10464] = {}		--霸刀
s_tFightFunc[10447] = {}		--莫问
s_tFightFunc[10448] = {}		--相知		
s_tFightFunc[10175] = {}		--毒经		
s_tFightFunc[10026] = {}		--傲血战意		
s_tFightFunc[10014] = {}		--紫霞功		
s_tFightFunc[10015] = {}		--太虚剑意		
s_tFightFunc[10225] = {}		--天罗诡道
s_tFightFunc[10145] = {}		--山居剑意		
s_tFightFunc[10144] = {}		--问水诀		
s_tFightFunc[10268] = {}		--笑尘诀	


--霸刀
s_tFightFunc[10464][1] = function()
	local player = GetClientPlayer()
	if not player then return end

	local target, targetClass = s_util.GetTarget(player)
	if not target then return end

	local MyBuff = s_util.GetBuffInfo(player)

		if s_util.CastSkill(16169, false) then return end
	if s_util.CastSkill(16621, false) then return end
	if s_util.CastSkill(16085, false) then return end
		if s_util.CastSkill(16027, false) then return end
end
--霸刀七刀宏
s_tFightFunc[10464][2] = function()
	--获取自己的Player对象，没有的话说明还没进入游戏，直接返回
	local player = GetClientPlayer()
	if not player then return end

	--如果当前门派不是霸刀，输出错误信息
	if player.dwForceID ~= FORCE_TYPE.BA_DAO then
		s_util.OutputTip("当前门派不是霸刀，这个宏无法正确运行。", 1)
		return
	end

	--当前血量比值
	local myhp = player.nCurrentLife / player.nMaxLife

	--获取当前目标,未进战没目标直接返回,战斗中没目标选择最近敌对NPC,调整面向
	local target, targetClass = s_util.GetTarget(player)							
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
		local MinDistance = 20		--最小距离
		local MindwID = 0		    --最近NPC的ID
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
			if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nLevel>0 then  --如果是敌对，并且距离更小
				MinDistance = s_util.GetDistance(v, player)                             
				MindwID = v.dwID                                                                  --替换距离和ID
			end
		end
		if MindwID == 0 then 
			return --没有敌对NPC则返回
		else	
			SetTarget(TARGET.NPC, MindwID)  --设定目标为最近的敌对NPC                
		end
	end
	if target then s_util.TurnTo(target.nX,target.nY) end

	--如果目标死亡，直接返回
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end

	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)

	--获取目标的buff表
	local TargetBuff = s_util.GetBuffInfo(target)
	local mTargetBuff = s_util.GetBuffInfo(target,true)

	--获取自己和目标的距离
	local dis = s_util.GetDistance(player, target)
	--获取警报信息
	local warnmsg = s_util.GetWarnMsg()

	--DPS野人谷老虎处理
	local laohu=s_util.GetNpc(36688,40)
	if laohu then SetTarget(TARGET.NPC, laohu.dwID) s_util.TurnTo(laohu.nX,laohu.nY) end

	--超出攻击范围追击
	if dis > 3.5 then
	s_util.TurnTo(target.nX, target.nY) MoveForwardStart()
	else
	MoveForwardStop() s_util.TurnTo(target.nX, target.nY)
	end

	--藏宝洞BOSS读条处理
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型
	if dwSkillId == 9241 and nLeftTime > 0.5 then if s_util.CastSkill(9007,false,true) then return end end        --震天后跳

	--藏宝洞BOSS道具处理
	if TargetBuff[7929] then if s_util.UseItem(5,21534) then return end end

	--藏宝洞火圈地刺处理
	local xianjing = 0		--陷阱数量
	for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
		end
		if  v.dwTemplateID==36774 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有地刺
			xianjing = 1                                                                
		end
	end
	if xianjing ==1 then
		s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
	else
		StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
	end

	--DPS OT扶摇
	if target.dwTemplateID==36680 and s_util.GetTarget(target).dwID== player.dwID then
		s_util.CastSkill(9002,false,true)
		if(MyBuff[208]) then Jump() end
		return
	end
		
	--给目标挂上闹须弥
	if (not TargetBuff[11447] or TargetBuff[11447].dwSkillSrcID ~= player.dwID) and s_util.GetSkillCD(17057) <= 0 then		--如果目标没有闹须弥buff或者不是我的，闹须弥冷却
		if player.nPoseState ~= POSE_TYPE.DOUBLE_BLADE then		--如果不是松烟竹雾姿态
			s_util.CastSkill(16166, false)						--施放松烟竹雾
			return
		end
		s_util.CastSkill(17057,false)							--释放 闹须弥
		return
	end


	--如果是松烟竹雾切姿态
	if player.nPoseState == POSE_TYPE.DOUBLE_BLADE then
		if s_util.GetSkillCD(16621) <= 0 and player.nCurrentSunEnergy >= 10  then					--如果坚壁清野冷却了，气劲大于等于10
			s_util.CastSkill(16169, false)						--施放雪絮金屏
		end
		--if player.nCurrentRage > 25 and dis < 6 then
		--	s_util.CastSkill(16168, false)						--施放秀明尘身
		--end
		--擒龙3段+飞镖
		if s_util.CastSkill(16870,false) then return end
		if MyBuff[11156] then 
			if s_util.CastSkill(34,false) then return end
		end
		if s_util.CastSkill(16871,false) then return end
		if s_util.CastSkill(16872,false) then return end
		if  MyBuff[11156] and MyBuff[11156].nStackNum > 1 and player.nCurrentRage > 28 then
			s_util.CastSkill(16168, false)						--施放秀明尘身
		end
	end


	--如果是秀明尘身姿态
	if player.nPoseState == POSE_TYPE.BROADSWORD then
		if MyBuff[11322] and MyBuff[11322].nLeftTime < 0.7 then s_util.CastSkill(18976,false,true) end
		if dis > 8 then  s_util.CastSkill(16166, false) return end --切刀追击
		--优先放坚壁清野
		if s_util.GetSkillCD(16621) <= 0 and player.nCurrentSunEnergy >= 10 then					--如果坚壁清野冷却了，气劲大于等于10
			--切换到雪絮金屏姿态
			s_util.CastSkill(16169, false,true)
			return
		end
		if player.nCurrentRage < 5 then  s_util.CastSkill(16166, false,true) return end --没狂切刀

		--雷走风切
		if s_util.CastSkill(16629, false) then return end

			--上将军印 7刀
		if s_util.CastSkill(19344, false) then return end

		if player.nCurrentSunEnergy > 20 then s_util.CastSkill(16169, false) return end

		--破釜沉舟 cw特效可以打
		--if MyBuff[xxx] then
		--	if s_util.CastSkill(16602, false) then return end
		--end

		--项王击鼎321段
		if s_util.CastSkill(17079, false) then return end
		if s_util.CastSkill(17078, false) then return end
		if s_util.CastSkill(16601, false) then return end
	end


	--如果是雪絮金屏姿态 
	if player.nPoseState == POSE_TYPE.SHEATH_KNIFE then
		--处理雪絮金屏姿态气劲用完的情况
		if player.nCurrentSunEnergy < 5 then				--如果气劲小于5点
			s_util.CastSkill(16166, false)					--施放松烟竹雾
			return
		end

		--坚壁清野
		if s_util.CastSkill(16621, false,true) then return end


		--切到秀明尘身
		if s_util.GetSkillCD(19344) <= 0 then		--
			s_util.CastSkill(16168, false,true)			--施放秀明尘身
			return
		end

		--刀啸风吟
		if s_util.CastSkill(16027,false) then return end	--施放刀啸风吟
		--醉斩白蛇
		if s_util.CastSkill(16085, false) then return end
	end
end
--霸刀斩纷宏
s_tFightFunc[10464][3] = function()
	--初始化
	if not g_MacroVars.State_16027 then
		g_MacroVars.State_16027 = 0				--刀啸风吟3次标志
		g_MacroVars.State_11334 = 0				--含风buff标志
	end

	--获取自己的Player对象，没有的话说明还没进入游戏，直接返回
	local player = GetClientPlayer()
	if not player then return end

	--Alt键强制返回
	if IsAltKeyDown() then return end

	--如果当前门派不是霸刀，输出错误信息
	if player.dwForceID ~= FORCE_TYPE.BA_DAO then
		s_util.OutputTip(target.nX)
		return
	end

	--当前血量比值
	local hpRatio = player.nCurrentLife / player.nMaxLife

	--获取当前目标,未进战没目标直接返回,战斗中没目标选择最近敌对NPC,调整面向
	local target, targetClass = s_util.GetTarget(player)							
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
		local MinDistance = 20		--最小距离
		local MindwID = 0		    --最近NPC的ID
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
			if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nMaxLife>1000 then  --如果是敌对，并且距离更小
				MinDistance = s_util.GetDistance(v, player)                             
				MindwID = v.dwID                                                                  --替换距离和ID
			end
		end
		if MindwID == 0 then 
			return --没有敌对NPC则返回
		else	
			SetTarget(TARGET.NPC, MindwID)  --设定目标为最近的敌对NPC                
		end
	end
	if target then s_util.TurnTo(target.nX,target.nY) end

	--如果目标死亡，直接返回
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end

	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)

	--获取目标的buff表
	local TargetBuff = s_util.GetBuffInfo(target)

	--获取自己和目标的距离
	local distance = s_util.GetDistance(player, target)

	if distance > 3.5 then
	s_util.TurnTo(target.nX, target.nY) MoveForwardStart()
	else
	MoveForwardStop() s_util.TurnTo(target.nX, target.nY)
	end

	--藏宝洞BOSS读条处理
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型
	if dwSkillId == 9241 and nLeftTime > 0.5 then if s_util.CastSkill(9007,false,true) then return end end        --震天后跳

	--藏宝洞BOSS道具处理
	if TargetBuffAll[7929] then if s_util.UseItem(5,21534) then return end end

	--给目标挂上闹须弥
	if (not TargetBuff[11447] or TargetBuff[11447].dwSkillSrcID ~= player.dwID) and s_util.GetSkillCD(17057) <= 0 then		--如果目标没有闹须弥buff或者不是我的，闹须弥冷却
		if player.nPoseState ~= POSE_TYPE.DOUBLE_BLADE then		--如果不是松烟竹雾姿态
			s_util.CastSkill(16166, false)						--施放松烟竹雾
			return
		end
		s_util.CastSkill(17057,false)							--释放 闹须弥
		return
	end

	--如果是松烟竹雾切姿态
	if player.nPoseState == POSE_TYPE.DOUBLE_BLADE then
		--如果有疏狂就切雪絮金屏，否则切秀明尘身
		if MyBuff[11456]  then 
			s_util.CastSkill(16169, false)						--施放雪絮金屏
			g_MacroVars.State_16027 = 0							--切姿态后设置刀x3标志为0
		else
			s_util.CastSkill(16168, false)						--施放秀明尘身
		end
		return
	end

	--如果是秀明尘身姿态
	if player.nPoseState == POSE_TYPE.BROADSWORD then
		--优先放坚壁清野
		if s_util.GetSkillCD(16621) <= 0 and player.nCurrentSunEnergy >= 10 then					--如果坚壁清野冷却了，气劲大于等于10
			--西楚悲歌
			if target.nMaxLife > 300000 then
				if s_util.CastSkill(16454, false) then return end
			end
			--切换到雪絮金屏姿态
			s_util.CastSkill(16169, false)
			g_MacroVars.State_16027 = 0
			return
		end

		--雷走风切
		if s_util.CastSkill(16629, false) then return end

		--破釜沉舟
		--if s_util.CastSkill(16602, false) then return end

		--上将军印 有僵直
		if s_util.CastSkill(16627, false) then return end

		--项王击鼎321段
		if s_util.CastSkill(17079, false) then return end
		if s_util.CastSkill(17078, false) then return end
		if s_util.CastSkill(16601, false) then return end
	end

	--如果是雪絮金屏姿态  坚壁 + 醉 + 刀x3 + 醉
	if player.nPoseState == POSE_TYPE.SHEATH_KNIFE then
		--处理雪絮金屏姿态气劲用完的情况，一般这个条件不会达到，但是还是要考虑各种特殊情况
		if player.nCurrentSunEnergy < 5 then				--如果气劲小于5点
			s_util.CastSkill(16168, false)					--施放秀明尘身
			return
		end

		--坚壁清野
		if s_util.CastSkill(16621, false) then return end

		--处理第三次刀啸读条结束，buff还没同步的问题
		local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(player)		--获取我的读条数据
		if dwSkillId == 16027 and nLeftTime < 0.5 and MyBuff[11334] and MyBuff[11334].nStackNum == 2 then			--如果在读条刀啸，并且剩余时间小于0.5秒, 并且有2层含风
			g_MacroVars.State_11334 = 1				--设置含风buff标志为1，就当作已经有3层含风了
		end

		--设置放过三次刀啸标志
		if MyBuff[11334] and MyBuff[11334].nStackNum > 2 then		--如果有含风，并且含风层数大于2
			g_MacroVars.State_16027 = 1							--技能状态设置为1，表示已经用过三次刀啸
		end

		--醉斩白蛇
		if g_MacroVars.State_11334 == 1 or not MyBuff[11334] or MyBuff[11334].nStackNum > 2 then  	--放过3次刀啸，或者没有含风，或者含风层数大于2
			if s_util.CastSkill(16085, false) then				--施放醉斩白蛇
				g_MacroVars.State_11334 = 0
				return
			end
		end

		--切到秀明尘身
		if s_util.GetSkillCD(16085) > 0 and g_MacroVars.State_16027 == 1 then		--如果醉斩白蛇有CD，并且用过三次刀啸
			s_util.CastSkill(16168, false)					--施放秀明尘身
			return
		end

		--刀啸风吟
		if not MyBuff[11334] or MyBuff[11334].nStackNum < 3 then		--没有含风buff，或者含风层数小于3
			s_util.CastSkill(16027,false)								--施放刀啸风吟
		end
	end
end


--明教 焚影
s_tFightFunc[10242][1] = function()
	--获取自己玩家对象
	local player = GetClientPlayer()
	if not player then return end
	
	--获取目标对象
	local target, targetClass = s_util.GetTarget(player)
	if not target then return end
	--获取自己和目标的距离
	local distance = s_util.GetDistance(player, target)
	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)
    if s_util.CastSkill(3960, false) then return end
	
	if s_util.CastSkill(3962, false) then return end
	if s_util.CastSkill(3963, false) then return end
	if s_util.CastSkill(3967, false) then return end
	if s_util.CastSkill(3959, false) then return end
	if s_util.CastSkill(3979, false) then return end
end

s_tFightFunc[10242][2] = function()
		
	--开头必须是这个，先获取自己的对象，没有的话说明还没进入游戏，直接返回
	local player = GetClientPlayer()
	if not player then return end

	--Alt键强制返回
	if IsAltKeyDown() then return end
	--当前血量比值
	local hpRatio = player.nCurrentLife / player.nMaxLife

	--获取当前目标,未进战没目标直接返回,战斗中没目标选择最近敌对NPC,调整面向
	local target, targetClass = s_util.GetTarget(player)							
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end 
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
	local MinDistance = 20			--最小距离
	local MindwID = 0		    --最近NPC的ID
	for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nLevel>0 then	--如果是敌对，并且距离更小
			MinDistance = s_util.GetDistance(v, player)                             
			MindwID = v.dwID                                                                    --替换距离和ID
			end
		end
	if MindwID == 0 then 
		return --没有敌对NPC则返回
	else	
		SetTarget(TARGET.NPC, MindwID)  --设定目标为最近的敌对NPC                
	end
	end
	if target then s_util.TurnTo(target.nX,target.nY) end  --调整面向

	--如果目标死亡，直接返回
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end

	--判断目标读条，这里没有做处理，可以判断读条的技能ID做相应处理(打断、迎风回浪、挑起等等)
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型

	--获取自己的读条数据
	local bPrepareMe, dwSkillIdMe, dwLevelMe, nLeftTimeMe, nActionStateMe =  GetSkillOTActionState(player)	

	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)

	--获取自己对目标造成的buff表
	local TargetBuff = s_util.GetBuffInfo(target, true)

	--获取目标全部的buff表
	local TargetBuffAll = s_util.GetBuffInfo(target)

	--获取自己和目标的距离
	local distance = s_util.GetDistance(player, target)

	--获取警报信息
	local warnmsg = s_util.GetWarnMsg()

	--DPS野人谷老虎处理
	local laohu=s_util.GetNpc(36688,40)
	if laohu then SetTarget(TARGET.NPC, laohu.dwID) s_util.TurnTo(laohu.nX,laohu.nY) end

	if distance > 3.5 then
	s_util.TurnTo(target.nX, target.nY) MoveForwardStart()
	else
	MoveForwardStop() s_util.TurnTo(target.nX, target.nY)
	end

	--藏宝洞火圈地刺处理
	local xianjing = 0		--陷阱数量
	for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
		end
		if  v.dwTemplateID==36774 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有地刺
			xianjing = 1                                                                
		end
	end
	if xianjing ==1 then
		s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
	else
		StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
	end

	--藏宝洞BOSS读条处理
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型
	if dwSkillId == 9241 and nLeftTime > 0.5 then if s_util.CastSkill(9007,false,true) then return end end       --震天后跳

	--藏宝洞BOSS处理
	if TargetBuffAll[7929] then if s_util.UseItem(5,21534) then return end end

		--藏宝洞火圈地刺处理
		local xianjing = 0		--陷阱数量
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
			end
		if  v.dwTemplateID==36774 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有地刺
			xianjing = 1                                                                
			end
		end
		if xianjing ==1 then
			s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
		else
			StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
		end

	--DPS OT扶摇
	if target.dwTemplateID==36680 and s_util.GetTarget(target).dwID== player.dwID then
		s_util.CastSkill(9002,false,true)
		if(MyBuff[208]) then Jump() end
		return
	end

	--简化日月能量
	local CurrentSun=player.nCurrentSunEnergy/100
	local CurrentMoon=player.nCurrentMoonEnergy/100

	--与目标距离>8尺使用流光，流光CD使用幻光步
	if distance > 8 then if s_util.CastSkill(3977,false) then return end end --流光
	if distance > 8 then if s_util.CastSkill(3970,false) then return end end --幻光

	--满日且没有同辉，光明相
	if player.nSunPowerValue > 0 and (not MyBuff[4937] or MyBuff[4937] and MyBuff[4937].nLevel ~= 2)   then
		if s_util.CastSkill(3969,true) then return end
	end

	--日60，日大
	if CurrentSun > 59 and CurrentSun <=79 then if s_util.CastSkill(18626,true) then return end end

	--破魔
	if s_util.CastSkill(3967,false) then return end

	--日0 月0,幽月轮；日80 月40，幽月轮
	if (CurrentMoon <= 19 and CurrentSun <= 19 ) or (CurrentSun >79 and CurrentSun <=99 and CurrentMoon >39 and CurrentMoon <=59 ) then 
		if s_util.CastSkill(3959,false) then return end
	end
	--日0 月20 且日盈中，幽月轮
	if CurrentSun <= 19 and CurrentMoon >19 and CurrentMoon <=39 and MyBuff[12487] then 
		if s_util.CastSkill(3959,false) then return end
	end

	--日0 月40 且非日盈中，日斩
	if  CurrentSun <= 19 and CurrentMoon >39 and CurrentMoon <=59 and not MyBuff[12487] then
		if  s_util.CastSkill(3963,false)  then return end 
	end
	--日20 月20 且非日盈中，日斩
	if CurrentSun >19 and CurrentSun <=39 and CurrentMoon >19 and CurrentMoon <=39 and not MyBuff[12487] then 
		if  s_util.CastSkill(3963,false)  then return end 
	end

	--日0 月20 且非日盈中，赤日轮
	if CurrentSun <= 18 and CurrentMoon >19 and CurrentMoon <=39 and not MyBuff[12487] then 
		if  s_util.CastSkill(3962,false)  then return end 
	end
	--日60 月60 且非日盈中，赤日轮
	if CurrentSun >59 and CurrentSun <=79 and CurrentMoon >59 and CurrentMoon <=79 and not MyBuff[12487] then
	if  s_util.CastSkill(3962,false)  then return end 
	end

	--日60 月20，驱夜
	if  CurrentSun >59 and CurrentSun <=79 and CurrentMoon >19 and CurrentMoon <=39 then
		if s_util.CastSkill(3979,false) then return end
	end
	--日40 月40，驱夜
	if  CurrentSun >39 and CurrentSun <=59 and CurrentMoon >39 and CurrentMoon <=59 then
		if s_util.CastSkill(3979,false) then return end
	end

	--日80 月60，月斩
	if CurrentSun >79 and CurrentSun <=99 and CurrentMoon >59 and CurrentMoon <=79 then if s_util.CastSkill(3960,false) then return end end 

	--卡宏补月轮
	if CurrentSun < 100 and CurrentMoon < 100 and player.nSunPowerValue <= 0 and player.nMoonPowerValue <= 0 then
	if s_util.CastSkill(3959,false) then return end
	end
end


--明教 明尊
s_tFightFunc[10243][1] = function()
	--获取自己玩家对象
	local player = GetClientPlayer()
	if not player then return end
	
	--获取目标对象
	local target, targetClass = s_util.GetTarget(player)
	if not target then return end
	--获取自己和目标的距离
	local distance = s_util.GetDistance(player, target)
	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)
    if s_util.CastSkill(3960, false) then return end
	
	if s_util.CastSkill(3962, false) then return end
	if s_util.CastSkill(3963, false) then return end
	if s_util.CastSkill(3967, false) then return end
	if s_util.CastSkill(3959, false) then return end
	if s_util.CastSkill(3979, false) then return end
end

s_tFightFunc[10243][2] = function()
		
	local player = GetClientPlayer()
	if not player then return end

	--Alt键强制返回
	if IsAltKeyDown() then return end

	--当前血量比值
	local hpRatio = player.nCurrentLife / player.nMaxLife
	local lowLifePartner,teamAvgLife,memberCount = s_util.GetTeamMember()
	local phpRatio=lowLifePartner.nCurrentLife/ lowLifePartner.nMaxLife
	--给血量最少的队友光明相
	if phpRatio<0.4 and s_util.GetSkillCD(3969) <=0 then 
	SetTarget(TARGET.PLAYER,lowLifePartner.dwID) 
	s_util.CastSkill(3969,false)
	return
	end

	--获取当前目标,未进战没目标直接返回,战斗中没目标选择最近敌对NPC,调整面向
	local target, targetClass = s_util.GetTarget(player)							
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
	local MinDistance = 20		--最小距离
	local MindwID = 0		    --最近NPC的ID
	for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nLevel>0 then  --如果是敌对，并且距离更小
			MinDistance = s_util.GetDistance(v, player)                             
			MindwID = v.dwID                                                                  --替换距离和ID
			end
		end
	if MindwID == 0 then 
		return --没有敌对NPC则返回
	else	
		SetTarget(TARGET.NPC, MindwID)  --设定目标为最近的敌对NPC                
	end
	end
	if target then s_util.TurnTo(target.nX,target.nY) end

	--如果目标死亡，直接返回
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end

	--判断目标读条，这里没有做处理，可以判断读条的技能ID做相应处理(打断、迎风回浪、挑起等等)
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)

	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)

	--获取自己对目标造成的buff表
	local TargetBuff = s_util.GetBuffInfo(target, true)

	--获取目标全部的buff表
	local TargetBuffAll = s_util.GetBuffInfo(target)

	--获取自己和目标的距离
	local distance = s_util.GetDistance(player, target)

	--获取警报信息
	local warnmsg = s_util.GetWarnMsg()

	if distance > 3.5 then
	s_util.TurnTo(target.nX, target.nY) MoveForwardStart()
	else
	MoveForwardStop() s_util.TurnTo(target.nX, target.nY)
	end

	local CurrentSun=player.nCurrentSunEnergy/100
	local CurrentMoon=player.nCurrentMoonEnergy/100

	--获取我的读条数据
	local bPrepareMe, dwSkillIdMe, dwLevelMe, nLeftTimeMe, nActionStateMe =  GetSkillOTActionState(player)	



	--如果自己在读条直接返回，避免打断朝圣言
	if bPrepareMe then return end --基本没用，还是自己停按键吧

	--取消自己身上的无威胁气劲buff
	if MyBuff[4487] then s_util.CancelBuff(4487) end  --明教极乐
	if MyBuff[917] then s_util.CancelBuff(917) end    --大师阵
	if MyBuff[8422] then s_util.CancelBuff(8422) end  --苍云盾墙
	if MyBuff[926] then s_util.CancelBuff(926) end    --天策阵
	if MyBuff[4101] then s_util.CancelBuff(4101) end  --天策引羌笛

	--藏宝洞BOSS处理
	if TargetBuffAll[7929] then if s_util.UseItem(5,21534) then return end end --驱散无敌

	--藏宝洞BOSS读条处理
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型
	--if dwSkillId == 9241 and nLeftTime > 0.5 then if s_util.CastSkill(9007,false,true) then return end end      --震天后跳

		--藏宝洞火圈地刺处理
		local xianjing = 0		--陷阱数量
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
			end
		end
		if xianjing ==1 then
			s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
		else
			StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
		end
		
	--OT极乐引
	if s_util.GetTarget(target).dwID~= player.dwID	then if s_util.CastSkill(3971,false) then return end end

	--慈悲愿
	if s_util.CastSkill(3982,false) then return end

	--光明
	if hpRatio < 0.4 then if s_util.CastSkill(3969,true) then return end end


	--目标最大血量大于30W 极乐朝圣言
	if s_util.GetSkillCD(3985) <=0 and target.nMaxLife>300000 then if s_util.CastSkill(3971,false) then return end end
	if target.nMaxLife>300000 then  if s_util.CastSkill(3985,false) then return end end

	--满灵前使用心火叹
	if player.nSunPowerValue > 0 or player.nMoonPowerValue > 0 or MyBuff[9909] and MyBuff[9909].nLeftTime < 12.97 and player.nCurrentSunEnergy > player.nCurrentMoonEnergy then
		if s_util.CastSkill(14922,false) then return end
	end

	--按下F切换为破魔循环
	if IsKeyDown("F") then 
	--破魔
	if s_util.CastSkill(3967,false) then return end
	end

	--生死劫
	if s_util.CastSkill(3966,false) then return end

	--银月斩优先月循环上仇
	if CurrentMoon >= CurrentSun and CurrentMoon < 61  then
		if  s_util.CastSkill(3960,false)  then return end
	end

	-- 烈日斩，日灵>月灵时释放
	if CurrentSun > CurrentMoon and CurrentSun < 61 then
		if  s_util.CastSkill(3963,false)  then return end
	end

	-- 日灵大于等于月灵且不满灵时打赤日轮
	if CurrentSun >= CurrentMoon and CurrentSun < 100 then
		if  s_util.CastSkill(3962,false)  then return end
	end

	--月灵大于日灵且不满灵时打幽月轮
	if CurrentSun < CurrentMoon and CurrentMoon < 100 then
	if s_util.CastSkill(3959,false) then return end
	end
end


--莫问
s_tFightFunc[10447][1] = function()
	local player = GetClientPlayer()
	if not player then return end

	local target, targetClass = s_util.GetTarget(player)
	if not target then return end

	local MyBuff = s_util.GetBuffInfo(player)
	if s_util.CastSkill(14230, false) then return end  --切到阳春白雪曲风
	if s_util.CastSkill(14082, false) then return end  --放影子
	if s_util.CastSkill(14081, false) then return end  --孤影化双
	if s_util.CastSkill(14083, false) then return end  --清绝影歌
	if s_util.CastSkill(14452, false) then return end  --剑羽
	if s_util.CastSkill(14449, false) then return end  --剑宫
	if s_util.CastSkill(14299, false) then return end  --无脑读徵
	if s_util.CastSkill(14068, false) then return end  --无脑读羽
	if s_util.CastSkill(14066, false) then return end  --无脑读角
	if s_util.CastSkill(14065, false) then return end  --无脑读商
end

s_tFightFunc[10447][2] = function()

	--获取自己的Player对象，没有的话说明还没进入游戏，直接返回
	local player = GetClientPlayer()
	if not player then return end

	--当前血量比值
	local hpRatio = player.nCurrentLife / player.nMaxLife
	local mymana =player.nCurrentMana / player.nMaxMana

	--获取当前目标,未进战没目标直接返回,战斗中没目标选择最近敌对NPC,调整面向
	local target, targetClass = s_util.GetTarget(player)							
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
		local MinDistance = 20		--最小距离
		local MindwID = 0		    --最近NPC的ID
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
			if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nLevel>0 then  --如果是敌对，并且距离更小
			MinDistance = s_util.GetDistance(v, player)                             
			MindwID = v.dwID                                                                  --替换距离和ID
			end
		end
		if MindwID == 0 then 
			return --没有敌对NPC则返回
		else	
			SetTarget(TARGET.NPC, MindwID)  --设定目标为最近的敌对NPC                
		end
	end

	if target then s_util.TurnTo(target.nX,target.nY) end

	--如果目标死亡，直接返回
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end

	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)

	--获取自己对目标造成的buff表
	local TargetBuff = s_util.GetBuffInfo(target, true)

	--获取目标全部的buff表
	local TargetBuffAll = s_util.GetBuffInfo(target)

	--获取自己和目标的距离
	local distance = s_util.GetDistance(player, target)

	--获取警报信息
	local warnmsg = s_util.GetWarnMsg()

	--DPS野人谷老虎处理
	local laohu=s_util.GetNpc(36688,40)
	if laohu then SetTarget(TARGET.NPC, laohu.dwID) s_util.TurnTo(laohu.nX,laohu.nY) end

	if distance > 15 then
	s_util.TurnTo(target.nX, target.nY) MoveForwardStart()
	else
	MoveForwardStop() s_util.TurnTo(target.nX, target.nY)
	end

	--藏宝洞火圈地刺处理
	local xianjing = 0		--陷阱数量
	for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
		end
		if  v.dwTemplateID==36774 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有地刺
			xianjing = 1                                                                
		end
	end
	if xianjing ==1 then
		s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
	else
		StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
	end

	--获取自己影子数量
	local ShadowNumber = s_util.GetShadow()

	--藏宝洞BOSS读条处理
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型
	if dwSkillId == 9241 and nLeftTime > 0.5 then if s_util.CastSkill(9007,false,true) then return end end        --震天后跳

	--藏宝洞BOSS处理
	if TargetBuffAll[7929] then if s_util.UseItem(5,21534) then return end end

		--藏宝洞火圈地刺处理
		local xianjing = 0		--陷阱数量
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
			end
		if  v.dwTemplateID==36774 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有地刺
			xianjing = 1                                                                
			end
		end
		if xianjing ==1 then
			s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
		else
			StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
		end

	--DPS OT扶摇
	if target.dwTemplateID==36680 and s_util.GetTarget(target).dwID== player.dwID then
		s_util.CastSkill(9002,false,true)
		if(MyBuff[208]) then Jump() end
		return
	end

	--初始化DOT刷新标志
	if not g_MacroVars.State_14064 then
		g_MacroVars.State_14064 = 0				--DOT刷新标志
	end		

	--长歌切剑时机自己掌握，小的大战本无所谓，打10人或者25人副本最好注释掉
	if not MyBuff[9284] and target.nMaxLife < 300000 then if s_util.CastSkill(14083, false) then return end end  --清绝影歌
	if MyBuff[9506] then if s_util.CastSkill(14452, false) then return end end --剑羽
	if MyBuff[9506] and distance < 4 then if s_util.CastSkill(14449, false) then return end end --剑宫

	if player.nPoseState ~= POSE_TYPE.YANGCUNBAIXUE then		--如果不是阳春白雪曲风
		s_util.CastSkill(14070, false)						--切换阳春白雪
		return
	end

	--疏影满且徵不在CD且目标最大血量>40W时开孤影
	if s_util.GetSkillCN(14082) > 2 and s_util.GetSkillCD(14067) <=0 and target.nMaxLife > 300000 then
		if s_util.CastSkill(14081, false) then return end
	end

	--孤影化双buff小于1S重置孤影
	if MyBuff[9284] and MyBuff[9284].nLeftTime < 1 then
		if s_util.CastSkill(14162, false) then return end
	end	

	--释放阳春白雪(优先）
	if s_util.CastSkill(14230, false, true) then return end

	--获取我的读条数据
	local bPrepareMe, dwSkillIdMe, dwLevelMe, nLeftTimeMe, nActionStateMe =  GetSkillOTActionState(player)

	--处理商、角刷新延迟重复读宫问题
	--如果正在读宫
	if  dwSkillIdMe == 14064 and nLeftTimeMe < 0.5 then  
		g_MacroVars.State_14064 = 1 	--设置刷新DOT标志
	end

	--判定刷新且充能次数大于等于2则释放羽
	if  g_MacroVars.State_14064 == 1 and s_util.GetSkillCN(14068) >= 2 then
		if s_util.CastSkill(14068, false)  then 
			g_MacroVars.State_14064 = 0
			return 
		end   --释放羽
	end

	--目标商或角持续时间小于4S且没有刷新DOT标志，读宫
	if (TargetBuff[9357] and TargetBuff[9357].nLeftTime < 4 and g_MacroVars.State_14064 == 0) or (TargetBuff[9361] and TargetBuff[9361].nLeftTime < 4 and g_MacroVars.State_14064 == 0) then
		if s_util.CastSkill(14064, false) then				--施放宫刷新DOT
				g_MacroVars.State_14064 = 1             --重置刷新DOT标志
				return
		end
	end

	--如果影子不满并且充能大于0且孤影CD>50S且不在读条就放影子
	if ShadowNumber < 6 and s_util.GetSkillCN(14082) > 0 and s_util.GetSkillCD(14081) > 50 and not bPrepareMe then
		if s_util.CastSkill(14082, false) then return end
	end
	--目标最大血量小于40W无脑放影子
	if ShadowNumber < 6 and target.nMaxLife < 300000  and not bPrepareMe and s_util.GetSkillCN(14082) > 0 then
		if s_util.CastSkill(14082, false) then return end
	end
	--刻梦起手7影子
	if ShadowNumber==6 and  s_util.GetSkillCN(14082) > 2 then
		if s_util.CastSkill(15040,true) then return end
		end
	--没蓝吃影子
	if mymana <= 0.3 and ShadowNumber>1 then 
		s_util.CastSkill(15040,true) 
		return 
	end

	--读商（DOT）
	if not TargetBuff[9357] then
		if s_util.CastSkill(14065, false) then return end  
	end

	--读角（DOT）
	if not TargetBuff[9361] then
		if  s_util.CastSkill(14066, false) then return end  
	end

	--没有凌冬buff或者凌冬等于2级释放羽
	if  not MyBuff[9353] or (MyBuff[9353] and MyBuff[9353].nLevel ==2 )then
		if s_util.CastSkill(14068, false)  then return end   --释放羽
	end

	--凌冬buff1级时需要2层充能以上才释放羽，保证书离时间
	if  MyBuff[9353] and MyBuff[9353].nLevel ==1 and s_util.GetSkillCN(14068) >= 2 then
		if s_util.CastSkill(14068, false)  then return end   --释放羽
	end

	--有3级凌冬且不再孤影中，读徵
	if MyBuff[9353] and MyBuff[9353].nLevel > 2 and not MyBuff[9284] then
		if s_util.CastSkill(14067, false)  then return end  --读条徵
	end

	--读宫填充
	if s_util.CastSkill(14064, false) then return end
end

--铁骨衣
s_tFightFunc[10389][2] = function()
	--获取自己的Player对象，没有的话说明还没进入游戏，直接返回
	local player = GetClientPlayer()
	if not player then return end

	--当前血量比值
	local hpRatio = player.nCurrentLife / player.nMaxLife

	--获取当前目标,未进战没目标直接返回,战斗中没目标选择最近敌对NPC,调整面向
	local target, targetClass = s_util.GetTarget(player)							
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
		local MinDistance = 20		--最小距离
		local MindwID = 0		    --最近NPC的ID
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
			if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nLevel>0 then  --如果是敌对，并且距离更小
				MinDistance = s_util.GetDistance(v, player)                             
				MindwID = v.dwID                                                                  --替换距离和ID
			end
		end
		if MindwID == 0 then 
			return --没有敌对NPC则返回
		else	
			SetTarget(TARGET.NPC, MindwID)  --设定目标为最近的敌对NPC                
		end
	end
	if target then s_util.TurnTo(target.nX,target.nY) end

	--如果目标死亡，直接返回
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end

	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)

	--获取目标的buff表
	local TargetBuff = s_util.GetBuffInfo(target)
	local mTargetBuff = s_util.GetBuffInfo(target,true)

	--获取自己和目标的距离
	local dis = s_util.GetDistance(player, target)

	--超出攻击范围追击
	if dis > 3.5 then
		s_util.TurnTo(target.nX, target.nY) MoveForwardStart()
	else
		MoveForwardStop() s_util.TurnTo(target.nX, target.nY)
	end

	--藏宝洞BOSS读条处理
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型
	if dwSkillId == 9241 and nLeftTime > 0.5 then if s_util.CastSkill(9007,false,true) then return end end        --震天后跳

	--藏宝洞BOSS道具处理
	if TargetBuff[7929] then if s_util.UseItem(5,21534) then return end end

	--藏宝洞火圈地刺处理
	local xianjing = 0		--陷阱数量
	for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
		end
		if  v.dwTemplateID==36774 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有地刺
			xianjing = 1                                                                
		end
	end
	if xianjing ==1 then
		s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
	else
		StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
	end
	--如果血量小于20，释放盾壁
	if hpRatio < 0.20 and s_util.CastSkill(13070, false) then return end
	--如果姿态是擎盾
	if player.nPoseState == 2 then
		--施放盾挡
		if player.nCurrentRage > 105 then
			if s_util.CastSkill(13391, false) then return end
		end
	
		--施放盾飞
		if MyBuff[8448] and MyBuff[8448].nLeftTime > 8 and s_util.GetSkillCN(13050) > 0 then
			if s_util.CastSkill(13050, false) then return end
		end
		--施放盾压
		if player.nCurrentRage < 100 then
			if s_util.CastSkill(13045, false) then return end
		end
		--施放盾刀的4321段
		if s_util.CastSkill(13119, false) then return end
		if s_util.CastSkill(13060, false) then return end
		if s_util.CastSkill(13059, false) then return end
		if s_util.CastSkill(13044, false) then return end
	end

	--如果姿态是擎刀
	if player.nPoseState == 1 then
		--切换姿态
		if s_util.CastSkill(13051, false) then return end
	end
end

--分山
s_tFightFunc[10390][2] = function()
	--获取自己的Player对象，没有的话说明还没进入游戏，直接返回
	local player = GetClientPlayer()
	if not player then return end
	--当前血量比值
	local hpRatio = player.nCurrentLife / player.nMaxLife
	--获取当前目标,未进战没目标直接返回,战斗中没目标选择最近敌对NPC,调整面向
	local target, targetClass = s_util.GetTarget(player)		
	if not player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) )then return end
	if player.bFightState and (not target or not IsEnemy(player.dwID, target.dwID) ) then  
		local MinDistance = 20		--最小距离
		local MindwID = 0		    --最近NPC的ID
		for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
			if IsEnemy(player.dwID, v.dwID) and s_util.GetDistance(v, player) < MinDistance and v.nLevel>0 then  --如果是敌对，并且距离更小
				MinDistance = s_util.GetDistance(v, player)                             
				MindwID = v.dwID                                                                  --替换距离和ID
			end
		end
		if MindwID == 0 then 
			return --没有敌对NPC则返回
		else	
			SetTarget(TARGET.NPC, MindwID)  --设定目标为最近的敌对NPC                
		end
	end
	if target then s_util.TurnTo(target.nX,target.nY) end
	--如果目标死亡，直接返回
	if target.nMoveState == MOVE_STATE.ON_DEATH then return end
	--获取自己的buff表
	local MyBuff = s_util.GetBuffInfo(player)
	--获取目标的buff表
	local TargetBuff = s_util.GetBuffInfo(target)
	local mTargetBuff = s_util.GetBuffInfo(target,true)
	--获取目标当前血量比值
	local thpRatio = target.nCurrentLife / target.nMaxLife
	--获取自己和目标的距离
	local distance = s_util.GetDistance(player, target)
	--获取警报信息
	local warnmsg = s_util.GetWarnMsg()
	--初始化血怒变量
	if not g_MacroVars.State_13040 then
		g_MacroVars.State_13040 = 0				
	end
	--DPS野人谷老虎处理
	local laohu=s_util.GetNpc(36688,40)
	if laohu then SetTarget(TARGET.NPC, laohu.dwID) s_util.TurnTo(laohu.nX,laohu.nY) end
	--超出攻击范围追击
	if distance > 3.5 then
	s_util.TurnTo(target.nX, target.nY) MoveForwardStart()
	else
	MoveForwardStop() s_util.TurnTo(target.nX, target.nY)
	end

	--藏宝洞BOSS读条处理
	local bPrepare, dwSkillId, dwLevel, nLeftTime, nActionState =  GetSkillOTActionState(target)		--返回 是否在读条, 技能ID，等级，剩余时间(秒)，动作类型
	if dwSkillId == 9241 and nLeftTime > 0.5 then if s_util.CastSkill(9007,false,true) then return end end        --震天后跳

	--藏宝洞BOSS道具处理
	if TargetBuff[7929] then if s_util.UseItem(5,21534) then return end end

	--藏宝洞火圈地刺处理
	local xianjing = 0		--陷阱数量
	for i,v in ipairs(GetAllNpc()) do		--遍历所有NPC
		if  v.dwTemplateID==36780 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有火圈
			xianjing = 1                                                                
		end
		if  v.dwTemplateID==36774 and s_util.GetDistance(v, player) < 3.5 then  --3.5尺内有地刺
			xianjing = 1                                                                
		end
	end
	if xianjing ==1 then
		s_util.TurnTo(target.nX, target.nY) StrafeLeftStart()
	else
		StrafeLeftStop() s_util.TurnTo(target.nX, target.nY) 
	end

	--DPS OT扶摇
	if target.dwTemplateID==36680 and s_util.GetTarget(target).dwID== player.dwID then
		s_util.CastSkill(9002,false,true)
		if(MyBuff[208]) then Jump() end
		return
	end
	--非战斗状态
	if not player.bFightState then
	if not MyBuff[3853] and s_util.GetItemCD(8,5147,true) <1 and Strength >3 then
	if s_util.UseEquip(8,5147) then end
	end
	
	--如果没有B腰坠buff,并且B腰坠技能CD<1,,并且目标是BOSS使用B腰坠技能 
	if not MyBuff[3853] and s_util.GetItemCD(8,5147,true) <1 and Strength >3 then
	  if s_util.UseItem(8,5147) then end
	end
	 
	--如果没有C腰坠buff,并且C腰坠技能CD<1,,并且目标是BOSS切换到C腰坠
	if not MyBuff[6360] and s_util.GetItemCD(8,19078,true) <1 and Strength >3 then
	  if s_util.UseEquip(8,19078) then end 
	end 
	
	--如果没有C腰坠buff,并且C腰坠技能CD<1,,并且目标是BOSS使用C腰坠技能  
	if not MyBuff[6360] and s_util.GetItemCD(8,19078,true) <1 and Strength >3 then
	  if s_util.UseItem(8,19078) then end
	end	
  
	--如果有B腰坠buff和C腰坠buff,或者B腰坠技能cd>1并且C腰坠技能cd>1,切换到A腰坠
	 if ( MyBuff[6360] and MyBuff[3853] ) or ( s_util.GetItemCD(8,19078,true) >1 and s_util.GetItemCD(8,5147,true) >1 ) then
	  if s_util.UseEquip(8,22831) then end
	end
	
	--释放所有血怒
	if not MyBuff[8385] or MyBuff[8385].nStackNum < 2 then
	  if s_util.CastSkill(13040, false) then return end
	end
	
  --非战斗状态结束
  end	
	  
  --进入战斗状态
  if player.bFightState then
  
  --如果血量小于30，释放盾壁
  if hpRatio < 0.30 and s_util.CastSkill(13070, false) then return end
  
  --设置血怒释放条件	
  --local xuenu33 = not MyBuff[8385] and s_util.GetSkillCN(13040) == 3
  local xuenu3 = not MyBuff[8385] and s_util.GetSkillCN(13040) == 3  --如果没有血怒buff而且血怒可用次数=3次
  local xuenu2 = not MyBuff[8385] and s_util.GetSkillCN(13040) == 2  --如果没有血怒buff而且血怒可用次数=2次	
  local xuenu1 = not MyBuff[8385]                                    --如果没有血怒buff
  
  --如果没有血怒buff,并且血怒可用次数=3次,释放血怒并且标记为3
	  if xuenu3 then 
	  if s_util.CastSkill(13040, false) then 
	  g_MacroVars.State_13040 = 3 return end 
	  elseif 
  --如果没有血怒buff，并且血怒可用次数=2次,释放血怒并且标记为2
	  xuenu2 then 
	  if s_util.CastSkill(13040, false) then 
	  g_MacroVars.State_13040 = 2 return end 
	  elseif 
  --如果没有血怒buff,释放血怒并且标记为1
	  xuenu1 then 
	  if s_util.CastSkill(13040, false) then return end
  end
  
  --如果血怒标记为3，再次释放血怒并清空标记
	  if g_MacroVars.State_13040 == 3 then 
	  if s_util.CastSkill(13040, false) then
	  g_MacroVars.State_13040 = 0 return end
	  end
	  
  --如果血怒标记为2，再次释放血怒并清空标记
	  if g_MacroVars.State_13040 == 2 then 
	  if s_util.CastSkill(13040, false) then
	  g_MacroVars.State_13040 = 0 return end
	  end
	  
	--如果姿态是擎盾
	if player.nPoseState == 2 then
	
	  --如果怒气<30,并且目标有流血buff,并且流血层数=1,并且流血时间>15,没有buff缓深,施放盾压
	  if player.nCurrentRage<= 30 or TargetBuff[8249] and TargetBuff[8249].nStackNum == 1 and TargetBuff[8249].nLeftTime > 15 and not MyBuff[8738] then
	  if s_util.CastSkill(13045, false) then return end
	  end
	
	  --如果目标有流血buff, 盾击可使用次数大于0, 施放盾击
	  if TargetBuff[8249] and s_util.GetSkillCN(13047) > 0 then 
	  if s_util.CastSkill(13047, false) then return end
	  end
  
	  --2层以下流血盾飞判定
	  if not TargetBuff[8249] and player.nCurrentRage>= 40 or  --如果目标没有流血buff,并且自身怒气>25,或者
	  TargetBuff[8249] and TargetBuff[8249].nStackNum == 1 and s_util.GetSkillCN(13047) < 1 or
	  s_util.GetSkillCN(13047) < 1 and player.nCurrentRage>= 40 and TargetBuff[8249] and TargetBuff[8249].nStackNum >= 2 or
	  TargetBuff[8249] and TargetBuff[8249].nLeftTime < 2 then
	  if s_util.CastSkill(13050, false) then return end  
	  end
	  
	  --如果怒气小于40,并且盾压CD>1,并且盾击并标记为3,释放盾猛
	  if player.nCurrentRage<= 40 and s_util.GetSkillCD(13045) > 1 and s_util.GetSkillCN(13047) < 1 then
	  if s_util.CastSkill(13046, false) then return end
	  end
	  
	  --盾刀的4321段
	  if s_util.CastSkill(13119, false) then return end
	  if s_util.CastSkill(13060, false) then return end
	  if s_util.CastSkill(13059, false) then return end
	  if s_util.CastSkill(13044, false) then return end
	  
	  --擎盾姿态结束
	  end
	  
	--如果姿态是擎刀
	if player.nPoseState == 1 then		
  
	  --目标流血时间>18并且流血层数>1,施放闪刀
	  if TargetBuff[8249] and TargetBuff[8249].nStackNum > 1 and TargetBuff[8249].nLeftTime > 18 then
		  if s_util.CastSkill(13053, false) then return end
	  end
	  
	  --如果目标没有流血buff,或者流血层数<3,或者流血时间<4,释放斩刀
	  if not TargetBuff[8249] or TargetBuff[8249].nStackNum < 3 or TargetBuff[8249].nLeftTime < 4 then
		  if s_util.CastSkill(13054, false) then return end 
	  end	
	  
	  --（1层流血情况）如果盾击可使用次数>2,并且盾飞可使用次数>0,并且斩刀CD>1,并且目标有流血buff,并且流血层数=1,并且流血时间>15,施放盾回
	  if  s_util.GetSkillCN(13047) > 2 and s_util.GetSkillCN(13050) > 0 and s_util.GetSkillCD(13054) > 1 and TargetBuff[8249] and TargetBuff[8249].nStackNum == 1 and TargetBuff[8249].nLeftTime > 15 then
		  if s_util.CastSkill(13051, false) then
		  g_MacroVars.State_13047 =0 return end
	  end
	  
	  --（2层流血情况）如果盾击可使用次数>2,并且盾飞可使用次数>0,并且斩刀CD>1,并且闪刀CD>1,并且目标有流血buff,并且流血层数=2,施放盾回
	  if  s_util.GetSkillCN(13047) > 2 and s_util.GetSkillCN(13050) > 0 and s_util.GetSkillCD(13054) > 1 and s_util.GetSkillCD(13053) > 1 and TargetBuff[8249] and TargetBuff[8249].nStackNum == 2 then
		  if s_util.CastSkill(13051, false) then
		  g_MacroVars.State_13047 =0 return end
	  end	
	  
	  --（3层流血情况1）如果盾击可使用次数>2,并且盾飞可使用次数>0,并且斩刀CD>1,并且闪刀CD>1,并且目标有流血buff,并且流血层数=3,并且流血时间<7,施放盾回
	  if  s_util.GetSkillCN(13047) > 2 and s_util.GetSkillCN(13050) > 0 and s_util.GetSkillCD(13054) > 1 and s_util.GetSkillCD(13053) > 1 and TargetBuff[8249] and TargetBuff[8249].nStackNum == 3 and TargetBuff[8249].nLeftTime < 7 then
		  if s_util.CastSkill(13051, false) then
		  g_MacroVars.State_13047 =0 return end
	  end	
	  
	  --（3层流血情况2）如果怒气<=4,或者盾飞可使用次数>0,并且闪刀CD>1,并且斩刀CD>1,并且目标有流血buff,并且流血层数=3,施放盾回
	  if player.nCurrentRage<=4 then 
		 if s_util.CastSkill(13051, false) then
		 g_MacroVars.State_13047 =0 return end
	  end
	  
	  --劫刀
	  if s_util.CastSkill(13052, false) then return end
	  
  --擎刀姿态结束	
	end
	
  --战斗状态结束  
  end	
	
end