PCB_WIDTH = 58.8;
PCB_HEIGHT = 39.1;
PGB_THICKNESS = 1.6;
PCB_STANDOFF = 2.4;

PCB_BOLT_HOLE_OFFSET = 2;

BOX_WIDTH = PCB_WIDTH + 4;
BOX_HEIGHT = PCB_HEIGHT + 4;
BOX_BASE_DEPTH = 2;

NUT_TRAP_WIDTH = 4;
NUT_TRAP_HEIGHT = 4.4;
NUT_TRAP_DEPTH = 2;

WALL_HEIGHT = 24;


// PCB for reference
%translate([0, 0, BOX_BASE_DEPTH/2 + NUT_TRAP_DEPTH + PCB_STANDOFF + PGB_THICKNESS/2]) {
    cube([PCB_WIDTH, PCB_HEIGHT, PGB_THICKNESS], center = true);
}


module nut_trap() {
    translate([
        PCB_WIDTH/2 - NUT_TRAP_WIDTH/2 - PCB_BOLT_HOLE_OFFSET,
        PCB_HEIGHT/2 - NUT_TRAP_HEIGHT/2 - PCB_BOLT_HOLE_OFFSET,
        BOX_BASE_DEPTH/2
    ]) {

        difference() {
            translate([-2, -2, 0]) {
                cube([NUT_TRAP_WIDTH + 4, NUT_TRAP_HEIGHT + 4, NUT_TRAP_DEPTH + PCB_STANDOFF], center = false);
            }
            // Hole for bolt
            translate([NUT_TRAP_WIDTH/2, NUT_TRAP_HEIGHT/2, 0]) {
                cylinder(h = NUT_TRAP_DEPTH + PCB_STANDOFF + 1, r = 1, center = false);
            }
            // nut trap box cut out
            cube([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT, NUT_TRAP_DEPTH], center = false);
        }
    };
}

// Base
cube([BOX_WIDTH, BOX_HEIGHT, BOX_BASE_DEPTH], center = true);

// Walls
mirrorCopy([0, 1, 0]) {
    translate([-BOX_WIDTH/2, BOX_HEIGHT/2, -BOX_BASE_DEPTH/2]) {
        cube([BOX_WIDTH, 2, WALL_HEIGHT], center = false);
    }
}

corners() {
    nut_trap();
}

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
