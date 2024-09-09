const rl = @import("raylib");
const std = @import("std");

pub const Text = struct {
    x: f32,
    y: f32,
    text: [*:0]const u8,
    fontSize: c_int,
    color: rl.Color,
    strikethrough: bool,

    pub fn init(x: f32, y: f32, text: [*:0]const u8, fontSize: c_int, color: rl.Color) Text {
        return Text{
            .x = x,
            .y = y,
            .text = text,
            .fontSize = fontSize,
            .color = color,
            .strikethrough = false,
        };
    }

    pub fn draw(self: *const Text) void {
        rl.drawText(self.text, @as(c_int, @intFromFloat(self.x)), @as(c_int, @intFromFloat(self.y)), self.fontSize, self.color);

        if (self.strikethrough) {
            const textWidth = rl.measureText(self.text, self.fontSize);
            const lineY = self.y + @as(f32, @floatFromInt(self.fontSize)) / 2.0;
            const lineThickness = @max(1, @as(c_int, @intFromFloat(@as(f32, @floatFromInt(self.fontSize)) / 10.0)));

            rl.drawLineEx(rl.Vector2{ .x = self.x, .y = lineY }, rl.Vector2{ .x = self.x + @as(f32, @floatFromInt(textWidth)), .y = lineY }, @as(f32, @floatFromInt(lineThickness)), self.color);
        }
    }

    pub fn isClicked(self: *const Text) bool {
        const mousePosition = rl.getMousePosition();
        const textWidth = rl.measureText(self.text, self.fontSize);
        const textRect = rl.Rectangle.init(self.x, self.y, @as(f32, @floatFromInt(textWidth)), @as(f32, @floatFromInt(self.fontSize)));

        return rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left) and
            rl.checkCollisionPointRec(mousePosition, textRect);
    }

    pub fn setStrikethrough(self: *Text, value: bool) void {
        self.strikethrough = value;
    }
};
