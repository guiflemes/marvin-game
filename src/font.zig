const rl = @import("raylib");

pub const Font = struct {
    raylibFont: rl.Font,
    size: f32,

    pub fn init() Font {
        const font = rl.getFontDefault() catch {
            @panic("impossible to load raylib default font");
        };
        return Font{ .raylibFont = font, .size = 24 };
    }
};
