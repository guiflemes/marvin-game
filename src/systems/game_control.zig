const std = @import("std");
const ecs = @import("ecs");
const context = @import("../core/ctx.zig");
const components = @import("../components/components.zig");
const events = @import("../events/events.zig");

pub const GameControlContext = struct {
    registry: *ecs.Registry,
    event_bus: *events.EventBus,
};

pub fn GameControlSystem(ctx: *GameControlContext) void {
    const intent = ctx.registry.singletons().get(components.IntentControl);

    if (intent.exit) {
        std.debug.print("Game Exit\n", .{});
        var exit = events.Exit{};
        ctx.event_bus.emit(&exit);
    }

    if (intent.pause) {
        std.debug.print("Game Paused\n", .{});
    }
}
