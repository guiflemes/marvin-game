const ecs = @import("ecs");
const components = @import("../components/components.zig");
const world = @import("../world/map.zig");
const std = @import("std");

pub fn canSpawn(registry: *ecs.Registry, map: world.TileMap, x: u32, y: u32) bool {
    if (!map.isGround(y, x)) false;

    var entities = registry.view(.{components.Position}, .{}).entityIterator();

    while (entities.next()) |ent| {
        const pos = registry.get(components.Position, ent);
        if (pos.x == x and pos.y == y) return false;
    }

    return true;
}

pub fn enemySystemSpawn(registry: *ecs.Registry) void {
    var pool = registry.singletons().get(components.EnemyPool);
    const map = registry.singletons().get(world.TileMap);
    var random = std.Random.DefaultPrng.init(@intCast(std.time.timestamp()));

    const num_enemies = 5;
    var spawned = 0;

    while (spawned < num_enemies) {
        const y = random.random().intRangeLessThan(usize, 1, map.height - 1);
        const x = random.random().intRangeLessThan(usize, 1, map.width - 1);

        if (!canSpawn(registry, map, x, y)) continue;

        const e = registry.create();
        registry.add(e, components.EnemyTag{});
        registry.add(e, components.Position{ .x = 3 + @as(i32, spawned), .y = 5 });
        registry.add(e, components.Health{ .current = 10, .max = 10 });
        registry.add(e, components.Attack{ .power = 2 });

        pool.enemies.append(e) catch @panic("error appending enemies");
        spawned += 1;
    }
}
