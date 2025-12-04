const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const world_mod = @import("../world/world.zig");
const components = @import("../components/components.zig");

const PlayerTag = components.PlayerTag;
const GridPosition = components.GridPosition;
const IntentMoviment = components.IntentMovement;

pub const MovementContext = struct {
    registry: *ecs.Registry,
    delta: i64,
};

pub fn MovementSystem(ctx: *MovementContext) void {
    var manager = ctx.registry.singletons().getConst(world_mod.WorldManager);
    const world = manager.get_active_world();

    var view = ctx.registry.view(.{ GridPosition, IntentMoviment }, .{});
    var iter = view.entityIterator();

    while (iter.next()) |entt| {
        const pos = view.get(GridPosition, entt);
        var int = view.get(IntentMoviment, entt);

        if (int.y != 0 or int.x != 0) {
            const movx = pos.x + int.x;
            const movy = pos.y + int.y;

            if (!world.is_obstacle(movy, movx)) {
                pos.*.y = movy;
                pos.*.x = movx;
            }
        }

        int.reset();
    }
}
