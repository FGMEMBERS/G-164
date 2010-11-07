##############
# Insecticid #
##############
var capacity = 0.01;  # 1/10 * lb / kt
var insecticidRelease = func {
    if getprop("/controls/armament/trigger") {
	var weight = getprop("/payload/weight[1]/weight-lb");
	if (weight > 0) {
	    var velocity = getprop("/velocities/airspeed-kt");
	    weight = weight - capacity * velocity;
	    setprop("/payload/weight[1]/weight-lb", weight);
	    settimer(insecticidRelease, 0.1);
	}
    }
}

setlistener("/controls/armament/trigger", insecticidRelease);

###########
# Starter #
###########

var starter = func(value) {
	if (value == 1) {
		setprop("/controls/switches/starter", 1);
		if (getprop("/controls/electric/battery-switch")) {
			if (getprop("/engines/engine[0]/running") != 1) {
				setprop("/fdm/jsbsim/propulsion/engine/mixture-mod", 1);
				setprop("/fdm/jsbsim/fcs/mixture-mod-cmd-norm", 0);
				interpolate("/fdm/jsbsim/fcs/mixture-mod-cmd-norm", getprop("/controls/engines/engine[0]/mixture"), 6);
				settimer(func {
					setprop("/fdm/jsbsim/propulsion/engine/mixture-mod", 0);
				}, 6);
			}
			setprop("/controls/engines/engine[0]/starter", 1);
		}
	} else {
		setprop("/controls/engines/engine[0]/starter", 0);
		setprop("/controls/switches/starter", 0);
	}
}
