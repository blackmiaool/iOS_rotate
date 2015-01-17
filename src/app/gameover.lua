function gameover()

	main_scene:getScheduler():unscheduleScriptEntry(main_scene.ddd)
	main_scene:getScheduler():unscheduleScriptEntry(main_scene.fff)
	rear_enable=false

	local ttfConfig = {};
	local layer=cc.Layer:create()
    ttfConfig.fontFilePath="fonts/blogs.ttf" --这里的路径要设置对，否则create出来就是nil
    ttfConfig.fontSize=screen_x/13 
    local gameover = cc.Label:createWithTTF(ttfConfig,"Gamer Over", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)

    --gameover:setString("")
    gameover:setTextColor(cc.c4b(255,255,255,255))

    gameover:setPosition(sx/2,sy*0.7)

    main_scene:addChild(layer,1)
    layer:addChild(gameover)

    ttfConfig.fontSize=screen_x/15
    ttfConfig.fontFilePath="fonts/arial.ttf"
    local best_score = cc.Label:createWithTTF(ttfConfig,"best score", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)
    best_score:setTextColor(cc.c4b(255,255,255,255))
    best_score:setPosition(sx/2,sy*0.6)
    layer:addChild(best_score)

    local best_score = cc.Label:createWithTTF(ttfConfig,"last score", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)
    best_score:setTextColor(cc.c4b(255,255,255,255))
    best_score:setPosition(sx/2,sy*0.5)
    layer:addChild(best_score)

    ttfConfig.fontSize=screen_x/13
    function get_value_text(x,y,str)
    	local value=cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)
    	value:setTextColor(cc.c4b(255,255,255,255))
    	value:setPosition(x,y)
        --value:setParent(parent)
        value:setString(str)
        return value
    end
    local best_score_value=get_value_text(sx/2,sy*0.55,101)
    layer:addChild(best_score_value)

    local last_score_value=get_value_text(sx/2,sy*0.45,score.num) 
    layer:addChild(last_score_value)


    local open_btn=cc.ControlButton:create()
    local btn_sprite=cc.Sprite:create("replay.png")
    btn_sprite:getTexture():setAntiAliasTexParameters()
    btn_sprite:setScale(1.8*ss)

    open_btn:setTitleLabelForState(btn_sprite,cc.CONTROL_STATE_NORMAL)
    open_btn:registerControlEventHandler(
    	function()


    		local gameScene = main_scene:create()
    		--gameScene=cc.TransitionFadeTR:create(3,gameScene)
    		--main_scene:removeAllChildren()

    		if cc.Director:getInstance():getRunningScene() then
    			cc.Director:getInstance():replaceScene(gameScene)
    		end

    		rear_enable=false

    	end
    	,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    open_btn:setPosition(sx*0.5,sy*0.3)
    layer:addChild(open_btn,11)

end
