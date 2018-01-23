parameter orbitAngle.
clearscreen.

lock throttle to 1.0.
set firstStageTank to ship:partstagged("FirstStageTank")[0].


print "Launch orbit set for an angle of " + orbitAngle.
print "Launch in T-Minus...".

from {local countdown is 5.} until countdown = 0 step {set countdown to countdown -1.} do {
	print "..." + countdown.
	wait 1.
}

set orbitHeading to heading(orbitAngle,90).

lock steering to orbitHeading.

print("LAUNCH!").
stage.
wait 5.

//gravity turn
until ship:velocity:surface:mag >= 900 and ship:apoapsis >= 80000{
	if 90-MISSIONTIME >= 45{ //we dont want to turn too much...
		gravityTurn(90-MISSIONTIME).
	}else{
		gravityTurn(45).
	}
}

//Shot extension
lock throttle to 0.9.
gravityTurn(30).
wait 0.5.
lock throttle to 0.7.
gravityTurn(20).
lock throttle to 0.6.
wait until ship:apoapsis >= 100000.
lock throttle to 0.

//Reduce air resistance
set orbitHeading to ship:prograde.
wait until ship:altitude >= 70000.

//burn for apoapsis
set orbitHeading to ship:prograde.
lock throttle to 1.0.
wait until ship:apoapsis >= 500000.

AG1 on. //faring deploy

//burn for periapsis
until ship:periapsis >= 500000{
	set orbitHeading to ship:prograde.
	if eta:apoapsis <= 2{ //if within range
		lock throttle to 1.0.
	}else{
		lock throttle to 0.0.
	}
}

//stage
when ship:periapsis >= 62000 then{
	print "Jettisoning booster stage".
	lock throttle to 0.0.
	stage. //jettison booster (activate secondary engine)
	AG2 on. //Deploy antenna + solar panels
}

function gravityTurn{
	parameter pitch.
	set orbitHeading to heading(orbitAngle,pitch).
	print "Pitching " + pitch at(10,7).
}
