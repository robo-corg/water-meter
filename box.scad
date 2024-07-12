$fn = 100;

PCB_WIDTH = 60;
PCB_HEIGHT = 40;
PGB_THICKNESS = 1.6;
PCB_STANDOFF = 2.4;

PCB_BOLT_HOLE_OFFSET = 2;

USB_LEFT_OFFSET = 7.5;
USB_C_HEIGHT = 3.5;
USB_C_WIDTH = 9;

JST_WIDTH = 15;
JST_HEIGHT = 6;

BOLT_DIAMETER = 2 + 0.4;

NUT_TRAP_WIDTH = 4;
NUT_TRAP_HEIGHT = 4.4;
NUT_TRAP_DEPTH = 2;
NUT_TRAP_HOUSING_WIDTH = 2;
NUT_TRAP_HOUSING_HEIGHT = 2;
TOTAL_NUT_TRAP_WIDTH = (NUT_TRAP_WIDTH + NUT_TRAP_HOUSING_WIDTH*2);
TOTAL_NUT_TRAP_HEIGHT = (NUT_TRAP_HEIGHT + NUT_TRAP_HOUSING_HEIGHT*2);

// Box dimensions flex to accomidate the nut trap and its housing. This way PCB_BOLT_HOLE_OFFSET can be used to center the nut trap
// around the bolt holes on the PCB
BOX_WIDTH = PCB_WIDTH + max(4, NUT_TRAP_WIDTH + NUT_TRAP_HOUSING_WIDTH*2 - PCB_BOLT_HOLE_OFFSET*2);
BOX_HEIGHT = PCB_HEIGHT + max(4, NUT_TRAP_HEIGHT + NUT_TRAP_HOUSING_HEIGHT*2 - PCB_BOLT_HOLE_OFFSET*2);
BOX_BASE_DEPTH = 2;


WALL_HEIGHT = PGB_THICKNESS + PCB_STANDOFF + BOX_BASE_DEPTH + 24;

DEBUG_NUT_TRAP = false;


// PCB for reference
%translate([0, 0, BOX_BASE_DEPTH/2 + NUT_TRAP_DEPTH + PCB_STANDOFF + PGB_THICKNESS/2]) {
    color("green", 0.2)
    cube([PCB_WIDTH, PCB_HEIGHT, PGB_THICKNESS], center = true);
}

%translate([PCB_WIDTH/2 - 2, TOTAL_NUT_TRAP_HEIGHT -BOX_HEIGHT/2 - 0.5 + USB_LEFT_OFFSET, 21 - USB_C_HEIGHT/2]) {
    color("blue", 0.2)
    cube([2, USB_C_WIDTH, USB_C_HEIGHT], center = false);
}

main_enclosure();

// Side plate with esp32 usb-c
difference() {
    side_plate();
    translate([PCB_WIDTH/2+1, TOTAL_NUT_TRAP_HEIGHT -BOX_HEIGHT/2 - 0.5 + USB_LEFT_OFFSET - 2, 21 - USB_C_HEIGHT/2 - 2]) {
        cube([6, USB_C_WIDTH + 4, USB_C_HEIGHT + 4], center = false);
    };
}

// Side plate with water sensor JST port
*mirror([1, 0, 0])
difference() {
    side_plate();
    translate([PCB_WIDTH/2+1, -(JST_WIDTH + 4)/2, PCB_STANDOFF + BOX_BASE_DEPTH/2]) {
        cube([6, JST_WIDTH + 4, JST_HEIGHT + 4], center = false);
    };
}

!top();

// TOP
module top() {
    color("red")
    translate([0, 0, WALL_HEIGHT ])
    difference() {
        cube([BOX_WIDTH + 4, BOX_HEIGHT + 4, BOX_BASE_DEPTH], center = true);
        cylinder(h = BOX_BASE_DEPTH + 2, d = 5.5, center = true);
    }

    // side mounting ears
    mirrorCopy([1, 0, 0]) {
        mirrorCopy([0, 1, 0]) {
            translate([-BOX_WIDTH/2, 0, 0]) {
                rotate([0, 90, 0]) {
                    rotate([0, 0, 90]) {
                        translate([-BOX_HEIGHT/2, WALL_HEIGHT - TOTAL_NUT_TRAP_HEIGHT - BOX_BASE_DEPTH/2, NUT_TRAP_DEPTH + 4]) {
                            difference() {
                                translate([0, 0, 0]) {
                                    cube([TOTAL_NUT_TRAP_WIDTH, TOTAL_NUT_TRAP_HEIGHT, NUT_TRAP_DEPTH + 4], center = false);
                                }
                                translate([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT, -0.1]) {
                                    cylinder(h = NUT_TRAP_DEPTH + PCB_STANDOFF + 1, d = BOLT_DIAMETER, center = false);
                                }
                                translate([NUT_TRAP_HOUSING_WIDTH, NUT_TRAP_HOUSING_HEIGHT, 2]) {
                                    cube([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT + 3, NUT_TRAP_DEPTH], center = false);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

module side_plate() {
    difference() {
        translate([BOX_WIDTH/2, -BOX_HEIGHT/2 - 2, -BOX_BASE_DEPTH/2]) {
            cube([2, BOX_HEIGHT + 4, WALL_HEIGHT], center = false);
        }

        mirrorCopy([0, 1, ]) {
            translate([BOX_WIDTH/2, 0, 0]) {
                rotate([0, 90, 0]) {
                    rotate([0, 0, 90]) {
                        translate([-BOX_HEIGHT/2, WALL_HEIGHT - TOTAL_NUT_TRAP_HEIGHT - BOX_BASE_DEPTH/2, 0]) {
                            translate([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT, -0.1]) {
                                cylinder(h = NUT_TRAP_DEPTH + PCB_STANDOFF + 1, d = BOLT_DIAMETER, center = false);
                            }
                        }
                    }
                }
            }
        }
    }
}

module nut_trap_cutout() {
    // Hole for bolt
    translate([NUT_TRAP_WIDTH/2, NUT_TRAP_HEIGHT/2, 0]) {
        cylinder(h = NUT_TRAP_DEPTH + PCB_STANDOFF + 1, d = BOLT_DIAMETER, center = false);
    }
    // nut trap box cut out
    cube([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT, NUT_TRAP_DEPTH], center = false);
}

module nut_trap() {
    translate([
        PCB_WIDTH/2 - NUT_TRAP_WIDTH/2 - PCB_BOLT_HOLE_OFFSET,
        PCB_HEIGHT/2 - NUT_TRAP_HEIGHT/2 - PCB_BOLT_HOLE_OFFSET,
        BOX_BASE_DEPTH/2
    ]) {
        if (DEBUG_NUT_TRAP) {
            #nut_trap_cutout();
        }
        else {
            difference() {
                translate([-NUT_TRAP_HOUSING_WIDTH, -NUT_TRAP_HOUSING_HEIGHT, 0]) {
                    cube([NUT_TRAP_WIDTH + NUT_TRAP_HOUSING_WIDTH*2, NUT_TRAP_HEIGHT + NUT_TRAP_HOUSING_HEIGHT*2, NUT_TRAP_DEPTH + PCB_STANDOFF], center = false);
                }
                nut_trap_cutout();
            }
        }
    };
}

module main_enclosure() {
    // Base
    cube([BOX_WIDTH, BOX_HEIGHT, BOX_BASE_DEPTH], center = true);

    // Walls
    mirrorCopy([0, 1, 0]) {
        translate([-BOX_WIDTH/2, BOX_HEIGHT/2, -BOX_BASE_DEPTH/2]) {
            cube([BOX_WIDTH, 2, WALL_HEIGHT], center = false);
        }
    }



    BEVEL_HEIGHT = min(TOTAL_NUT_TRAP_HEIGHT, TOTAL_NUT_TRAP_WIDTH);

    // side mounting ears
    mirrorCopy([1, 0, 0]) {
        mirrorCopy([0, 1, 0]) {
            translate([-BOX_WIDTH/2, 0, 0]) {
                rotate([0, 90, 0]) {
                    rotate([0, 0, 90]) {
                        translate([-BOX_HEIGHT/2, WALL_HEIGHT - TOTAL_NUT_TRAP_HEIGHT - BOX_BASE_DEPTH/2, 0]) {
                            difference() {
                                translate([0, 0, 0]) {
                                    cube([TOTAL_NUT_TRAP_WIDTH, TOTAL_NUT_TRAP_HEIGHT, NUT_TRAP_DEPTH + 4], center = false);
                                }
                                translate([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT, -0.1]) {
                                    cylinder(h = NUT_TRAP_DEPTH + PCB_STANDOFF + 1, d = BOLT_DIAMETER, center = false);
                                }
                                translate([NUT_TRAP_HOUSING_WIDTH, NUT_TRAP_HOUSING_HEIGHT, 2]) {
                                    cube([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT + 3, NUT_TRAP_DEPTH], center = false);
                                }
                            }
                            // Beveled support for the nut trap
                            translate([0, -BEVEL_HEIGHT, 0]) {
                                polyhedron(points = [
                                    [0, BEVEL_HEIGHT, 0],
                                    [TOTAL_NUT_TRAP_WIDTH, BEVEL_HEIGHT, 0],
                                    [TOTAL_NUT_TRAP_WIDTH, BEVEL_HEIGHT, NUT_TRAP_DEPTH + 4],
                                    [0, BEVEL_HEIGHT, NUT_TRAP_DEPTH + 4],
                                    [0, 0, 0],
                                    [0, 0, NUT_TRAP_DEPTH + 4],
                                ], faces = [
                                    [2, 1, 4, 5],
                                    [1, 0, 4],
                                    [2, 5, 3],
                                    [0, 1, 2, 3],
                                    [3, 5, 4, 0]
                                ]);
                            }
                        }
                    }
                }
            }
        }
    }

    corners() {
        nut_trap();
    }
}



// Utility functions

module mirrorCopy(m) {
    children();
    mirror(m) {
        children();
    }
}

module corners() {
    children();
    mirror([1, 0, 0]) {
        children();
    }
    mirror([0, 1, 0]) {
        children();
        mirror([1, 0, 0]) {
            children();
        }
    }
}
