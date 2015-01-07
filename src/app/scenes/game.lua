require("miaolib")
require("ob")
local GameScene = class("GameScene",function()
    return cc.Scene:createWithPhysics()
end)

function getAngle(x,y)
    
    return -(math.atan2(y,x)*xishu)
end
function GameScene:layer_create()
    local background=cc.Layer:create()
    local choose="leave"
    local function x2choose(x)
        if x<screen_x/2 then
            return "left"
        else
            return "right"
        end        
    end
    local function touchFunc(x,y,start)
        local choose_this=x2choose(x)
        if choose_this~=choose or start then
            if choose_this=="left" then
                self.mvp.shield_node:left()
            else
                self.mvp.shield_node:right()
            end
            choose=choose_this
        end
--        local mvp_x,mvp_y=self.mvp:getPosition()
--        self.mvp:setshieldAngle(        
--            getAngle(x-self.mvp:getPositionX(),
--            y-self.mvp:getPositionY()),2*math.sqrt((x-mvp_x)*(x-mvp_x)+(y-mvp_y)*(y-mvp_y)))
    end
    local function onTouchBegan(x, y)
        touchFunc(x,y,true)
        return true
    end

    local function onTouchMoved(x, y)
        touchFunc(x,y)
        return true
    end

    local function onTouchEnded(x, y)
        self.mvp.shield_node:stop()
        return true
    end

    local function onTouch(eventType, x, y)

        if eventType =="began"  then
            return onTouchBegan(x, y)
        elseif eventType == "moved" then
            return onTouchMoved(x, y)
            
        else
            return onTouchEnded(x, y)
        end
    end

    --注册触摸函数
    background:registerScriptTouchHandler(onTouch)

    --设置成可触摸

    background:setTouchEnabled(true)
    return background
end

function GameScene:start()
    local bg=self.bg
    local mvp=self.mvp
    local scene=self
    print("start")
    mvp.shield:out()



    vz=cc.Director:getInstance():getVisibleSize()
    math.randomseed(os.time())

    main_scene=scene
    function rear_update()
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
    mvp.shield_node:getScheduler():scheduleScriptFunc(rear_update, 0.1, false)
    local ts=cc.Sprite:create("ob_blue.png")




    scene:addChild(scene:layer_create())


    function scene_update()
        local R=math.random(1,3)
        local num=math.random(1,3)
        local ob_test=ob_loop_with_circles(140*screen_scale,20*screen_scale,40,num,90,random_color(),{random_color(),random_color(),random_color()})

        scene:addChild(ob_test)
        ob_test:setPosition(screen_x/4*R,screen_y*0.7)
        local move=cc.MoveBy:create(1,cc.p(0,-100))
        move=cc.RepeatForever:create(move)
        ob_test:runAction(move)

    end


    scene:getScheduler():scheduleScriptFunc(scene_update, 2, false)



    local function onContactBegin(contact,a,b)
        local retval;
        local nodeA=contact:getShapeA():getBody():getNode()
        local nodeB=contact:getShapeB():getBody():getNode()
        local shield;
        local core;
        local ob;
        if not nodeA or not nodeB then
            return nil
        end

        if nodeA==mvp.shield or nodeB==mvp.shield then
            if nodeA==mvp.shield then
                shield=nodeA
                ob=nodeB
            elseif nodeB==mvp.shield then
                shield=nodeB
                ob=nodeA   
            end
            if ob.kind~="ob" then                
                local v=ob:getPhysicsBody():getVelocity()
                ob:getPhysicsBody():setVelocity(cc.p(-v.x,-v.y))
                return nil
            end


            --            miao:setPosition(ob:getPosition())
            ob:remove()
            --print(shield:getPhysicsBody():getVelocity())
            shield:getPhysicsBody():setVelocity(cc.p(0,0))
            --print(shield:getPosition())
        elseif nodeA==mvp.core or nodeB==mvp.core then
            if nodeA==mvp.core then
                core=nodeA
                ob=nodeB
            elseif nodeB==mvp.core then
                core=nodeB
                ob=nodeA            
            end 
            core:getPhysicsBody():setVelocity(cc.p(0,0))
        end                
        return retval        
    end

    local contact=cc.EventListenerPhysicsContact:create()
    contact:registerScriptHandler(onContactBegin,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
    contact:setEnabled(true)

    local eventDispatcher = scene:getEventDispatcher()
    eventDispatcher:setEnabled(true)

    eventDispatcher:addEventListenerWithSceneGraphPriority(contact, scene)
    local miao=cc.ParticleSystemQuad:create("bg.plist")
    scene:addChild(miao)
    miao:setPosition(screen_x/2,screen_y/2)

    local left_body=cc.Sprite:create()
    
    local right_body=cc.Sprite:create()
    left_body:setPhysicsBody(cc.PhysicsBody:createEdgeBox({width=100,height=screen_y*2},cc.PhysicsMaterial(100,1,100),3))
    left_body:getPhysicsBody():setDynamic(false)
    left_body:setPosition(-50,screen_y/2)
    right_body:setPhysicsBody(cc.PhysicsBody:createEdgeBox({width=100,height=screen_y*2},cc.PhysicsMaterial(100,1,100),3))
    right_body:setPosition(50+screen_x,screen_y/2)
    right_body:getPhysicsBody():setDynamic(false)
    scene:addChild(left_body)
    scene:addChild(right_body)

    scene:getPhysicsWorld():setGravity(cc.p(0,-screen_x*2))
end


function GameScene.create()
    local bg=require("background")    
    local scene = GameScene.new()
    scene:addChild(bg,-10)
    --scene:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    local cover=require("cover")
    local score=require("score")
    local ob_layer=cc.Layer:create()
--    scene.ob_layer=ob_layer
--    scene:addChild(ob_layer)
    --local setting=cc.Sprite:create("setting.png")
    local setting=cc.ControlButton:create()
    local score_x,score_y=screen_x/2,screen_y*14/15
    score:setPosition(score_x,score_y)
    scene:addChild(score,10)
    
    local function onTouch(eventType, x, y)

        if eventType =="began"  then
            return true
        elseif eventType == "moved" then
            return true
        else
            print("miao")
            cover:remove()
            scene:start(bg)
            
            return true
        end
    end
    
    cover:registerScriptTouchHandler(onTouch)
    cover:setTouchEnabled(true)
    scene:addChild(cover,10)
    
    local mvp=require("mvp.lua")
    scene:addChild(mvp,11)
    mvp:setPosition(screen_x/2,screen_y/4)
   
    scene.mvp=mvp
    
    --mvp.shield_node:setRotation(-90)
    

         

    --button1

    local open_btn=cc.ControlButton:create()
    local btn_sprite=cc.Sprite:create("setting.png")
    btn_sprite:getTexture():setAntiAliasTexParameters()
    btn_sprite:setScale(0.3*screen_scale)

    open_btn:setTitleLabelForState(btn_sprite,cc.CONTROL_STATE_NORMAL)
    open_btn:registerControlEventHandler(function()print("down")end,cc.CONTROL_EVENTTYPE_TOUCH_UP_INSIDE)
    open_btn:setPosition(screen_x*0.90,score_y)
    scene:addChild(open_btn,11)

--    <span style="background-color:#E53333;">he crazy ones. The </span>misf
--    local root=ccui.RichText:create()
--    local re1 = ccui.RichElementText:create( 1, cc.c3b(255, 255, 255), 255, "This coloite. ", "Helvetica", 20 )
--    local re2 = ccui.RichElementText:create( 2, cc.c3b(0, 255, 255), 255, "This colite. ", "Helvetica", 20 )
--    
--    root:pushBackElement(re1)
--    root:pushBackElement(re2)
--    root:ignoreContentAdaptWithSize(false) 
--    root:setContentSize(cc.size(100, 100))  
--    scene:addChild(root)
--    root:setPosition(200,200)
--    ccui.RichText:create():removeElement(ccui.RichElement)

    
    

    return scene
end

return GameScene
