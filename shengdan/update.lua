function update_menu()
    blinkt+=1
	input_menu()
    giftpackage.count=0
    gametime=0
    ui_c=0
end

function update_game()
    gametime+=0.01
    --检测游戏是否结束
    if #giftpackage.gifts_t>=30 or gametime>=35 then
        if #giftpackage.gifts_t>=30 then
            sfx(3)
        elseif gametime>35 then
            sfx(4)
        end
        _upd=update_end
        _dra=draw_end
        music(0)
    end

    if #giftpackage.gifts_t>1 and #giftpackage.gifts_t<=5 then
        ui_c=2
    elseif #giftpackage.gifts_t>5 and #giftpackage.gifts_t<=10 then
        ui_c=3
    elseif #giftpackage.gifts_t>10 and #giftpackage.gifts_t<=15 then
        ui_c=4
    elseif #giftpackage.gifts_t>15 and #giftpackage.gifts_t<=20 then
        ui_c=9
    elseif #giftpackage.gifts_t>20 then
        ui_c=10
    end
    -- 11  10,  9,   4,    8
    -- 1   10   18  25   30
    if gametime>1 and gametime<=15 then
        time_c=11
    elseif gametime>15 and gametime<=20 then
        time_c=10
    elseif gametime>20 and gametime<=24 then
        time_c=9
    elseif gametime>24 and gametime<=28 then
        time_c=4
    elseif gametime>28 then
        time_c=8
    end
    --生成礼物
    if #gifts<8 then
        local g={
            x=5+rnd(100),
            y=-rnd(40),
            long=max(20,flr(rnd(30))),
            spr=rnd(gifts_spr_t),
            spd=rnd(0.3)+0.02,
            c=rnd(qiqiu_c),
            mode="down",
            expspr_t=0,--爆炸动画计时 
            trans_num=0,--搬运礼物数量
            } 
            
        add(gifts,g)
    end
    if p.state!=p.allstate.shoot then
        input_game()
    end
    inbounds(p)
    playerstate()
    qiestate()
    for b in all(bullets) do
        b.y-=b.spd
        if b.y<0 then
            del(bullets,b)
        end
    end
    --雪花移动
    for s in all(snow) do
        s.y+=s.spd
        s.x+=sin(time()*s.w)/5
        if s.y>140 then
            s.y=-8
            s.x=rnd(128)
        end
    end
    --烟雾移动
    for s in all(smooke) do
        s.y-=0.1
        if s.y<100 then
            s.r+=0.02
        end
        -- 使用粒子自身的角度实现平滑移动，并缓慢改变角度
        s.x+=cos(s.angle)/5
        s.angle += 0.05 -- 缓慢改变角度，创造自然飘动效果
        if s.y<100 and s.y>=95 then
            s.frame=2
        elseif s.y<95 and s.y>=90 then
            s.frame=3
        elseif s.y<90 and s.y>=85 then
            s.frame=4
        elseif s.y<85 then
            if s.frame==4 then
                s.frame=1
            end
            s.y=105
            s.r=1
            s.angle=rnd(3.14*2) -- 重置角度
        end
    end
    --礼物
    for g in all(gifts) do
        giftsmove(g)
        for b in all(bullets) do
            if shootdown(b,g) then
                g.mode="fall"
                sfx(6)
            end
        end
        --如果在地面上
        if g.y>118 then
            add(gifts_ground,g)
            del(gifts,g)
        end
    end

     --玩家搬运礼物
    --*把硬编码的玩家搬运礼物绘制位置改为动态计算，设置g.x和g.y的值，然后绘制搬运的组
    for i=1,#gifts_trans do
        local x=p.x+3
        local g=gifts_trans[i]
        if p.last_dire==1 then
            x=p.x-1
        else
            x=p.x+6
        end
        g.x=x
        g.y=p.y+8-i*4
        --spr(g.spr,x,p.y+8-i*4)
    end
    --企鹅搬运的礼物显示
    if qie.state==qie.allstate.trans then
        for i=1,#qie.trans_gifts_table do
            local g=qie.trans_gifts_table[i]
            if qie.dire==5 then
                g.x=qie.x-1
            elseif qie.dire==1 then
                g.x=qie.x+6
            end
            g.y=qie.y-i*4
        end
    end

    --企鹅偷礼物
    if qie.transgifts>0 and #qie.trans_gifts_table<qie.transgifts then
        for i=1,qie.transgifts do
            add(qie.trans_gifts_table,giftpackage.gifts_t[i])
            del(giftpackage.gifts_t,giftpackage.gifts_t[i])
        end
    end
    --
    if qie.state==qie.allstate.fright and #qie.trans_gifts_table>0 then
        for g in all(qie.trans_gifts_table) do 
            g.x=qie.x+(1-flr(rnd(4)))
            g.y=118+flr(rnd(3))
            add(gifts_ground,g)
            del(qie.trans_gifts_table,g)
        end
        qie.transgifts=0
    end
    p.x+=p.spdx
end


function update_end()--游戏结束
    blinkt+=1
    if btnp(2) then
        gamestartset()
        _upd=update_menu
	    _dra=draw_menu
        music(0)
        --gametime=0
    end
end
