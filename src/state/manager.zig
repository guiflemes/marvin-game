const ecs = @import("ecs");
const std = @import("std");
const state = @import("state.zig");
const core = @import("../core.zig");
const events = @import("../events/queue.zig");
const explore = @import("explore.zig");

const Transition = core.Transition;
const Allocator = std.mem.Allocator;
const Explore = explore.Explore;

pub const StateManager = struct {
    const Self = @This();

    allocator: Allocator,
    registry: *ecs.Registry,
    current_state: state.State,
    events: events.Queue,

    pub fn init(registry: *ecs.Registry, eventQueue: events.Queue) *Self {
        const allocator = registry.allocator;
        const self = allocator.create(Self) catch @panic("error allocating StateManager");
        self.* = .{
            .allocator = allocator,
            .registry = registry,
            .current_state = undefined,
            .events = eventQueue,
        };
        return self;
    }

    pub fn load(self: *Self) void {
        self.current_state = Explore.createState(self.registry) catch @panic("alloc error");
    }

    pub fn update(self: *Self) void {
        const next: Transition = self.current_state.update();

        switch (next) {
            .none => {},
            .to => |target| self.changeState(target),
        }
    }

    fn changeState(self: *Self, transition: Transition.StateType) void {
        self.current_state.destroy();

        const new_state = switch (transition) {
            .Explore => Explore.createState(self.registry) catch @panic("alloc error"),
        };

        self.current_state = new_state;
    }

    pub fn deinit(self: *Self) void {
        self.current_state.destroy();
    }

    pub fn destroy(self: *Self) void {
        self.deinit();
        self.allocator.destroy(self);
    }
};
