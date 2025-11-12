const rl = @import("raylib");
const core = @import("../core.zig");
const ecs = @import("ecs");
const std = @import("std");
const position = @import("./position.zig");
const render = @import("./render.zig");
const combat = @import("./combat.zig");

const Allocator = std.mem.Allocator;

// TAGS
pub const PlayerTag = struct {};
pub const EnemyTag = struct {};
pub const ActiveMapTag = struct {};

// POSITIONS
pub const Position = position.Position;
pub const GridPosition = position.GridPosition;
pub const IntentMovement = position.IntentMovement;

// RENDERS
pub const Renderable = render.Renderable;

// COMBAT
pub const Attack = combat.Attack;
pub const Health = combat.Health;

// MAP

pub fn DrawText(pos: rl.Vector2, color: rl.Color, font: core.Font, data: *const anyopaque) void {
    _ = data;
    rl.drawTextEx(font.raylibFont, "@", pos, font.size, 0, color);
}
