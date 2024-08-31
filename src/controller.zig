const TodoModel = @import("model.zig").TodoModel;
const TodoView = @import("view.zig").TodoView;
const rl = @import("raylib");

pub const TodoController = struct {
    model: *TodoModel,
    view: *TodoView,

    pub fn init(model: *TodoModel, view: *TodoView) TodoController {
        return TodoController{
            .model = model,
            .view = view,
        };
    }

    pub fn handleInput(self: *TodoController) void {
        self.view.inputField.handleInput();
        self.model.updateInputText(&self.view.inputField.text);
    }

    pub fn update(_: *TodoController) void {}
};
