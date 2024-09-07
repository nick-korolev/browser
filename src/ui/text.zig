const rl = @import("raylib");

pub const Text = struct {
    x: f32,
    y: f32,
    text: [*:0]const u8,
    fontSize: c_int,
    color: rl.Color,

    pub fn init(x: f32, y: f32, text: [*:0]const u8, fontSize: c_int, color: rl.Color) Text {
        return Text{
            .x = x,
            .y = y,
            .text = text,
            .fontSize = fontSize,
            .color = color,
        };
    }

    pub fn draw(self: *const Text) void {
        rl.drawText(self.text, @as(c_int, @intFromFloat(self.x)), @as(c_int, @intFromFloat(self.y)), self.fontSize, self.color);
    }
};
