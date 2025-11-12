const rl = @import("raylib");
const core = @import("../core.zig");

const RenderableDelegate = *const fn (pos: rl.Vector2, color: rl.Color, font: core.Font, data: *const anyopaque) void;

pub const Renderable = struct {
    font: core.Font,
    color: rl.Color,
    draw_func: RenderableDelegate,
    draw_data: *const anyopaque,

    pub fn render(self: Renderable, pos: rl.Vector2) void {
        self.draw_func(pos, self.color, self.font, self.draw_data);
    }
};
