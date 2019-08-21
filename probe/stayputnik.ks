clearscreen.

PARAMETER targetAltitude is 100000.
PARAMETER dispose is true.

// Pre-flight
SET orbitHeading to heading(90,90).
LOCK steering to orbitHeading.
LOCK throttle to 1.0.
LOCAL startAlt is SHIP:ALTITUDE.
LOCAL gravityTurnDegree is (10000-startAlt)/45.

print "Orbital inclination : 90".
print "Target altitude     : " + targetAltitude.
print "Current altitude    : " + FLOOR(startAlt).
print "All pre-launch checks complete.".
print "Launch in T-Minus...".

// Countdown
from {local countdown is 5.} until countdown = 0 step {SET countdown to countdown -1.} do {
	print "..." + countdown.
	wait 1.
}

clearscreen.
stage.
LOCAL pitch is 90.

// Gravity turn
until pitch = 40 { // Until orbital insertion angle
  // 1 degree worth of altitude change is (10000 - startAlt) / 45
  SET pitch to 90 - FLOOR( (SHIP:ALTITUDE - startAlt) / gravityTurnDegree).
  SET orbitHeading to heading(90,pitch).
}

// Staging
wait until STAGE:LIQUIDFUEL < 10.
SET orbitHeading to heading(90,40).
LOCK throttle to 0.5.
wait until STAGE:LIQUIDFUEL = 0.
stage. // Drop initial booster

// Slowly increase throttle to max
LOCAL myThrottle is 0.5.
LOCK throttle to myThrottle.
until myThrottle > 0.99 {
	SET myThrottle to myThrottle + 0.01.
	SET orbitHeading to heading(90,40).
	wait 0.05.
}

// Reaffirm heading and throttle
LOCK throttle to 1.0.
SET orbitHeading to heading(90,40).

// Max apoapsis = 6690000

// Burn for apoapsis
until SHIP:APOAPSIS >= targetAltitude {
	wait 0.2.
	set orbitHeading to ship:prograde.

	if STAGE:LIQUIDFUEL = 0 { // If we have run out of fuel
		wait 0.1.
		AG2 on.
		wait 0.2.
		stage.
		if SHIP:LIQUIDFUEL = 0 {
			print "Where exactly did you think you were going?".
			exit.
		}
	}
}
LOCK throttle to 0.

// Reduce air resistance
until SHIP:ALTITUDE >= 70000 {
	set orbitHeading to ship:prograde.
	wait 0.2.
}
AG2 on. // Faring deploy

// Test for disposal policy
if dispose = true {
	stage.
	wait 2.
	AG1 on. // antenna
}

// Manoeuvre node?
// Time warp to burn
// Burn for periapsis
