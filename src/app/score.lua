local ttfConfig = {}
ttfConfig.fontFilePath="fonts/Abel-Regular.ttf" --这里的路径要设置对，否则create出来就是nil
ttfConfig.fontSize=screen_x/10       
local score = cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)

score:setString("10")
score:setTextColor(cc.c4b(255,255,255,255))

function score:setNum(num)
	score:setString(""..num)
end

return score