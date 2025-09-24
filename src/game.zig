const std = @import("std");
const rl = @import("raylib");
const player = @import("player.zig");
const map = @import("map.zig");
const font = @import("font.zig");
const Allocator = std.mem.Allocator;
const ArenaAllocator = std.heap.ArenaAllocator;

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

pub const GameLogic = struct {
    player: *player.Player,
    map: *map.Map,

    pub fn init(p: *player.Player, m: *map.Map) GameLogic {
        return GameLogic{ .player = p, .map = m };
    }

    pub fn update(self: *GameLogic) void {
        if (rl.isKeyPressed(rl.KeyboardKey.right) and !self.map.isObstacle(self.player.y, self.player.x + 1)) {
            self.player.x += 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.left) and !self.map.isObstacle(self.player.y, self.player.x - 1)) {
            self.player.x -= 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.down) and !self.map.isObstacle(self.player.y + 1, self.player.x)) {
            self.player.y += 1;
        }

        if (rl.isKeyPressed(rl.KeyboardKey.up) and !self.map.isObstacle(self.player.y - 1, self.player.x)) {
            self.player.y -= 1;
        }
    }
};

pub const Game = struct {
    renderer: Renderer,
    logic: GameLogic,
    player: *player.Player,
    map: *map.Map,
    arena: ArenaAllocator,
    orig_allocator: Allocator,

    pub fn init(allocator: Allocator) !Game {
        const arena = ArenaAllocator.init(allocator);
        const defaultFont = font.Font.init();

        const p = try allocator.create(player.Player);
        p.* = player.Player.init(defaultFont);
        const m = try allocator.create(map.Map);
        m.* = map.Map.init(defaultFont);

        return Game{
            .renderer = Renderer.init(),
            .logic = GameLogic.init(p, m),
            .player = p,
            .map = m,
            .arena = arena,
            .orig_allocator = allocator,
        };
    }

    pub fn deinit(self: *Game) void {
        self.arena.deinit();
    }

    pub fn startUp(self: *Game) void {
        _ = self;
        rl.initAudioDevice();
    }

    pub fn shutDown(self: *Game) void {
        self.deinit();
    }

    pub fn update(self: *Game) void {
        self.logic.update();
    }

    pub fn draw(self: *Game) void {
        self.renderer.drawFrame();
        defer self.renderer.endDrawing();

        // TODO pass a interface rendereble
        const origin = rl.Vector2{ .x = 0, .y = 0 };
        self.map.draw(origin);
        self.player.draw(origin);
    }
};
