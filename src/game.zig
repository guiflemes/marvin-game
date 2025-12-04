const std = @import("std");
const rl = @import("raylib");
const ecs = @import("ecs");
const systems = @import("./systems/systems.zig");
const factory = @import("./blueprints/factory.zig");
const world = @import("./world/world.zig");
const events = @import("./events/events.zig");
const font = @import("./core/font.zig");
const context = @import("./core/ctx.zig");
const windows = @import("./core/windows.zig");

pub fn run(allocator: std.mem.Allocator) void {
    const window = windows.WindowConfig{};

    rl.initWindow(window.width, window.height, window.title);
    defer rl.closeWindow();

    rl.setTargetFPS(60);
    rl.initAudioDevice();
    rl.setExitKey(rl.KeyboardKey.null);

    var reg = ecs.Registry.init(allocator);
    defer reg.deinit();

    var bus = events.CreateEventBus(allocator);
    defer bus.deinit();

    var ctx = context.GameContext{
        .allocator = allocator,
        .event_bus = &bus,
        .registry = &reg,
        .state = .none,
        .delta = 0,
        .font = font.Font.init(),
    };

    factory.create_entities(ctx);
    factory.create_singletons(ctx);

    var systemCtx = systems.SystemContext.init(&ctx);

    while (!rl.windowShouldClose()) {
        if (ctx.state == .Exit) break;

        if (ctx.state != .Paused) {
            systems.update(&systemCtx);
            var ev = events.Context{ .state = &ctx.state };
            ctx.event_bus.dispatchAll(&ev);
        }

        systems.draw(&systemCtx.render);
    }

    var manager = ctx.registry.singletons().getConst(world.WorldManager);
    manager.deinit();
}
