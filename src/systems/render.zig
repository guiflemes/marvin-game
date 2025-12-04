const std = @import("std");
const rl = @import("raylib");
const ecs = @import("ecs");
const components = @import("../components/components.zig");
const world_mod = @import("../world/world.zig");

const Renderable = components.Renderable;
const GridPosition = components.GridPosition;

pub const RenderContext = struct {
    registry: *ecs.Registry,
};

pub fn RenderSystem(ctx: *RenderContext) void {
    rl.beginDrawing();
    rl.clearBackground(rl.Color.black);
    defer rl.endDrawing();

    var world_manager = ctx.registry.singletons().getConst(world_mod.WorldManager);
    var world = world_manager.get_active_world();

    const world_size = world.get_size();
    const screen_w = @as(f32, @floatFromInt(rl.getScreenWidth()));
    const screen_h = @as(f32, @floatFromInt(rl.getScreenHeight()));

    const origin = rl.Vector2{
        .x = (screen_w - world_size.x) / 2,
        .y = (screen_h - world_size.y) / 2,
    };

    world.draw(origin);

    var view = ctx.registry.view(.{ GridPosition, Renderable }, .{});
    var iter = view.entityIterator();

    while (iter.next()) |entt| {
        const pos = view.getConst(GridPosition, entt);
        const rend = view.getConst(Renderable, entt);
        const world_pos = rl.Vector2{ .x = pos.x, .y = pos.y };
        const screen_pos = rl.Vector2{
            .x = origin.x + world.world_to_screen(world_pos).x,
            .y = origin.y + world.world_to_screen(world_pos).y,
        };
        rend.render(screen_pos);
    }
}
