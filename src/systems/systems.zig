const std = @import("std");
const ecs = @import("ecs");
const render = @import("./render.zig");
const input = @import("./input.zig");
const movement = @import("./movement.zig");
const control = @import("./game_control.zig");
const events = @import("../events/events.zig");
const context = @import("../core/ctx.zig");

pub const SystemContext = struct {
    input: input.InputContext,
    control: control.GameControlContext,
    movement: movement.MovementContext,
    render: render.RenderContext,

    pub fn init(ctx: *context.GameContext) @This() {
        var self: @This() = undefined;

        inline for (@typeInfo(@This()).@"struct".fields) |f| {
            const FieldType = f.type;
            @field(self, f.name) = context.makeContextChild(FieldType, ctx);
        }
        return self;
    }
};

pub fn update(ctx: *SystemContext) void {
    input.InputSystem(&ctx.input);
    control.GameControlSystem(&ctx.control);
    movement.MovementSystem(&ctx.movement);
}

pub fn draw(ctx: *render.RenderContext) void {
    render.RenderSystem(ctx);
}
