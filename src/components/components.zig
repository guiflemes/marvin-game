const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const position = @import("./position.zig");
const render = @import("./render.zig");
const combat = @import("./combat.zig");
const control = @import("./control.zig");

const Allocator = std.mem.Allocator;

// TAGS
pub const PlayerTag = struct {};
pub const EnemyTag = struct {};
pub const ActiveMapTag = struct {};

// POSITIONS
pub const GridPosition = position.GridPosition;
pub const IntentMovement = position.IntentMovement;

// RENDERS
pub const Renderable = render.Renderable;

// COMBAT
pub const Attack = combat.Attack;
pub const Health = combat.Health;

// CONTROL
pub const IntentControl = control.IntentControl;
