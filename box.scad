BOX_WIDTH = 30;
BOX_HEIGHT = 20;
BOX_BASE_DEPTH = 2;

NUT_TRAP_WIDTH = 4;
NUT_TRAP_HEIGHT = 4;

cube([BOX_WIDTH, BOX_HEIGHT, BOX_BASE_DEPTH], center = true);

module nut_trap() {
    translate([
        BOX_WIDTH/2 - NUT_TRAP_WIDTH,
        BOX_HEIGHT/2 - NUT_TRAP_HEIGHT,
        BOX_BASE_DEPTH/2
    ]) {
        cube([NUT_TRAP_WIDTH, NUT_TRAP_HEIGHT, 2], center = false);
    };
}

nut_trap();
mirror([1,0,0]) {
    nut_trap();
}


module corners() {
    children()
    mirror([0
}