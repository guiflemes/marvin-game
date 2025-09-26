const std = @import("std");
const rl = @import("raylib");
const player = @import("player.zig");
const map = @import("map.zig");
const font = @import("font.zig");
const Allocator = std.mem.Allocator;
const ArenaAllocator = std.heap.ArenaAllocator;
const ecs = @import("ecs");
const state = @import("state.zig");

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

pub const GameState = enum {
    Exploring,
    Battle,
};

pub const GameRunner = struct {
    renderer: Renderer,
    allocator: Allocator,
    registry: ecs.Registry,
    current_state: GameState,

    pub fn init(allocator: Allocator) *GameRunner {
        var runner = allocator.create(GameRunner) catch @panic("Could not allocate GameRunner");

        const defaultFont = font.Font.init();
        const p = player.Player.init(defaultFont);
        const m = map.Map.init(defaultFont);

        runner.* = GameRunner{
            .renderer = Renderer.init(),
            .allocator = allocator,
            .registry = ecs.Registry.init(allocator),
            .current_state = GameState.Exploring,
        };

        runner.registry.singletons().add(p);
        runner.registry.singletons().add(m);

        return runner;
    }

    pub fn deinit(self: *GameRunner) void {
        self.registry.deinit();
    }

    pub fn startUp(self: *GameRunner) void {
        _ = self;
        rl.initAudioDevice();
    }

    pub fn shutDown(self: *GameRunner) void {
        self.deinit();
    }

    pub fn update(self: *GameRunner) void {
        //TODO remove switch, each state, set the next on, use ecs...
        var exploring = state.Explore.init(&self.registry);
        switch (self.current_state) {
            .Exploring => exploring.state().update(),
            .Battle => self.battleUpdate(),
        }
    }

    pub fn battleUpdate(self: *GameRunner) void {
        _ = self;
    }

    pub fn draw(self: *GameRunner) void {
        self.renderer.drawFrame();
        defer self.renderer.endDrawing();

        const origin = rl.Vector2{ .x = 0, .y = 0 };
        var m = self.registry.singletons().get(map.Map);
        var p = self.registry.singletons().get(player.Player);

        m.draw(origin);
        p.draw(origin);
    }
};
