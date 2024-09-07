const rl = @import("raylib");

pub const Button = struct {
    rect: rl.Rectangle,
    text: [*:0]const u8,
    color: rl.Color,
    textColor: rl.Color,

    pub fn init(x: f32, y: f32, width: f32, height: f32, text: [*:0]const u8, color: rl.Color, textColor: rl.Color) Button {
        return Button{
            .rect = rl.Rectangle{ .x = x, .y = y, .width = width, .height = height },
            .text = text,
            .color = color,
            .textColor = textColor,
        };
    }

    pub fn draw(self: *const Button) void {
        rl.drawRectangleRec(self.rect, self.color);
        const fontSize = 20;
        const textWidth = rl.measureText(self.text, fontSize);
        const textX = self.rect.x + (self.rect.width - @as(f32, @floatFromInt(textWidth))) / 2;
        const textY = self.rect.y + (self.rect.height - @as(f32, fontSize)) / 2;
        rl.drawText(self.text, @as(c_int, @intFromFloat(textX)), @as(c_int, @intFromFloat(textY)), fontSize, self.textColor);
    }

    pub fn isClicked(self: *const Button) bool {
        return rl.checkCollisionPointRec(rl.getMousePosition(), self.rect) and rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left);
    }

    pub fn onClick(self: *const Button, callback: fn () void) void {
        if (self.isClicked()) {
            callback();
        }
    }
};
