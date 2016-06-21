require('src/logic/mutate/MutatorBus')
require('src/logic/mutate/Mutator')

describe('MutatorBus', function ()

  local debug_print = function (out)
    if false then print(out) end
  end

  it('Should accept valid mutators passed to it and perform forward (even multiple) and backward (even multiple) functions', function ()

    TestBus = MutatorBus.new()

    local execSpy1 = spy.new(function() debug_print("EXEC 1") end)
    local undoSpy1 = spy.new(function() debug_print("UNDO 1") end)
    local subSpy1 = spy.new(function () debug_print("SUB 1") end)
    TestBus.subscribe("mutation", subSpy1)
    TestMutator1 = Mutator.new({
        execute = execSpy1,
        undo = undoSpy1
      })

    local execSpy2 = spy.new(function() debug_print("EXEC 2") end)
    local undoSpy2 = spy.new(function() debug_print("UNDO 2") end)
    local subSpy2 = spy.new(function () debug_print("SUB 2") end)
    TestMutator2 = Mutator.new({
        execute = execSpy2,
        undo = undoSpy2
      })

    local execSpy3 = spy.new(function() debug_print("EXEC 3") end)
    local undoSpy3 = spy.new(function() debug_print("UNDO 3") end)
    local subSpy3 = spy.new(function () debug_print("SUB 3") end)
    TestMutator3 = Mutator.new({
        execute = execSpy3,
        undo = undoSpy3
      })

    TestBus.mutate(TestMutator1)

    assert.spy(execSpy1).was.called(1)
    assert.spy(subSpy1).was.called(1)

    TestBus.rewind()

    assert.spy(undoSpy1).was.called(1)
    assert.spy(subSpy1).was.called(2)

    TestBus.replay()

    assert.spy(execSpy1).was.called(2)
    assert.spy(subSpy1).was.called(3)

    --Test multi rewind/replay

    TestBus.mutate(TestMutator2)

    assert.spy(execSpy2).was.called(1)

    TestBus.mutate(TestMutator3)

    assert.spy(execSpy3).was.called(1)

    local sb = function() return false end
    TestBus.seekBack(sb)

    assert.spy(undoSpy3).was.called(1)
    assert.spy(undoSpy2).was.called(1)
    assert.spy(undoSpy1).was.called(2)

    local sf = function() return false end
    TestBus.seekForward(sf)

    assert.spy(execSpy1).was.called(3)
    assert.spy(execSpy2).was.called(2)
    assert.spy(execSpy3).was.called(2)
  end)

  it('Should throw an error if asked to mutate when not at the present', function ()

    TestBus = MutatorBus.new()

    local execSpy1 = spy.new(function() debug_print("EXEC 1") end)
    local undoSpy1 = spy.new(function() debug_print("UNDO 1") end)
    local subSpy1 = spy.new(function () debug_print("SUB 1") end)
    TestBus.subscribe("mutation", subSpy1)
    TestMutator1 = Mutator.new({
        execute = execSpy1,
        undo = undoSpy1
      })
    TestMutator2 = Mutator.new({
        execute = execSpy1,
        undo = undoSpy1
      })

    TestBus.mutate(TestMutator1)
    TestBus.rewind()
    assert.has_error(TestBus.mutate)
  end)
end)
