vim.filetype.add({
	extension = {
		als = "alloy",
	},
})

-- Add the plugin's bundled parser to Neovim's search path
local plugin_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")
vim.opt.runtimepath:append(plugin_dir)

vim.treesitter.language.register("alloy", "alloy")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "alloy",
	callback = function(args)
		vim.treesitter.start(args.buf, "alloy")
	end,
})

local alloy_jar = vim.fn.expand("~/Programs/alloy-6.2.0/lib/app/org.alloytools.alloy.dist.jar")

plugin_dir = vim.fn.stdpath("data") .. "/lazy/alloy.nvim"

local getPath = function(str, sep)
	sep = sep or "/"
	return str:match("(.*" .. sep .. ")")
end

local sysOutToBuffer = function(sysout)
	local buffer = vim.api.nvim_create_buf(false, true)

	local output = sysout.code == 0 and sysout.stdout or sysout.stderr
	local lines = vim.split(output or "", "\n", { trimempty = true })

	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, lines)
	vim.api.nvim_win_set_buf(0, buffer)
end

vim.api.nvim_create_user_command("AlloyExec", function(_)
	local target_file = vim.api.nvim_buf_get_name(0)
	local out_dir = getPath(target_file) .. "out"

	vim.system(
		{ "sh", "-c", 'java -jar "' .. alloy_jar .. '" exec -f -t json -o "' .. out_dir .. '" ' .. target_file },
		{ text = true },
		function(obj)
			vim.schedule(function()
				if obj.code ~= 0 then
					sysOutToBuffer(obj)
					return
				end

				local target_path = out_dir .. "/Default-solution-0.json"

				local alloy2dot = plugin_dir .. "/plugin/alloy2dot.py"
				vim.system(
					{ "sh", "-c", "python3 " .. alloy2dot .. " " .. target_path .. " 0 | graph-easy --as=boxart" },
					{ text = true },
					function(obj2)
						vim.schedule(function()
							sysOutToBuffer(obj2)
						end)
					end
				)
			end)
		end
	)
end, { nargs = 0 })
