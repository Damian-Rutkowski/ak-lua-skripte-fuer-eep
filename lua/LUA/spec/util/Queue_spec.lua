describe("ak.util.Queue", function()
    insulate("new Queue is empty", function()
        local Queue = require("ak.util.Queue")

        local myQueue = Queue:new();
        it("Queue is empty", function() assert.is_true(myQueue:isEmpty()) end)
        it("Queue size is 0", function() assert.equals(0, myQueue:size()) end)
    end)

    insulate("Queue with elements is not empty", function()
        local Queue = require("ak.util.Queue")

        local myQueue = Queue:new()
        myQueue:push("ELEMENT")

        it("Queue is not empty", function() assert.is_false(myQueue:isEmpty()) end)
        it("Queue size is 1", function() assert.equals(1, myQueue:size()) end)
    end)

    insulate("Queue will returm elements in correct order", function()
        local Queue = require("ak.util.Queue")

        local myQueue = Queue:new()
        myQueue:push("ELEMENT 1")
        myQueue:push("ELEMENT 2")
        myQueue:push("ELEMENT 3")

        it("Queue is not empty", function() assert.is_false(myQueue:isEmpty()) end)
        it("Queue size is 3", function() assert.equals(3, myQueue:size()) end)
        it("Can pop all three elements in order", function()
            assert.is_false(myQueue:isEmpty())
            assert.equals(3, myQueue:size())
            assert.equals("ELEMENT 1", myQueue:pop())
            assert.equals(2, myQueue:size())
            assert.equals("ELEMENT 2", myQueue:pop())
            assert.equals(1, myQueue:size())
            assert.equals("ELEMENT 3", myQueue:pop())
            assert.equals(0, myQueue:size())
            assert.is_true(myQueue:isEmpty())
        end)
    end)
end)
