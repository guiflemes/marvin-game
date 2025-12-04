const std = @import("std");
const ecs = @import("ecs");
const map_resource = @import("../resources/map_layouts.zig");
const vtable = @import("vtable.zig");
const rl = @import("raylib");
const f = @import("../core/font.zig");

pub const Map = vtable.Map;

pub const WorldContext = struct {
    registry: *ecs.Registry,
    allocator: std.mem.Allocator,
    font: f.Font,
};

pub const WorldManager = struct {
    const Self = @This();

    registry: *ecs.Registry,
    allocator: std.mem.Allocator,
    overall_map: vtable.Map,
    local_map: ?vtable.Map,
    is_in_local: bool,
    font: f.Font,

    pub fn init(allocator: std.mem.Allocator, registry: *ecs.Registry, font: f.Font) Self {
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

    pub fn get_active_world(self: *Self) vtable.Map {
        return if (self.is_in_local) self.local_map.? else self.overall_map;
    }
};
