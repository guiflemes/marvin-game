const std = @import("std");
const ecs = @import("ecs");
const rl = @import("raylib");
const context = @import("../core/ctx.zig");
const components = @import("../components/components.zig");
const map_resource = @import("../resources/map_layouts.zig");
const world = @import("../world/world.zig");
const tile_map = @import("../world/tile_map.zig");
const f = @import("../core/font.zig");

pub fn create_entities(ctx: context.GameContext) void {
    create_player(ctx);
}

fn DrawText(pos: rl.Vector2, color: rl.Color, font: f.Font, data: *const anyopaque) void {
    _ = data;
    rl.drawTextEx(font.raylibFont, "@", pos, font.size, 0, color);
}

fn create_player(ctx: context.GameContext) void {
    const entity = ctx.registry.create();

    ctx.registry.add(entity, components.IntentMovement{ .x = 0, .y = 0 });
    ctx.registry.add(entity, components.GridPosition{ .x = 2, .y = 2 });
    ctx.registry.add(entity, components.Renderable{
        .font = ctx.font,
        .draw_data = "@",
        .color = rl.Color.yellow,
        .draw_func = DrawText,
    });
    ctx.registry.add(entity, components.PlayerTag{});
}

pub fn create_singletons(ctx: context.GameContext) void {
    create_control_intent(ctx);
    create_world_manager(ctx);
}

fn create_control_intent(ctx: context.GameContext) void {
    ctx.registry.singletons().add(components.IntentControl{ .exit = false, .pause = false });
}

fn create_world_manager(ctx: context.GameContext) void {
    const layout_leve1 = map_resource.LEVEL1;
    var tm = tile_map.TileMap.create(ctx.allocator, layout_leve1[0..], ctx.font) catch @panic("error on map");
    var manager = world.WorldManager.init(ctx.allocator, ctx.registry, ctx.font);
    manager.overall_map = tm.map();
    ctx.registry.singletons().add(manager);
}
