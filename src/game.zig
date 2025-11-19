const std = @import("std");
const rl = @import("raylib");
const ecs = @import("ecs");
const systems = @import("./systems/systems.zig");
const entity = @import("./entities/factory.zig");
const world = @import("./world/world.zig");
const core = @import("./core.zig");
const events = @import("./events/events.zig");

const Allocator = std.mem.Allocator;
const Dispatcher = events.dispatcher.Dispatcher(100);

pub const State = union(enum) {
    Paused,
    Exit,
    none,
};

pub const GameContext = struct {
    allocator: Allocator,
    dispatcher: Dispatcher,
    registry: ecs.Registry,
    state: State,
};

pub fn run(allocator: Allocator) void {
    rl.initWindow(core.MAP_WIDTH * core.TILE_SIZE, core.MAP_HEIGHT * core.TILE_SIZE, "marvin game RPG");
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.initAudioDevice();

    var ctx = GameContext{
        .allocator = allocator,
        .dispatcher = Dispatcher.init(allocator),
        .registry = ecs.Registry.init(allocator),
        .state = .none,
    };

    const font = core.Font.init();
    const entt_ctx = entity.EntityContext{ .registry = &ctx.registry, .font = font };
    entity.create_entities(entt_ctx);

    const world_ctx = world.WorldContext{ .allocator = ctx.allocator, .registry = &ctx.registry, .font = font };
    world.create_world_manager(world_ctx);

    while (!rl.windowShouldClose()) {
        if (ctx.state == .Exit) break;

        if (rl.isKeyPressed(rl.KeyboardKey.escape)) break; // testing, remove it

        if (ctx.state != .Paused) {
            systems.update(&systems.SystemContext{ .registry = &ctx.registry, .dispatcher = &ctx.dispatcher });
        }
    }

    var manager = ctx.registry.singletons().getConst(world.WorldManager);
    manager.deinit();
    ctx.registry.deinit();
}
