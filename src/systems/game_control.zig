const ecs = @import("ecs");
const components = @import("../components/components.zig");
const rl = @import("raylib");
const std = @import("std");

pub fn GameControlSystem(registry: *ecs.Registry) void {
    const intent = registry.singletons().get(components.IntentControl);

    if (intent.exit) {
        std.debug.print("Game Should exit\n", .{});
    }
    if (intent.pause) {
        std.debug.print("Game Paused\n", .{});
    }
}
