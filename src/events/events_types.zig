const ecs = @import("ecs");
const rl = @import("raylib");
const context = @import("../core/ctx.zig");

pub const Context = struct { state: *context.State };

pub const Exit = struct {};
