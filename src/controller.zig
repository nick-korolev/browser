const TodoModel = @import("model.zig").TodoModel;
const TodoView = @import("view.zig").TodoView;
const rl = @import("raylib");
const std = @import("std");

pub const TodoController = struct {
    model: *TodoModel,
    view: *TodoView,

    pub fn init(model: *TodoModel, view: *TodoView) TodoController {
        return TodoController{
            .model = model,
            .view = view,
        };
    }

    pub fn handleEvents(self: *TodoController) !void {
        const events = self.view.handleEvents();

        if (events.inputChanged) {
            self.model.updateInputText(&self.view.inputField.text);
        }
        if (events.addClicked) {
            try self.model.addTodo(self.view.inputField.text);
            self.model.clearInputText();
            self.view.clearInput();
        }
    }

    pub fn update(_: *TodoController) void {}
};
