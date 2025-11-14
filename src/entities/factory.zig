const std = @import("std");
const ecs = @import("ecs");
const rl = @import("raylib");
const components = @import("../components/components.zig");
const core = @import("../core.zig");
const map_resource = @import("../resources/map_layouts.zig");
const world = @import("../world/world.zig");

pub const EntityContext = struct {
    font: core.Font,
    registry: *ecs.Registry,
};

pub fn create_entities(ctx: EntityContext) void {
    create_player(ctx);

    // TODO move that for create singleton func
    ctx.registry.singletons().add(components.IntentControl{ .exit = false, .pause = false });
}

pub fn DrawText(pos: rl.Vector2, color: rl.Color, font: core.Font, data: *const anyopaque) void {
    _ = data;
    rl.drawTextEx(font.raylibFont, "@", pos, font.size, 0, color);
}

pub fn create_player(ctx: EntityContext) void {
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
