const std = @import("std");
const rl = @import("raylib");
const types = @import("types.zig");
const map = @import("map.zig");
const font = @import("font.zig");
const Allocator = std.mem.Allocator;
const ArenaAllocator = std.heap.ArenaAllocator;
const ecs = @import("ecs");
const state = @import("state.zig");
const systems = @import("systems.zig");

const consts = @import("const.zig");

const TILE_SIZE = consts.TILE_SIZE;

pub const Renderer = struct {
    pub fn init() Renderer {
        return Renderer{};
    }

    pub fn drawFrame(self: *Renderer) void {
        _ = self;
        rl.beginDrawing();
        rl.clearBackground(rl.Color.black);
    }

    pub fn endDrawing(self: *Renderer) void {
        _ = self;
        rl.endDrawing();
    }
};

pub const GameRunner = struct {
    renderer: Renderer,
    allocator: Allocator,
    registry: ecs.Registry,

    pub fn init(allocator: Allocator) *GameRunner {
        var runner = allocator.create(GameRunner) catch @panic("Could not allocate GameRunner");
        const defaultFont = font.Font.init();

        runner.* = GameRunner{
            .renderer = Renderer.init(),
            .allocator = allocator,
            .registry = ecs.Registry.init(allocator),
        };

        const types_entity = runner.registry.create();
        runner.registry.add(types_entity, types.Position{ .x = 2, .y = 2 });
        runner.registry.add(types_entity, types.Renderable{
            .font = defaultFont,
            .text = "@",
            .color = rl.Color.yellow,
        });
        runner.registry.add(types_entity, types.PlayerTag{});

        runner.registry.singletons().add(map.TileMap{
            .data = map.MapData,
            .font = defaultFont,
        });
        var s = state.Explore.create(allocator, &runner.registry) catch @panic("error allocating state");
        runner.registry.singletons().add(s.state());
        return runner;
    }

    pub fn deinit(self: *GameRunner) void {
        self.registry.singletons().get(state.State).destroy();
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
        const currentState = self.registry.singletons().get(state.State);
        currentState.update();
    }

    pub fn shouldExit(self: *GameRunner) bool {
        _ = self;
        return rl.isKeyPressed(rl.KeyboardKey.escape);
    }

    pub fn draw(self: *GameRunner) void {
        self.renderer.drawFrame();
        defer self.renderer.endDrawing();

        const origin = rl.Vector2{ .x = 0, .y = 0 };
        systems.MapRenderSystem(&self.registry, origin);
        systems.PlayerRenderSystem(&self.registry, origin);
    }
};
