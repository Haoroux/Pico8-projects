pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--space shooter
function _init()
	p={x=60,y=60,speed=2}
	bullets={}
	enemies={}
	create_stars()
	spawn_enemies()
end

function _update60()
	if btn(➡️)then p.x+=p.speed end
	if btn(⬅️)then p.x-=p.speed end
	if btn(⬇️)then p.y+=p.speed end
	if btn(⬆️)then p.y-=p.speed end
	if btnp(❎)then shoot() end
	update_bullets()
	update_stars()
	update_enemies()
end

function _draw()
 cls()
 --stars
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
 --vaisseau
	spr(1,p.x,p.y)
	--enemies
	for e in all(enemies) do
		spr(3,e.x,e.y)		
	end
	--bullets
	for b in all(bullets) do
		spr(2,b.x,b.y)
	end
end

-->8
--bullets
function shoot()
	new_bullet={
		x=p.x,
		y=p.y,
		speed=4
	}
	add(bullets,new_bullet)
	sfx(0)
end

function update_bullets()
	for b in all(bullets) do
		b.y-=b.speed
	end
end

-->8
--stars

function create_stars()
	stars={}
	for s=1,20 do
		new_star={
			x=rnd(128),
			y=rnd(128),
			col=rnd({12,13,5,2,10,14,15}),
			speed=rnd({4,3,2,1})
		}
		add(stars,new_star)
	end
end

function update_stars()
	for s in all(stars) do
		s.y+=s.speed
		if s.y > 120 then
			s.y=0
			s.x=rnd(128)
		end
	end
end
-->8
--enemies

function spawn_enemies()
	new_enemy={
		x=rnd(128),
		y=-8,
		life=4,
		speed=1
	}
	add(enemies,new_enemy)
end

function update_enemies()
	for e in all(enemies) do
		e.y+=e.speed
		if e.y>128 then
			e.y=-8
			e.x=rnd(128)
		end
	end
end
__gfx__
00000000000000000070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000060060000c00c000bb00bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000060060000c00c0000b33b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700006dc7d600010010003bbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700006dccd6000000000038bb830000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700d66dd66d00100100003bb300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d666666d0000000002033020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050dd0500000000000e00e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002a0502b05029050280402504020030150300e03009030060300602008020080200402000020000002670028700297002a7002b7002b7002b7002b7002a6002b7002b7002c70000000000000000000000
