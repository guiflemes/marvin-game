const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const core = @import("../core.zig");
const world = @import("../world/world.zig");
const components = @import("../components/components.zig");

const Position = components.Position;
const PlayerTag = components.PlayerTag;
const GridPosition = components.GridPosition;
const IntentMoviment = components.IntentMovement;
const Transition = core.Transition;

pub const MovementContext = struct {
    registry: *ecs.Registry,
    delta: i64,
};

pub fn MovementSystem(ctx: *const MovementContext) void {
    var manager = ctx.registry.singletons().getConst(world.WorldManager);
    const map = manager.get_active_map();

    var view = ctx.registry.view(.{ GridPosition, IntentMoviment }, .{});
    var iter = view.entityIterator();

    while (iter.next()) |entt| {
        const pos = view.get(GridPosition, entt);
        var int = view.get(IntentMoviment, entt);

        if (int.y != 0 or int.x != 0) {
            const movx = pos.x + int.x;
            const movy = pos.y + int.y;
            std.debug.print("moviment to x={d} y={d}", .{ movx, movy });

            if (!map.is_obstacle(movy, movx)) {
                pos.*.y = movy;
                pos.*.x = movx;
            }
        }

        int.reset();
    }
}
