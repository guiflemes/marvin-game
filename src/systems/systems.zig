const std = @import("std");
const ecs = @import("ecs");
const render = @import("./render.zig");
const input = @import("./input.zig");
const moviment = @import("./movement.zig");
const control = @import("./game_control.zig");
const Dispatcher = @import("../events/dispatcher.zig").Dispatcher;

pub const SystemContext = struct {
    registry: *ecs.Registry,
    dispatcher: *Dispatcher(100),
};

pub fn update(ctx: *const SystemContext) void {
    const delta = std.time.milliTimestamp();

    input.InputSystem(ctx.registry);
    control.GameControlSystem(&control.GameControlContext{ .registry = ctx.registry, .dispatcher = ctx.dispatcher });
    moviment.MovementSystem(ctx.registry, delta);
    render.RenderSystem(ctx.registry);
}
