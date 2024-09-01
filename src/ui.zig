const rl = @import("raylib");
const std = @import("std");

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
        return rl.checkCollisionPointRec(rl.getMousePosition(), self.rect) and rl.isMouseButtonPressed(rl.MouseButton.left);
    }
};

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
};

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
