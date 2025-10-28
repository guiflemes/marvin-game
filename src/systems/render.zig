const rl = @import("raylib");
const core = @import("../core.zig");
const ecs = @import("ecs");
const components = @import("../components/components.zig");
const m = @import("../world/map.zig");
const std = @import("std");

const TILE_SIZE = core.TILE_SIZE;

const Position = components.Position;
const Renderable = components.Renderable;
const PlayerTag = components.PlayerTag;

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

pub fn MapRenderSystem(registry: *ecs.Registry, origin: rl.Vector2) void {
    const world = registry.singletons().get(m.TileMap);

    for (0..world.height) |y| {
        for (0..world.width) |x| {
            const tile = world.data[y][x];
            const tileColor = getTileColor(tile);

            const pos = rl.Vector2{
                .x = origin.x + @as(f32, @floatFromInt(x)) * TILE_SIZE + 8.0,
                .y = origin.y + @as(f32, @floatFromInt(y)) * TILE_SIZE + 6.0,
            };

            rl.drawTextEx(world.font.raylibFont, rl.textFormat("%c", .{tile}), pos, world.font.size, 0, tileColor);
        }
    }
}

pub fn getTileColor(tile: u8) rl.Color {
    switch (tile) {
        '#' => return rl.Color.gray,
        '.' => return rl.Color.dark_green,
        '^' => return rl.Color.brown,
        '~' => return rl.Color.blue,
        else => return rl.Color.white,
    }
}
