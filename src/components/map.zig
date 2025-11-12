const world = @import("../world/map.zig");

pub const Map = struct {
    ptr: *world.TileMap,
    id: u64,
};
