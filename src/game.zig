const std = @import("std");
const rl = @import("raylib");
const ecs = @import("ecs");
const state = @import("./state/manager.zig");
const systems = @import("./systems/systems.zig");
const entity = @import("./entities/factory.zig");
const utils = @import("./utils.zig");
const world = @import("./world/world.zig");
const core = @import("./core.zig");
const Dispatcher = @import("./events/dispatcher.zig").Dispatcher(100);

const Allocator = std.mem.Allocator;

pub const GameRunner = struct {
    allocator: Allocator,
    registry: ecs.Registry,
    dispatcher: *Dispatcher,

    pub fn init(allocator: Allocator, dispatcher: *Dispatcher) *GameRunner {
        var runner = allocator.create(GameRunner) catch @panic("Could not allocate GameRunner");

        runner.* = GameRunner{
            .allocator = allocator,
            .registry = ecs.Registry.init(allocator),
            .dispatcher = dispatcher,
        };

        const font = core.Font.init();

        const entt_ctx = entity.EntityContext{ .registry = &runner.registry, .font = font };
        entity.create_entities(entt_ctx);

        const world_ctx = world.WorldContext{ .allocator = allocator, .registry = &runner.registry, .font = font };
        world.create_world_manager(world_ctx);

        return runner;
    }

    pub fn deinit(self: *GameRunner) void {
        var manager = self.registry.singletons().getConst(world.WorldManager);
        manager.deinit();
        self.registry.deinit();
        self.allocator.destroy(self);
    }

    pub fn startUp(self: *GameRunner) void {
        _ = self;
        rl.initAudioDevice();
    }

    pub fn shutDown(self: *GameRunner) void {
        self.deinit();
    }

    pub fn update(self: *GameRunner) void {
        systems.update(&systems.SystemContext{ .registry = &self.registry, .dispatcher = self.dispatcher });
    }

    pub fn shouldExit(self: *GameRunner) bool {
        _ = self;
        return rl.isKeyPressed(rl.KeyboardKey.escape);
    }
};
