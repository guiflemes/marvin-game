const std = @import("std");
const rl = @import("raylib");
const core = @import("../core.zig");
const ecs = @import("ecs");
const components = @import("../components/components.zig");
const world = @import("../world/world.zig");

const Renderable = components.Renderable;
const GridPosition = components.GridPosition;

pub const RenderContext = struct {
    registry: *ecs.Registry,
};

// TODO entities rendering are still depending on tile map, change it
pub fn RenderSystem(ctx: *const RenderContext) void {
    rl.beginDrawing();
    rl.clearBackground(rl.Color.black);
    defer rl.endDrawing();

    const origin = rl.Vector2{ .x = 0, .y = 0 };

    var map_manager = ctx.registry.singletons().getConst(world.WorldManager);

    map_manager.get_active_map().draw(origin);

    var view = ctx.registry.view(.{ GridPosition, Renderable }, .{});
    var iter = view.entityIterator();

    while (iter.next()) |entt| {
        const pos = view.getConst(GridPosition, entt);
        const rend = view.getConst(Renderable, entt);
        const screenPos = rl.Vector2{ .x = origin.x + pos.x * core.TILE_SIZE, .y = origin.y + pos.y * core.TILE_SIZE };
        rend.render(screenPos);
    }
}
