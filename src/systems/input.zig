const ecs = @import("ecs");
const components = @import("../components/components.zig");
const rl = @import("raylib");
const std = @import("std");

pub const InputContext = struct {
    registry: *ecs.Registry,
};

pub fn InputSystem(ctx: *const InputContext) void {
    var view = ctx.registry.view(.{ components.PlayerTag, components.IntentMovement }, .{});
    var iter = view.entityIterator();

    while (iter.next()) |entt| {
        var intent = view.get(components.IntentMovement, entt);
        intent.reset();

        if (rl.isKeyPressed(rl.KeyboardKey.right)) {
            intent.right(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.left)) {
            intent.left(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.down)) {
            intent.down(1);
        }

        if (rl.isKeyPressed(rl.KeyboardKey.up)) {
            intent.up(1);
        }
    }
}
