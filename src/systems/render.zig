const std = @import("std");
const rl = @import("raylib");
const core = @import("../core.zig");
const ecs = @import("ecs");
const components = @import("../components/components.zig");
const utils = @import("../utils.zig");
const world = @import("../world/world.zig");

const TILE_SIZE = core.TILE_SIZE;

const Position = components.Position;
const Renderable = components.Renderable;
const PlayerTag = components.PlayerTag;
const GridPosition = components.GridPosition;

// depracated - delete it
pub fn PlayerRenderSystem(registry: *ecs.Registry, origin: rl.Vector2) void {
    var view = registry.view(.{ Position, Renderable, PlayerTag }, .{});
    var iter = view.entityIterator();
    while (iter.next()) |e| {
        const pos: Position = view.getConst(Position, e);
        const rend: Renderable = view.getConst(Renderable, e);

        const screenPos = rl.Vector2{ .x = origin.x + pos.x * TILE_SIZE, .y = origin.y + pos.y * TILE_SIZE };
        rl.drawTextEx(rend.font.raylibFont, "@", screenPos, rend.font.size, 0, rend.color);
    }
}

pub fn RenderSystem(registry: *ecs.Registry) void {
    rl.beginDrawing();
    rl.clearBackground(rl.Color.black);
    defer rl.endDrawing();

    const origin = rl.Vector2{ .x = 0, .y = 0 };

    var map_manager = registry.singletons().getConst(world.WorldManager);

    map_manager.get_active_map().draw(origin);

    var view = registry.view(.{ GridPosition, Renderable }, .{});
    var iter = view.entityIterator();

    while (iter.next()) |entt| {
        const pos = view.getConst(GridPosition, entt);
        const rend = view.getConst(Renderable, entt);
        const screenPos = rl.Vector2{ .x = origin.x + pos.x * TILE_SIZE, .y = origin.y + pos.y * TILE_SIZE };
        rend.render(screenPos);
    }
}
