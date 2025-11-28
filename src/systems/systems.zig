const std = @import("std");
const ecs = @import("ecs");
const render = @import("./render.zig");
const input = @import("./input.zig");
const movement = @import("./movement.zig");
const control = @import("./game_control.zig");
const events = @import("../events/events.zig");
const context = @import("../core/ctx.zig");

const SystemContexts = struct {
    input: input.InputContext,
    control: control.GameControlContext,
    movement: movement.MovementContext,
    render: render.RenderContext,

    fn init(ctx: *context.GameContext) @This() {
        var self: @This() = undefined;

        inline for (@typeInfo(@This()).@"struct".fields) |f| {
            const FieldType = f.type;
            @field(self, f.name) = context.makeContextChild(FieldType, ctx);
        }
        return self;
    }
};

pub fn update(ctx: *context.GameContext) void {
    const system = SystemContexts.init(ctx);

    input.InputSystem(&system.input);
    control.GameControlSystem(&system.control);
    movement.MovementSystem(&system.movement);
    render.RenderSystem(&system.render);
}
