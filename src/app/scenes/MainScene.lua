require("miaolib")
--require("ob")
--require("laser")
require("ob_frame")
require("miaoconfig")
require("background2")
require("cover")
require("score")
require("mvp")
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Hello, World", size = 64})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
--    local btn=cc.ControlButton:create("miao","arial",30)
--    self:addChild(btn)
    
    local scene=self;
    main_scene=scene
    math.randomseed(os.time())
    --    bg=dofile("../../../../../src/app/background2.lua")
    --    cover=dofile("../../../../../src/app/cover.lua")
    --    score=dofile("../../../../../src/app/score.lua")
    --    mvp=dofile("../../../../../src/app/mvp.lua")
    bg=background2_c()
    cover=cover_c()
    score=score_c()
    mvp=mvp_c()
    scene.bg=bg
    scene.cover=cover
    scene.score=score
    scene.mvp=mvp
    scene:addChild(score,20)
    scene:addChild(mvp,11)
    scene:addChild(bg)
    if true then
        return
    end

    
    

  
    scene.bg=bg 
    --scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    --local cover=require("cover")
    --score=require("score")
    scene.score=score
    --local setting=cc.Sprite:create("setting.png")
    local setting=cc.ControlButton:create()
    local score_x,score_y=sx/2,sy*14/15
    score:setPosition(score_x,score_y)



    local function onTouch(eventType, x, y)
        if eventType =="began"  then
            return true
        elseif eventType == "moved" then
            return true
        else
            cover:remove()
            scene:start(bg)

            return true
        end

    end

    mvp:setPosition(screen_x/2,screen_y/4)

    scene.mvp=mvp


    function rear_update(force_start)

        if not rear_enable then
            return ;
        else
            return
        end

        score:setNum(score.num+1)
        local rear=cc.Sprite:create("rear.png")
        rear:setScale(0.4*screen_scale)
        --print(mvp.shield:getPosition())
        local shield_p=mvp.shield_node:convertToWorldSpace(cc.p(mvp.shield:getPosition()))
        rear:setPosition(shield_p.x,shield_p.y-70*screen_scale)
        local x_delta=40
        local x=math.random(-x_delta*screen_scale,x_delta*screen_scale)
        local rotate=math.random(0,360)
        rear:setRotation(rotate)
        local scale=math.random(50,100)
        rear:setScale(rear:getScale()*scale/100)
        local ac=cc.Spawn:create(cc.ScaleBy:create(2,0,0),cc.MoveBy:create(2,cc.p(x,-300*screen_scale)))
        local ac=cc.Sequence:create(
            ac,cc.CallFunc:create(function()rear:removeFromParent()end,{0}))
        scene:addChild(rear)
        rear:runAction(ac)
    end
    --rear_update(true)
    main_scene.fff=scene:getScheduler():scheduleScriptFunc(rear_update, 0.1, false)


    --button1

    local open_btn=cc.ControlButton:create()
    local btn_sprite=cc.Sprite:create("setting.png")
    btn_sprite:getTexture():setAntiAliasTexParameters()
    btn_sprite:setScale(0.18*ss)

    open_btn:setTitleLabelForState(btn_sprite,cc.CONTROL_STATE_NORMAL)
    open_btn:registerControlEventHandler(function()print("down")end,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    open_btn:setPosition(screen_x*0.90,score_y)
    scene:addChild(open_btn,11)




    if not init_done then
        init_done=true
        scene:addChild(cover)
        cover:registerScriptTouchHandler(onTouch)
        cover:setTouchEnabled(true)
    else
        --cover:remove()
        scene:start(bg)
    end


    
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
