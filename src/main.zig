const std = @import("std");
const assert = std.debug.assert;
const print = std.debug.print;
const Allocator = std.mem.Allocator;

const DBError = error{ NotFound, DBMismatch, ExpectedSingleGotMany, DuplicateRegisterAttempt };

const MetaCommands = enum {
    Quit,
    Help,
    DB,
    Entities,
    Components,
    Systems,
    DescribeDB,
    DescribeEntity,
    DescribeComponent,
    DescribeSystem,
    Exists,
};

const Commands = enum {
    Select,
    Insert,
    Update,
    Delete,
    Func,
};

pub const Entity = struct {
    address: []const u8,
    components: std.ArrayList(Component),
    cursor: usize,

    fn init(name: []const u8, components: []Component) Component {
        return .{ name, components, 0 };
    }
};

pub const Component = struct {
    address: []const u8,
    data: type,
    cursor: usize,

    fn init(name: []const u8, comptime data_type: type) Component {
        return Component{ .address = name, .data = data_type, .cursor = 0 };
    }
};

pub const DBContextConfig = struct {};

pub const DBContext = struct {
    allocator: *const Allocator, // Store the allocator
    ids: std.ArrayList(usize),
    // entities: std.ArrayList(Entity),
    // components: std.ArrayList(Component),
    server_config: DBContextConfig,

    pub fn init(allocator: *const Allocator) DBContext {
        return DBContext{
            .allocator = allocator,
            .ids = undefined,
            // .entities = std.ArrayList(Entity).init(allocator),
            // .components = std.ArrayList(Component).init(allocator),
            .server_config = undefined, // Or provide a default value for server_config
        };
    }
    //
    // pub fn register_entity(self: DBContext, entity: Entity, allocator: Allocator) !void {
    //     // if self.entities is undefined, initialize empty array
    //     if (self.entities == undefined) {
    //         const res = std.ArrayList(Entity).init(allocator);
    //         self.entities = res;
    //         res.deinit();
    //     }
    //     // assert no double registry of same entity
    //     for (self.entities) |db_entity| {
    //         if (db_entity == entity) return DBError.DuplicateRegisterAttempt;
    //     }
    //     // append new entity
    //     try self.entities.append(entity);
    //     print("Appended Entity", .{});
    //     // append all components, if any new
    //     for (entity.components) |comp| {
    //         self.register_component(comp) catch |err| {
    //             {
    //                 print("{:s}", .{err});
    //                 self.entities.pop();
    //                 return err;
    //             }
    //         };
    //     }
    // }
    //
    // fn register_component(self: DBContext, component: Component, allocator: *const Allocator) !void {
    //     // if self.entities is undefined, initialize empty array
    //     if (self.components == undefined) {
    //         self.components = std.ArrayList(Component).init(allocator);
    //     }
    //     // assert no double registry of same entity
    //     for (self.components) |db_component| {
    //         if (db_component == component) return DBError.DuplicateRegisterAttempt;
    //     }
    //     // append new entity
    //     try self.entities.append(component);
    //     print("Appended Component", .{});
    // }
    //
    fn serve(self: DBContext) !void {
        print(self.entities);
        print(self.components);
    }
};

// Create Components
const Name = Component.init("name", []u8);
const Role = Component.init("role", enum { Visitor, Admin, User });
const Price = Component.init("price", f32);
const DeliveryStatus = Component.init("delivery_status", *enum { Shipped, Delivered, Cancelled });

// Create Entities
const User = Entity.init("user", [_]Component{ Name, Role });
const Product = Entity.init("user", [_]Component{ Name, Price, DeliveryStatus });

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    _ = DBContext.init(&allocator);
    // db.register_entity(User);
    // db.register_entity(Product);
    // db.serve();
}

test "hi" {
    const hi = "hi";
    try std.testing.expectFmt("hi", hi);
}
