" View Breakpoints
let g:WhichKeyDesc_Debug_ViewBreakpoints = "<leader>dB view-breakpoints"
nnoremap <leader>dB    :action ViewBreakpoints<CR>
vnoremap <leader>dB    <Esc>:action ViewBreakpoints<CR>

" Toggle breakpoint
let g:WhichKeyDesc_Debug_ToggleBreakpoint = "<leader>db toggle-breakpoint"
nnoremap <leader>db    :action ToggleLineBreakpoint<CR>
vnoremap <leader>db    <Esc>:action ToggleLineBreakpoint<CR>

" Clear all breakpoints
let g:WhichKeyDesc_Debug_ClearAllBreakpoints = "<leader>dC clear-all-breakpoints"
nnoremap <leader>dC    :action Debugger.RemoveAllBreakpointsInFile<CR>
vnoremap <leader>dC    <Esc>:action Debugger.RemoveAllBreakpointsInFile<CR>

" Continue (Go to next breakpoint). 'c' is the same as gdb.
let g:WhichKeyDesc_Debug_Continue = "<leader>dc continue"
nnoremap <leader>dc    :action Resume<CR>
vnoremap <leader>dc    <Esc>:action Resume<CR>

" Debug class
let g:WhichKeyDesc_Debug_DebugClass = "<leader>dD debug-class"
nnoremap <leader>dD    :action DebugClass<CR>
vnoremap <leader>dD    <Esc>:action DebugClass<CR>

" Debug
let g:WhichKeyDesc_Debug_Debug = "<leader>dd debug"
nnoremap <leader>dd    :action Debug<CR>
vnoremap <leader>dd    <Esc>:action Debug<CR>

" Next (Step over). 's' is the same as gdb
let g:WhichKeyDesc_Debug_StepOver = "<leader>dn step-over"
nnoremap <leader>dn    :action StepOver<CR>
vnoremap <leader>dn    <Esc>:action StepOver<CR>

" Step out (same as "finish" in gdb).
let g:WhichKeyDesc_Debug_StepOut = "<leader>do step-out"
nnoremap <leader>do    :action StepOut<CR>
vnoremap <leader>do    <Esc>:action StepOut<CR>

" Select configuration and debug
let g:WhichKeyDesc_Debug_SelectDebugConfiguration = "<leader>dr select-debug-configuration"
nnoremap <leader>dr    :action ChooseDebugConfiguration<CR>
vnoremap <leader>dr    <Esc>:action ChooseDebugConfiguration<CR>

" Step (Step into). 's' is the same as gdb.
let g:WhichKeyDesc_Debug_StepInto = "<leader>ds step-into"
nnoremap <leader>ds    :action StepInto<CR>
vnoremap <leader>ds    <Esc>:action StepInto<CR>
