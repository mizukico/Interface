--各类Buff数据
s_tBuffFunc = {}

--判断对象是否处于各种状态
--参数(需要判断的对象)
--返回值:返回处于该状态下的BUFF数据，不处于该状态返回nil
--[[
    爆发    s_tBuffFunc.BaoFa()
    减疗    s_tBuffFunc.JianLiao()
    禁疗    s_tBuffFunc.JinLiao()
    无敌    s_tBuffFunc.WuDi()
    沉默    s_tBuffFunc.ChenMo()
    免控    s_tBuffFunc.MianKong()
    减伤    s_tBuffFunc.JianShang()
    减速    s_tBuffFunc.JianSu()
    眩晕    s_tBuffFunc.XuanYun()
    锁足    s_tBuffFunc.SuoZu()
    定身    s_tBuffFunc.DingShen()
    闪避    s_tBuffFunc.ShanBi()
    封轻功  s_tBuffFunc.FengQingGong()
    免封内  s_tBuffFunc.MianFengNei()
    免推    s_tBuffFunc.MianTui()
--]]

--定义判断风车函数
--参数:需要判断的角色
--返回值：若在需判断的角色10尺内有离手风车返回1，10尺内有读条风车或项王返回2，没有返回false
s_tBuffFunc.FengChe = function ( tar )
    local npc = s_util.GetNpc(57739, 30)
    local me = GetClientPlayer()
    if npc and IsEnemy(me.dwID, npc.dwID) and s_util.GetDistance(tar, npc) <=10 then
        return 1
    end
    for i,v in ipairs(GetAllPlayer()) do		--遍历
        local  bPrepare,dwSkillId = GetSkillOTActionState(v)
        if IsEnemy(me.dwID, v.dwID) and (dwSkillId ==1645 or dwSkillId ==16381) then
            local dis = s_util.GetDistance(tar, v)
            if dis <=10 then return 2 end
        end
    end
    return false
end

--定义改变面向函数
--参数：需转动的面向(-128~128) ，无返回值
--转动面向需要2S间隔，防止无限转向
s_tBuffFunc.ChFace = function ( ang )
    local player = GetClientPlayer() 
	local rd = ((player.nFaceDirection+ang)%256)*math.pi/128
	local finX = (128)*math.cos(rd)+player.nX
	local finY = (128)*math.sin(rd)+player.nY
	if not s_util.GetTimer("ChangeFace") or s_util.GetTimer("ChangeFace") > 2000 then
		s_util.SetTimer("ChangeFace")
		s_util.TurnTo(finX, finY)
	end
end

--爆发
s_tBuffFunc.BaoFa = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[200--[[疾如风]]] or Buff[2719--[[青荷]]] or Buff[2757--[[紫气东来]]] or Buff[538--[[繁音急节]]] or Buff[1378--[[弱水]]] or Buff[3468--[[心无旁骛]]] or Buff[3859--[[香疏影]]] or Buff[2726--[[乱洒]]] or Buff[5994--[[酒中仙]]] or Buff[2779--[[渊]]] or Buff[1728--[[莺鸣]]] or Buff[3316--[[扬威]]] or Buff[2543--[[灵蛇献祭]]] or Buff[9906--[[贯木流年]]] or Buff[11456--[[疏狂]]] or Buff[11216--[[重激]]]
    return IsBuff
end

--减疗
s_tBuffFunc.JianLiao = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[2774--[[霹雳]]] or Buff[3195--[[穿心弩]]] or Buff[3538--[[穿心]]] or Buff[574--[[无相]]] or Buff[576--[[恒河劫沙]]] or Buff[2496--[[百足枯残]]] or Buff[2502--[[蝎蛰]]] or Buff[4030--[[月劫]]] or Buff[6155--[[神龙降世]]] or Buff[8487--[[盾击]]] or Buff[9514--[[楚济]]] or Buff[11199--[[吞楚]]]
    return IsBuff
end

--禁疗
s_tBuffFunc.JinLiao = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[9175--[[息疗]]] or Buff[6223--[[活祭]]]
    return IsBuff
end

--无敌 缺少平沙状态
s_tBuffFunc.WuDi = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[377--[[镇山河]]] or Buff[961--[[太虚]]] or Buff[772--[[回神]]] or Buff[3425--[[鬼斧神工]]] or Buff[360--[[御]]] or Buff[6182--[[冥泽]]] or Buff[9934--[[南风吐月]]] or Buff[11151--[[散流霞]]] or Buff[682--[[雷霆震怒]]] or Buff[4871--[[无明魂锁]]] or Buff[3224--[[迷神钉]]] or Buff[2795--[[罗汉金身]]] or Buff[8303--[[盾立]]] 
    return IsBuff
end

--沉默
s_tBuffFunc.ChenMo = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[726--[[剑飞惊天]]] or Buff[692--[[沉默]]] or Buff[712--[[兰摧玉折]]] or Buff[4053--[[怖畏暗刑]]] or Buff[8450--[[雷云]]] or Buff[9378--[[井仪]]] or Buff[10283--[[余音]]] or Buff[11171--[[风切]]] or Buff[445--[[抢珠式]]] or Buff[690--[[剑心通明]]] or Buff[2182--[[八卦洞玄]]] or Buff[2838--[[剑破虚空]]] or Buff[3227--[[梅花针]]] or Buff[2807--[[凄切]]] or Buff[2490--[[蟾啸迷心]]] or Buff[585--[[厥阴指]]] or Buff[9214--[[清音长啸]]]
    return IsBuff
end

--免控
s_tBuffFunc.MianKong = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[411--[[星楼月影]]] or Buff[1186--[[折骨]]] or Buff[2847--[[素衿]]] or Buff[855--[[力拔]]] or Buff[2756--[[纵轻骑]]] or Buff[2781--[[转乾坤]]] or Buff[3279--[[生死之交]]] or Buff[1856--[[不工]]] or Buff[1676--[[玉泉鱼跃]]] or Buff[1686--[[梦泉虎跑]]] or Buff[2840--[[蛊虫狂暴]]] or Buff[2544--[[风蜈献祭]]] or Buff[3822--[[碧蝶献祭]]] or Buff[4245--[[圣体]]] or Buff[4421--[[灵辉]]] or Buff[4468--[[超然]]] or Buff[6373--[[出渊]]] or Buff[6361--[[飞将]]] or Buff[6314--[[零落]]] or Buff[6292--[[吞日月]]] or Buff[6247--[[迷心蛊]]] or Buff[6192--[[菩提身]]] or Buff[6131--[[青阳]]] or Buff[5995--[[笑醉狂]]] or Buff[6459--[[烟雨行]]] or Buff[6015--[[龙跃于渊]]] or Buff[6369--[[酒中仙]]] or Buff[6087--[[流火飞星]]] or Buff[5754--[[霸体]]] or Buff[5950--[[蛊虫献祭]]] or Buff[3275--[[绝伦逸群]]] or Buff[8247--[[无惧]]] or Buff[8265--[[盾墙]]] or Buff[8293--[[千险]]] or Buff[8458--[[水月无间]]] or Buff[8449--[[劫化]]] or Buff[8483--[[盾毅]]] or Buff[8716--[[捍卫]]] or Buff[9059--[[青蒂]]] or Buff[9068--[[净果]]] or Buff[9999--[[捣衣]]] or Buff[6284--[[圣法光明]]] or Buff[677--[[鹊踏枝]]] or Buff[9855--[[音韵]]] or Buff[9342--[[石间意]]] or Buff[9294--[[孤影]]] or Buff[9848--[[探梅]]] or Buff[10245--[[破重围]]] or Buff[11361--[[尘身]]] or Buff[11385--[[西楚悲歌]]] or Buff[11319--[[临渊蹈河]]] or Buff[374--[[生太极]]] or Buff[1903--[[啸日]]]
    return IsBuff
end

--减伤
s_tBuffFunc.JianShang = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[367--[[守如山]]] or Buff[384--[[转乾坤]]] or Buff[399--[[无相诀]]] or Buff[122--[[春泥护花]]] or Buff[3068--[[雾体]]] or Buff[1802--[[御天]]] or Buff[684--[[天地低昂]]] or Buff[4439--[[贪魔体]]] or Buff[6315--[[零落]]] or Buff[2077--[[正骨]]] or Buff[6240--[[玄水蛊]]] or Buff[5996--[[笑醉狂]]] or Buff[5810--[[脑户]]] or Buff[6200--[[龙啸九天]]] or Buff[6636--[[圣手织天]]] or Buff[6262--[[金屋]]] or Buff[2849--[[蝶戏水]]] or Buff[3315--[[护体]]] or Buff[8279--[[盾壁]]] or Buff[8300--[[盾墙]]]or Buff[8427--[[荣辉]]] or Buff[8291--[[盾护]]] or Buff[8495--[[捍卫]]] or Buff[2983--[[无我]]] or Buff[10014--[[绝歌]]] or Buff[10051--[[杯水留影]]] or Buff[10107--[[震八方]]] or Buff[9334--[[梅花三弄]]] or Buff[11344--[[破釜沉舟]]] or Buff[6264--[[春泥护花]]] 
    return IsBuff
end

--减速
s_tBuffFunc.JianSu = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[733--[[太乙]]] or Buff[4928--[[减速]]] or Buff[549--[[穿]]] or Buff[450--[[玄一]]] or Buff[523--[[步迟]]] or Buff[2274--[[缠足]]] or Buff[560--[[生太极]]] or Buff[563--[[抱残式]]] or Buff[584--[[少阳指]]] or Buff[1553--[[剑主天地]]] or Buff[1720--[[惊涛]]] or Buff[2297--[[千丝]]] or Buff[3484--[[冰封]]] or Buff[3226--[[毒蒺藜]]] or Buff[4054--[[业海罪缚]]] or Buff[6275--[[火舞长空]]] or Buff[6259--[[雪中行]]] or Buff[6191--[[业力]]] or Buff[6162--[[山阵]]] or Buff[6130--[[埋骨]]] or Buff[6078--[[暴雨梨花针]]] or Buff[3466--[[刖足]]] or Buff[4435--[[伏夜·缓]]] or Buff[8299--[[盾墙]]] or Buff[8398--[[卷云]]] or Buff[8492--[[难行]]] or Buff[9170--[[禁缚]]] or Buff[10001--[[轰雷]]] or Buff[9507--[[剑·宫]]] or Buff[9217--[[风入松]]] or Buff[11168--[[伏尘]]] or Buff[11245--[[击鼎]]] or Buff[6072--[[剑主天地]]]
    return IsBuff
end

--眩晕
s_tBuffFunc.XuanYun = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[415--[[眩晕]]] or Buff[533--[[致盲]]] or Buff[567--[[五蕴皆空]]] or Buff[572--[[大狮子吼]]] 
    or Buff[548--[[突]]] or Buff[2275--[[断魂刺]]] or Buff[740--[[中注]]] or Buff[1721--[[醉月]]] or Buff[1904--[[鹤归孤山]]] or Buff[1927--[[碧王]]] or Buff[2489--[[蝎心迷心]]] or Buff[2780--[[剑冲阴阳]]] or Buff[3223--[[雷震子]]] or Buff[727--[[崩]]] or Buff[1938--[[峰插云景]]] or Buff[4029--[[日劫]]] or Buff[4875--[[镇魔]]] or Buff[6276--[[幻光步]]] or Buff[6128--[[虎贲]]] or Buff[6107--[[弩击]]] or Buff[5876--[[善护]]] or Buff[6365--[[净世破魔击]]] or Buff[6380--[[醉逍遥]]] or Buff[2755--[[北斗]]] or Buff[1902--[[危楼]]] or Buff[2877--[[日影]]] or Buff[4438--[[伏夜·晕]]] or Buff[8329--[[撼地]]] or Buff[8455--[[盾毅]]] or Buff[8570--[[盾猛]]] or Buff[11453--[[裁骨]]]
    return IsBuff
end

--锁足
s_tBuffFunc.SuoZu = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[1937--[[三才化生]]] or Buff[679--[[影痕]]] or Buff[706--[[止水]]] or Buff[4038--[[锁足]]] or Buff[2289--[[五方行尽]]] or Buff[2492--[[百足迷心]]] or Buff[2547--[[天蛛献祭]]] or Buff[1931--[[吐故纳新]]] or Buff[6364--[[滞]]] or Buff[4758--[[禁缚]]] or Buff[5809--[[太乙]]] or Buff[5764--[[百足]]] or Buff[5694--[[太阴指]]] or Buff[5793--[[碎冰]]] or Buff[4436--[[伏夜·缠]]] or Buff[3359--[[铁爪]]] or Buff[8251--[[落雁]]] or Buff[8327--[[断筋]]] or Buff[3216--[[钻心刺骨]]] or Buff[9569--[[剑·羽]]] or Buff[9730--[[钟林毓秀]]] or Buff[10282--[[琴音]]]
    return IsBuff
end

--定身
s_tBuffFunc.DingShen = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[998--[[太阴指]]] or Buff[678--[[傍花随柳]]] or Buff[686--[[帝骖龙翔]]] or Buff[554--[[大道无术]]] or Buff[556--[[七星拱瑞]]] or Buff[675--[[芙蓉并蒂]]] or Buff[737--[[完骨]]] or Buff[1229--[[破势]]] or Buff[1247--[[同归]]] or Buff[4451--[[定身]]] or Buff[1857--[[松涛]]] or Buff[1936--[[绛唇珠袖]]] or Buff[2555--[[丝牵]]] or Buff[6317--[[金针]]] or Buff[6108--[[天绝地灭]]] or Buff[6091--[[迷影]]] or Buff[2311--[[幻蛊]]] or Buff[4437--[[伏夜·定]]] or Buff[6082--[[大道无术]]]
    return IsBuff
end

--闪避
s_tBuffFunc.ShanBi = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[3214--[[惊鸿游龙]]] or Buff[2065--[[云栖松]]] or Buff[5668--[[风吹荷]]] or Buff[6434--[[醉逍遥]]] or Buff[6299--[[御风而行]]] or Buff[6174--[[两生]]]
    return IsBuff
end

--封轻功
s_tBuffFunc.FengQingGong = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[562--[[吞日月]]] or Buff[562--[[千丝迷心]]] or Buff[562--[[迷幻]]] or Buff[562--[[身乏]]] or Buff[562--[[滞影]]] or Buff[562--[[玳弦]]] or Buff[1939--[[云景]]] or Buff[6074--[[恶狗拦路]]] or Buff[4497--[[幻相]]] or Buff[535--[[半步颠]]] or Buff[562--[[步残]]] or Buff[10246--[[重围]]] or Buff[562--[[行泽]]]
    return IsBuff
end

--免封内
s_tBuffFunc.MianFengNei = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[6350--[[临风]]] or Buff[6414--[[幻光步]]] or Buff[8864] or Buff[5777] or Buff[377--[[镇山河]]] or Buff[9934--[[南风吐月]]] or Buff[6256] or Buff[8458--[[水月无间]]] or Buff[1186--[[折骨]]] or Buff[4439--[[贪魔体]]] or Buff[6279] or Buff[4245--[[圣体]]] or Buff[9999--[[捣衣]]] or Buff[9342--[[石间意]]] or Buff[9509] or Buff[9506] or Buff[9693] or Buff[10173] or Buff[5789] or Buff[10618]
    return IsBuff
end

--免推
s_tBuffFunc.MianTui = function ( tar )
    local Buff = s_util.GetBuffInfo(tar)
    local IsBuff = Buff[8247--[[无惧]]] or Buff[8864] or Buff[2756--[[纵轻骑]]] or Buff[10245--[[破重围]]] or Buff[377--[[镇山河]]] or Buff[9934--[[南风吐月]]] or Buff[6213] or Buff[1903--[[啸日]]] or Buff[1856--[[不工]]] or Buff[1686--[[梦泉虎跑]]] or Buff[10130] or Buff[3425--[[鬼斧神工]]] or Buff[4439--[[贪魔体]]] or Buff[6279] or Buff[4245--[[圣体]]] or Buff[5754--[[霸体]]] or Buff[5995--[[笑醉狂]]] or Buff[8265--[[盾墙]]] or Buff[8303--[[盾立]]] or Buff[8483--[[盾毅]]] or Buff[9509] or Buff[9693] or Buff[10173] or Buff[11151--[[散流霞]]] or Buff[11336] or Buff[11361--[[尘身]]] or Buff[11385--[[西楚悲歌]]] or Buff[11319--[[临渊蹈河]]] or Buff[11322] or Buff[11335] or Buff[11310] or Buff[1186--[[折骨]]] or Buff[10258] or Buff[11077] or Buff[11148] or Buff[11149] or Buff[5994--[[酒中仙]]] or Buff[5996--[[笑醉狂]]] or Buff[8458--[[水月无间]]] or Buff[1802--[[御天]]]
    return IsBuff
end