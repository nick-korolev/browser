const std = @import("std");

pub const Todo = struct {
    id: u32,
    text: []const u8,
    completed: bool,

    pub fn format(self: Todo, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        try writer.print("{d}. {s} = {}\n", .{ self.id, self.text, self.completed });
    }
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
        for (self.todos.items) |todo| {
            self.allocator.free(todo.text);
        }
        self.todos.deinit();
    }

    pub fn updateInputText(self: *TodoModel, text: []const u8) void {
        @memcpy(&self.input_text, text);
        self.input_text_length = text.len;
    }

    pub fn addTodo(self: *TodoModel, text: [256:0]u8) !void {
        const trimmedText = std.mem.trim(u8, &text, " ");
        if (trimmedText.len == 0) {
            return;
        }
        const todo = Todo{
            .id = @intCast(self.todos.items.len + 1),
            .text = try self.allocator.dupe(u8, trimmedText),
            .completed = false,
        };
        try self.todos.append(todo);
        std.debug.print("added todo: {s}\n todos: {any}\n", .{ trimmedText, self.todos.items });
    }

    pub fn toggleTodo(self: *TodoModel, id: u32) void {
        std.debug.print("toggling todo: {d}\n", .{id});
        for (self.todos.items) |*todo| {
            if (todo.id == id) {
                todo.completed = !todo.completed;
                std.debug.print("toggled todo: {s}\n todos: {any}\n", .{ todo.text, self.todos.items });
                return;
            }
        }
    }

    pub fn clearInputText(self: *TodoModel) void {
        @memset(&self.input_text, 0);
        self.input_text_length = 0;
    }
};
