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

    pub fn handleEvents(self: *TodoController) void {
        const events = self.view.handleEvents();

        if (events.inputChanged) {
            self.model.updateInputText(&self.view.inputField.text);
        }
        if (events.addClicked) {
            std.debug.print("clicked!", .{});
        }
    }

    pub fn update(_: *TodoController) void {}
};
