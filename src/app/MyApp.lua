
require("config")
require("cocos.init")
require("framework.init")
require("app.miaoconfig")
local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("src/app/")
    cc.FileUtils:getInstance():addSearchPath("src/app/scenes/")
    --self:enterScene("MainScene")
    
    local scene = require("game")
    local gameScene = scene:create()


    
    cc.Director:getInstance():setAnimationInterval(1.0/60);
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(gameScene)
    else
        cc.Director:getInstance():runWithScene(gameScene)
    end

    --self:enterScene("game")
end

return MyApp
