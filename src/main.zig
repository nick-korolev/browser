const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa.deinit();
        switch (leaked) {
            .ok => {},
            .leak => std.debug.print("leaked {any}\n", .{leaked}),
        }
    }

    std.debug.print("Browser!\n", .{});
}
