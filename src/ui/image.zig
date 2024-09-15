const std = @import("std");
const raylib = @import("raylib");

pub const Image = struct {
    texture: raylib.Texture2D,
    position: raylib.Vector2,
    scale: f32,
    tint: raylib.Color,

    pub fn init(path: []const u8, x: f32, y: f32) !Image {
        const texture = raylib.LoadTexture(@ptrCast(path));
        if (texture.id == 0) {
            return error.TextureLoadFailed;
        }

        return Image{
            .texture = texture,
            .position = raylib.Vector2{ .x = x, .y = y },
            .scale = 1.0,
            .tint = raylib.WHITE,
        };
    }

    pub fn deinit(self: *Image) void {
        raylib.UnloadTexture(self.texture);
    }

    pub fn draw(self: *const Image) void {
        raylib.DrawTextureEx(self.texture, self.position, 0.0, self.scale, self.tint);
    }

    pub fn setPosition(self: *Image, x: f32, y: f32) void {
        self.position = raylib.Vector2{ .x = x, .y = y };
    }

    pub fn setScale(self: *Image, scale: f32) void {
        self.scale = scale;
    }

    pub fn setTint(self: *Image, tint: raylib.Color) void {
        self.tint = tint;
    }
};
