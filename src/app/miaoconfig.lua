
main_scene=nil
screen_width,screen_height=cc.Director:getInstance():getVisibleSize().width,cc.Director:getInstance():getVisibleSize().height
screen_x=screen_width
screen_y=screen_height
sx=screen_x
sy=screen_y

screen_scale=screen_width/640
ss=screen_scale
shadow_delta=10*ss
shadow_color=cc.c4f(0,0,0,0.5)
print(screen_scale)
color_pre={
    cc.c4f(74/255,184/255,255/255,1),
    cc.c4f(201/255,176/255,232/255,1),
    cc.c4f(255/255,87/255,89/255,1),
    cc.c4f(232/255,177/255,103/255,1),
    cc.c4f(255/255,251/255,74/255,1),
}
function random_color()
    return color_pre[math.random(1,5)]
end
down_rate=400*screen_scale
ob_m=cc.PhysicsMaterial(100,0,100)