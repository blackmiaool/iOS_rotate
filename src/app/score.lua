local ttfConfig = {}
ttfConfig.fontFilePath="fonts/Abel-Regular.ttf" --这里的路径要设置对，否则create出来就是nil
ttfConfig.fontSize=screen_x/10       
local score = cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)
score.num=0
score:setString("0")
score:setTextColor(cc.c4b(255,255,255,255))
function score:boom()
    score:stopAllActions()
    local speed=0.1
    local ac1=cc.ScaleTo:create(speed,1.4)
    ac1=cc.EaseSineOut:create(ac1)
    local ac2=cc.ScaleTo:create(speed,1)
    ac2=cc.EaseSineIn:create(ac2)
    ac=cc.Sequence:create(ac1,ac2)
    score:runAction(ac)
    self:setNum(self.num+20)
end
function score:setNum(num)
	score.num=num
	score:setString(""..num)
end

return score