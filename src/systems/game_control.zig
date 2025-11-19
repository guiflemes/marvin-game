const ecs = @import("ecs");
const components = @import("../components/components.zig");
const rl = @import("raylib");
const std = @import("std");
const events = @import("../events/events.zig");

const Dispatcher = events.dispatcher.Dispatcher(100);

pub const GameControlContext = struct {
    registry: *ecs.Registry,
    dispatcher: *Dispatcher,
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
