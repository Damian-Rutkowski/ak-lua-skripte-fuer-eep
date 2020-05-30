if AkDebugLoad then print("Loading ak.road.TrafficLight ...") end

local Queue = {}
function Queue:new()
    local o = {first = 0, last = -1, list = {}}
    self.__index = self
    setmetatable(o, self)
    return o
end

---Tells if the queue is empty
---@return boolean true if the queue is empty
function Queue:isEmpty() return self.last - self.first == -1 end

---Tells if the queue is empty
---@return number number of elements in the queue
function Queue:size() return self.last + 1 - self.first end

---Pushes a value to the current queues end
---@param value any @value to be pushed to the end of the queue
function Queue:push(value)
    local last = self.last + 1
    self.last = last
    self.list[last] = value
end

--- Receives the value at the queues beginning
---@return any
function Queue:pop()
    local first = self.first
    if first > self.last then error("list is empty") end
    local value = self.list[first]
    self.list[first] = nil -- to allow garbage collection
    self.first = first + 1
    return value
end

return Queue
