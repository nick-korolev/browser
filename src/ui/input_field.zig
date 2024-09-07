const rl = @import("raylib");
const std = @import("std");

pub const InputField = struct {
    rect: rl.Rectangle,
    text: [256:0]u8,
    textLength: usize,
    color: rl.Color,
    textColor: rl.Color,
    isFocused: bool,

    pub fn init(x: f32, y: f32, width: f32, height: f32, color: rl.Color, textColor: rl.Color) InputField {
        return InputField{
            .rect = rl.Rectangle{ .x = x, .y = y, .width = width, .height = height },
            .text = [_:0]u8{0} ** 256,
            .textLength = 0,
            .color = color,
            .textColor = textColor,
            .isFocused = false,
        };
    }

    pub fn draw(self: *const InputField) void {
        rl.drawRectangleRec(self.rect, self.color);
        rl.drawText(&self.text, @as(c_int, @intFromFloat(self.rect.x + 5)), @as(c_int, @intFromFloat(self.rect.y + 5)), 20, self.textColor);
        if (self.isFocused) {
            rl.drawRectangleLinesEx(self.rect, 2, rl.Color.red);
        }
    }

    pub fn handleInput(self: *InputField) bool {
        _ = self.checkFocus();
        if (!self.isFocused) return false;

        var changed = false;
        const key = rl.getCharPressed();
        if (key != 0) {
            if (self.textLength < 255) {
                // something is wrong here
                self.text[self.textLength] = @intCast(key);
                self.textLength += 1;
                self.text[self.textLength] = 0;
                changed = true;
            }
        }

        if (rl.isKeyPressed(rl.KeyboardKey.key_backspace)) {
            if (self.textLength > 0) {
                self.textLength -= 1;
                self.text[self.textLength] = 0;
                changed = true;
            }
        }

        return changed;
    }

    pub fn checkFocus(self: *InputField) bool {
        const mousePos = rl.getMousePosition();
        if (rl.isMouseButtonPressed(rl.MouseButton.mouse_button_left)) {
            self.isFocused = rl.checkCollisionPointRec(mousePos, self.rect);
        }
        return self.isFocused;
    }

    pub fn clear(self: *InputField) void {
        @memset(&self.text, 0);
        self.textLength = 0;
    }
};
