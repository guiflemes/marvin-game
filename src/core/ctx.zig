const std = @import("std");
const ecs = @import("ecs");
const events = @import("../events/events.zig");

pub const State = union(enum) {
    Paused,
    Exit,
    none,
};

pub const GameContext = struct {
    allocator: std.mem.Allocator,
    event_bus: *events.EventBus,
    registry: *ecs.Registry,
    state: State,
};

pub fn makeContextChild(comptime ChildCtx: type, parentCtx: GameContext) type {
    var child: ChildCtx = undefined;

    inline for (@typeInfo(ChildCtx).@"struct".fields) |f| {
        if (!@hasField(GameContext, f)) {
            @compileError("missing field on GameContext: " + f.name);
        }
        @field(child, f.name) = @field(parentCtx, f.name);
    }

    return child;
}
