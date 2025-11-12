const std = @import("std");
const ecs = @import("ecs");
const render = @import("./render.zig");
const input = @import("./input.zig");
const moviment = @import("./movement.zig");

pub fn update(registry: *ecs.Registry) void {
    const delta = std.time.milliTimestamp();

    input.InputSystem(registry);
    moviment.MovementSystem(registry, delta);
    render.RenderSystem(registry);
}
