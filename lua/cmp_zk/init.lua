local ok, job = pcall(require, "plenary.job")
if not ok then return end
local ok, async = pcall(require, "plenary.async")
if not ok then return end
local uv = vim.loop

local source = {}

local read_file = function(path)
    local fd = assert(uv.fs_open(path, "r", 438))
    local stat = assert(uv.fs_fstat(fd))
    local data = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))
    return data
end

-- called on cmp init
source.new = function()
    return setmetatable({ cache = {} }, { __index = source })
end

source.list_tags = function(self, request, callback)
    -- plenary job creation
    job:new({
        command = "rg",
        args = {
            "-oI",
            [[#\w*]],
            vim.fn.expand("~/docs/test_zk/"),
        },
        on_exit = function(job)
            local result = job:result()
            local items = {}
            -- set to keep track of already entered vals
            local seen = {}
            for _, i in ipairs(result) do
                -- only insert if we haven't seen this value before
                if not seen[i] then
                    seen[i] = true -- log in hash set
                    table.insert(items, {   -- and add to actual formated list for cmp
                        label = i,
                    })
                end
            end
            callback({ items = items, isIncomplete = false })
        end,
    }):start()  -- and start it right away
end

source.list_notes = function(self, request, callback)
    -- plenary job creation
    job:new({
        command = "find",
        args = {
            vim.fn.expand("~/docs/test_zk/"),
            "-maxdepth",
            "1",
            "-type",
            "f",
            "-printf",
            [[%f\n]],
        },
        on_exit = function(job)
            local result = job:result()
            local items = {}
            for _, i in ipairs(result) do
                table.insert(items, {   -- and add to actual formated list for cmp
                label = i,
                documentation = {
                    kind = "markdown",
                    value = read_file(i),
                },
            })
            end
            callback({ items = items, isIncomplete = false })
        end,
    }):start()  -- and start it right away
end

-- called for each cmp completion request
source.complete = function(self, request, callback)
    -- if we triggered completion with our regex
    if request.completion_context.triggerCharacter == "[" then
        -- we list notes
        source:list_notes(request, callback)
    else
        -- otherwise, we triggered with just a char, so we find tags
        source:list_tags(request, callback)
    end
end

-- trigger for tag completion
source.get_trigger_characters = function()
    return { "#", "[" }
end

-- -- trigger on '[[' for note completion
-- source.get_keyword_pattern = function()
--     return [[\[\{2}]]
-- end

-- only run for custom zk filetype
source.is_available = function()
    return vim.bo.filetype == "zk"
end

return source
