const std = @import("std");

pub const Todo = struct {
    id: u32,
    text: []const u8,
    completed: bool,
};

pub const TodoModel = struct {
    todos: std.ArrayList(Todo),
    allocator: std.mem.Allocator,
    input_text: [256:0]u8,
    input_text_length: usize,

    pub fn init(allocator: std.mem.Allocator) TodoModel {
        return TodoModel{
            .todos = std.ArrayList(Todo).init(allocator),
            .allocator = allocator,
            .input_text = [_:0]u8{0} ** 256,
            .input_text_length = 0,
        };
    }

    pub fn deinit(self: *TodoModel) void {
        self.todos.deinit();
    }

    pub fn updateInputText(self: *TodoModel, text: []const u8) void {
        @memcpy(&self.input_text, text);
        self.input_text_length = text.len;
    }
};
