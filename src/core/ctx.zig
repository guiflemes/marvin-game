const std = @import("std");
const ecs = @import("ecs");
const events = @import("../events/events.zig");
const font = @import("../core/font.zig");

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
    delta: i64,
    font: font.Font,
};

pub fn makeContextChild(comptime ChildCtx: type, parentCtx: *GameContext) ChildCtx {
    var child: ChildCtx = undefined;

    inline for (@typeInfo(ChildCtx).@"struct".fields) |f| {
        if (!@hasField(GameContext, f.name)) {
            @compileError(std.fmt.comptimePrint("GameContext missing required field '{s}'", .{f.name}));
        }
        @field(child, f.name) = @field(parentCtx, f.name);
    }

    return child;
}
