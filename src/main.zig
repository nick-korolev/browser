const std = @import("std");
const rl = @import("raylib");
const TodoModel = @import("model.zig").TodoModel;
const TodoView = @import("view.zig").TodoView;
const TodoController = @import("controller.zig").TodoController;

pub fn main() !void {
    const screenWidth = 800;
    const screenHeight = 600;
    rl.initWindow(screenWidth, screenHeight, "Todo App");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var model = TodoModel.init(std.heap.page_allocator);
    defer model.deinit();

    var view = TodoView.init();
    var controller = TodoController.init(&model, &view);

    while (!rl.windowShouldClose()) {
        try controller.handleEvents();
        controller.update();
        view.render(&model);
    }
}
