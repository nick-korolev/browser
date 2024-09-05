const rl = @import("raylib");
const ui = @import("ui.zig");
const std = @import("std");
const TodoModel = @import("model.zig").TodoModel;

pub const TodoView = struct {
    inputField: ui.InputField,
    addButton: ui.Button,
    titleText: ui.Text,
    pub fn init() TodoView {
        return TodoView{
            .inputField = ui.InputField.init(10, 50, 600, 40, rl.Color.light_gray, rl.Color.black),
            .addButton = ui.Button.init(620, 50, 100, 40, "Add", rl.Color.green, rl.Color.white),
            .titleText = ui.Text.init(10, 10, "Todo App", 30, rl.Color.black),
        };
    }

    pub fn render(self: *TodoView, model: *TodoModel) void {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);

        self.titleText.draw();
        self.inputField.draw();
        self.addButton.draw();

        var currentY = 100;
        for (model.todos.items) |todo| {
            rl.drawText(todo.text, @as(c_int, 10), @as(c_int, currentY), 20, rl.Color.black);
            currentY += @as(f32, @floatFromInt(20)) + 5;
        }

        if (model.input_text_length > 0) {
            const inputText = ui.Text.init(10, 100, @constCast(&model.input_text), 20, rl.Color.black);
            inputText.draw();
        }
    }

    pub fn handleEvents(self: *TodoView) struct { inputChanged: bool, addClicked: bool, toggleIndex: ?usize } {
        return .{ .inputChanged = self.inputField.handleInput(), .addClicked = self.addButton.isClicked(), .toggleIndex = null };
    }

    pub fn clearInput(self: *TodoView) void {
        self.inputField.clear();
    }
};
