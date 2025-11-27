const ecs = @import("ecs");
const components = @import("../components/components.zig");
const rl = @import("raylib");
const std = @import("std");
const events = @import("../events/events.zig");

pub const GameControlContext = struct {
    registry: *ecs.Registry,
    event_bus: *events.EventBus,
};

pub fn GameControlSystem(ctx: *const GameControlContext) void {
    const intent = ctx.registry.singletons().get(components.IntentControl);

    if (intent.exit) {
        // ctx.event_bus.emit(.Exit);
    }
    if (intent.pause) {
        std.debug.print("Game Paused\n", .{});
    }
}
