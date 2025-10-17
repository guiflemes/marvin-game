const std = @import("std");
const rl = @import("raylib");
const ecs = @import("ecs");
const state = @import("state_manager.zig");
const systems = @import("systems.zig");
const world = @import("world.zig");
const renderer = @import("renderer.zig");

const Allocator = std.mem.Allocator;

pub const GameRunner = struct {
    renderer: renderer.Renderer,
    allocator: Allocator,
    registry: ecs.Registry,
    world: *world.World,
    state_manager: *state.StateManager,

    pub fn init(allocator: Allocator) *GameRunner {
        var runner = allocator.create(GameRunner) catch @panic("Could not allocate GameRunner");

        runner.* = GameRunner{
            .allocator = allocator,
            .registry = ecs.Registry.init(allocator),
            .world = undefined,
            .state_manager = undefined,
            .renderer = undefined,
        };

        runner.world = world.World.init(&runner.registry);
        runner.state_manager = state.StateManager.init(&runner.registry);
        runner.renderer = renderer.Renderer.init(&runner.registry);
        return runner;
    }

    pub fn deinit(self: *GameRunner) void {
        self.state_manager.destroy();
        self.world.destroy();
        self.registry.deinit();

        self.allocator.destroy(self);
    }

    pub fn startUp(self: *GameRunner) void {
        self.state_manager.load();
        self.world.load();
        rl.initAudioDevice();
    }

    pub fn shutDown(self: *GameRunner) void {
        self.deinit();
    }

    pub fn update(self: *GameRunner) void {
        const currentState = self.state_manager.currentState();
        currentState.update();
    }

    pub fn shouldExit(self: *GameRunner) bool {
        _ = self;
        return rl.isKeyPressed(rl.KeyboardKey.escape);
    }

    pub fn draw(self: *GameRunner) void {
        self.renderer.drawFrame();
        defer self.renderer.endFrame();
    }
};
