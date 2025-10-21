const rl = @import("raylib");
const ecs = @import("ecs");
const systems = @import("./systems/render.zig");

pub const Renderer = struct {
    registry: *ecs.Registry,

    pub fn init(registy: *ecs.Registry) Renderer {
        return Renderer{ .registry = registy };
    }

    pub fn drawFrame(self: *Renderer) void {
        rl.beginDrawing();
        rl.clearBackground(rl.Color.black);

        const origin = rl.Vector2{ .x = 0, .y = 0 };
        systems.MapRenderSystem(self.registry, origin);
        systems.PlayerRenderSystem(self.registry, origin);
    }

    pub fn endFrame(self: *Renderer) void {
        _ = self;
        rl.endDrawing();
    }
};
