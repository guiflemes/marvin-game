const ecs = @import("ecs");
const std = @import("std");
const state = @import("state.zig");

const Allocator = std.mem.Allocator;

pub const StateManager = struct {
    const Self = @This();

    allocator: Allocator,
    registry: *ecs.Registry,

    pub fn init(registry: *ecs.Registry) *Self {
        const allocator = registry.allocator;
        const self = allocator.create(Self) catch @panic("error allocating StateManager");
        self.* = .{ .allocator = allocator, .registry = registry };
        return self;
    }

    pub fn load(self: *Self) void {
        const s = state.Explore.create(self.registry) catch @panic("error allocating inital state");
        self.registry.singletons().add(s.state());
    }

    pub fn setState(self: *Self, s: state.State) void {
        const current: state.State = self.registry.singletons().get(state.State).destroy();
        current.destroy();
        self.registry.singletons().add(s);
    }

    pub fn currentState(self: *Self) *state.State {
        return self.registry.singletons().get(state.State);
    }

    pub fn deinit(self: *Self) void {
        self.registry.singletons().get(state.State).destroy();
    }

    pub fn destroy(self: *Self) void {
        self.deinit();
        self.allocator.destroy(self);
    }
};
