--出售物品的过滤函数表，接收一个参数：物品对象，返回true需要出售，返回false不出售
s_tSellFilter = {}

--主线任务出售物品过滤函数
s_tSellFilter[1] = function(item)
	--如果不能出售, 不卖
	if not item.bCanTrade then return false end

	--灰色物品不卖，打开商店会自动出售
	if item.nQuality == 0 then return false end

	--如果是装备，卖
	if item.nGenre == ITEM_GENRE.EQUIPMENT then return true end

	--如果是材料, 卖
	if item.nGenre == ITEM_GENRE.MATERIAL then return true end

	--其他的都不卖
	return false
end
