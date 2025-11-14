const ecs = @import("ecs");
const components = @import("../components/components.zig");
const rl = @import("raylib");
const std = @import("std");
const Dispatcher = @import("../events/dispatcher.zig").Dispatcher;
const events = @import("../events/events.zig");

pub const GameControlContext = struct {
    registry: *ecs.Registry,
    dispatcher: *Dispatcher(100),
};

pub fn GameControlSystem(ctx: *const GameControlContext) void {
    const intent = ctx.registry.singletons().get(components.IntentControl);

    if (intent.exit) {
        ctx.dispatcher.emit(.Exit);
    }
    if (intent.pause) {
        std.debug.print("Game Paused\n", .{});
    }
}
