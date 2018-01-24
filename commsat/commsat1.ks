parameter orbitAngle.
clearscreen.

lock throttle to 1.0.

print "Launch orbit set for an angle of " + orbitAngle.
print "Launch in T-Minus...".

from {local countdown is 5.} until countdown = 0 step {set countdown to countdown -1.} do {
	print "..." + countdown.
	wait 1.
}

set orbitHeading to heading(orbitAngle,90).

lock steering to orbitHeading.

print "LAUNCH!".
stage.
wait 5.

//gravity turn
print "Gravity turn".
until ship:velocity:surface:mag >= 500 and ship:apoapsis >= 80000{
	if 90-(missiontime-5) >= 45{ //we dont want to turn too much...
		gravityTurn(90-(missiontime-5)).
	}else{
		gravityTurn(45).
	}
	
	if ship:velocity:surface:mag >= 500{
		lock throttle to 0.7.
	}else{
		lock throttle to 1.0.
	}
}

//Shot extension
until ship:apoapsis >= 100000{
	wait 0.2.
	set orbitHeading to ship:prograde.
	lock throttle to 0.6.
}

lock throttle to 0.

//Reduce air resistance
set orbitHeading to ship:prograde.
wait until ship:altitude >= 65000.
set orbitHeading to ship:prograde.
wait until ship:altitude >= 70000.

//burn for apoapsis
lock throttle to 1.0.
until ship:apoapsis >= 501000{
	set orbitHeading to ship:prograde.
}
lock throttle to 0.

wait 5.0.
AG1 on. //faring deploy
wait 5.0.
discardBooster(). //drop booster
wait 5.0.

//time warp
print "Warping".
unlock steering.
set kuniverse:timewarp:mode to "RAILS".
kuniverse:timewarp:warpto(time:seconds + eta:apoapsis - 30).
set orbitHeading to ship:prograde.
lock steering to orbitHeading.

wait until eta:apoapsis <= 20.
set orbitHeading to ship:prograde.

//burn for periapsis
until ship:periapsis >= 500000{
	set orbitHeading to ship:prograde.
	if eta:apoapsis <= 15{ //initial within range
		lock throttle to 1.0.
	}else if eta:apoapsis < eta:periapsis{ //pre apoapsis
		lock throttle to 0.0.
	}else if eta:apoapsis > eta:periapsis{ //post apoapsis
		lock throttle to 1.0.
	}
}

//stage
function discardBooster{
	print "Jettisoning booster stage".
	lock throttle to 0.0.
	stage. //jettison booster (activate secondary engine)
	AG2 on. //Deploy antenna + solar panels
}

function gravityTurn{
	parameter pitch.
	set orbitHeading to heading(orbitAngle,pitch).
	print pitch at(13,8).
}
