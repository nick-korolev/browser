const rl = @import("raylib");
const ui = @import("./ui/index.zig");
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

        var currentY: f32 = 100;

        const fontSize: i32 = 20;
        for (model.todos.items) |todo| {
            var textItem = ui.Text.init(10, currentY, @ptrCast(todo.text), fontSize, rl.Color.black);
            textItem.setStrikethrough(todo.completed);

            textItem.draw();
            if (textItem.isClicked()) {
                model.toggleTodo(todo.id);
                textItem.setStrikethrough(todo.completed);
            }

            currentY += fontSize + 5;
        }
    }

    pub fn handleEvents(self: *TodoView) struct { inputChanged: bool, addClicked: bool, toggleIndex: ?usize } {
        return .{ .inputChanged = self.inputField.handleInput(), .addClicked = self.addButton.isClicked(), .toggleIndex = null };
    }

    pub fn clearInput(self: *TodoView) void {
        self.inputField.clear();
    }
};
