const rl = @import("raylib");
const ecs = @import("ecs");
const std = @import("std");
const core = @import("../core.zig");

const Transition = core.Transition;

pub const State = struct {
    ptr: *anyopaque,
    vtable: *const Vtable,

    pub const Vtable = struct {
        update: *const fn (*anyopaque) Transition,
        destroy: *const fn (*anyopaque) void,
    };

    pub fn update(self: State) Transition {
        return self.vtable.update(self.ptr);
    }

    pub fn destroy(self: State) void {
        self.vtable.destroy(self.ptr);
    }
};
