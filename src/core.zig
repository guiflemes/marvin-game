pub const MAP_HEIGHT = 20;
pub const MAP_WIDTH = 20;
pub const TILE_SIZE: f32 = 32.0;

pub const Transition = union(enum) {
    none,
    to: StateType,

    pub const StateType = enum {
        Explore,
        Battle,
    };
};
