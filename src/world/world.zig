const std = @import("std");
const ecs = @import("ecs");
const components = @import("../components/components.zig");
const font = @import("../font.zig");
const rl = @import("raylib");
const map = @import("map.zig");

const Allocator = std.mem.Allocator;

pub const World = struct {
    allocator: Allocator,
    registry: *ecs.Registry,
    const Self = @This();

    pub fn init(registry: *ecs.Registry) *World {
        const allocator = registry.allocator;
        const self = allocator.create(World) catch @panic("error allocating World");
        self.* = .{ .allocator = allocator, .registry = registry };
        return self;
    }

    pub fn load(self: *Self) void {
        const defaultFont = font.Font.init();
        const types_entity = self.registry.create();

        self.registry.add(types_entity, components.Position{ .x = 2, .y = 2 });
        self.registry.add(types_entity, components.Renderable{
            .font = defaultFont,
            .text = "@",
            .color = rl.Color.yellow,
        });
        self.registry.add(types_entity, components.PlayerTag{});

        self.registry.singletons().add(map.TileMap{
            .data = map.MapData,
            .font = defaultFont,
        });
    }

    pub fn deinit(self: *Self) void {
        _ = self;
    }

    pub fn destroy(self: *Self) void {
        self.deinit();
        self.allocator.destroy(self);
    }
};
