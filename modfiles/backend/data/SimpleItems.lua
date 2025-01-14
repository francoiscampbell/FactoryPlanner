local Object = require("backend.data.Object")

---@alias SimpleItemCategory "product" | "byproduct" | "ingredient"

---@class SimpleItem
---@field proto FPItemPrototype
---@field amount number
---@field satisfied_amount number?

---@class SimpleItems: Object, ObjectMethods
---@field class "SimpleItems"
---@field parent LineObject
---@field items SimpleItem[]
---@field amount integer
local SimpleItems = Object.methods()
SimpleItems.__index = SimpleItems
script.register_metatable("SimpleItems", SimpleItems)

---@return SimpleItems
local function init()
    local object = Object.init({
        items = {},
        amount = 0
    }, "SimpleItems", SimpleItems)  --[[@as SimpleItems]]
    return object
end


function SimpleItems:index()
    OBJECT_INDEX[self.id] = self
end


---@param item SimpleItem
function SimpleItems:insert(item)
    table.insert(self.items, item)
    self.amount = self.amount + 1
end

function SimpleItems:clear()
    self.items = {}
    self.amount = 0
end


---@param proto FPItemPrototype
---@return SimpleItem? simple_item
function SimpleItems:find(proto)
    for _, simple_item in pairs(self.items) do
        if simple_item.proto == proto then return simple_item end
    end
end

---@return fun(): integer?, SimpleItem?
function SimpleItems:iterator()
    local i = 0
    return function()
        i = i + 1; local next = self.items[i]
        if next then return i, next end
    end
end

---@return number count
function SimpleItems:count()
    return table_size(self.items)
end


-- SimpleItems don't need any validation or repair, they are just removed and re-calculated

return {init = init}
