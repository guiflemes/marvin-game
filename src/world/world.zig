const std = @import("std");
const ecs = @import("ecs");
const core = @import("../core.zig");
const tile_map = @import("./tile_map.zig");
const map_resource = @import("../resources/map_layouts.zig");
const vtable = @import("vtable.zig");
const rl = @import("raylib");

pub const Map = vtable.Map;

pub const WorldContext = struct {
    registry: *ecs.Registry,
    allocator: std.mem.Allocator,
    font: core.Font,
};

pub const WorldManager = struct {
    const Self = @This();

    registry: *ecs.Registry,
    allocator: std.mem.Allocator,
    overall_map: vtable.Map,
    local_map: ?vtable.Map,
    is_in_local: bool,
    font: core.Font,

    pub fn init(allocator: std.mem.Allocator, registry: *ecs.Registry, font: core.Font) Self {
        return .{
            .allocator = allocator,
            .registry = registry,
            .is_in_local = false,
            .overall_map = undefined,
            .local_map = null,
            .font = font,
        };
    }

    pub fn deinit(self: *Self) void {
        self.overall_map.destroy();
        if (self.local_map) |lm| lm.destroy();
    }

    pub fn switch_to_local(self: *Self) void {
        _ = self;
    }

    pub fn return_to_overall(self: *Self) void {
        if (self.local_map) |lm| {
            lm.destroy();
            self.local_map = null;
        }
        self.is_in_local = false;
    }

    pub fn get_active_map(self: *Self) vtable.Map {
        return if (self.is_in_local) self.local_map.? else self.overall_map;
    }
};

pub fn create_world_manager(ctx: WorldContext) void {
    const layout_leve1 = map_resource.LEVEL1;
    var tm = tile_map.TileMap.create(ctx.allocator, layout_leve1[0..], ctx.font) catch @panic("error on map");
    var manager = WorldManager.init(ctx.allocator, ctx.registry, ctx.font);
    manager.overall_map = tm.map();
    ctx.registry.singletons().add(manager);
}
