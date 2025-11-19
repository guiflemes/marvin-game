const std = @import("std");
const ecs = @import("ecs");
const render = @import("./render.zig");
const input = @import("./input.zig");
const movement = @import("./movement.zig");
const control = @import("./game_control.zig");
const events = @import("../events/events.zig");

const Dispatcher = events.dispatcher.Dispatcher(100);

pub const SystemContext = struct {
    registry: *ecs.Registry,
    dispatcher: *Dispatcher,
};

pub fn update(ctx: *const SystemContext) void {
    const delta = std.time.milliTimestamp();

    input.InputSystem(&input.InputContext{ .registry = ctx.registry });
    control.GameControlSystem(&control.GameControlContext{ .registry = ctx.registry, .dispatcher = ctx.dispatcher });
    movement.MovementSystem(&movement.MovementContext{ .registry = ctx.registry, .delta = delta });
    render.RenderSystem(&render.RenderContext{ .registry = ctx.registry });
}
