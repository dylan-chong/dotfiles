set phoneName to "Dylan's iPhone SE"

tell application "Finder" to open ("/" as POSIX file)

tell application "System Events" to tell outline 1 of scroll area 1 of splitter group 1 of window 1 of application process "Finder"
	set theElements to first UI element of every row whose name is phoneName
	repeat with e in theElements
		try
			if name of e is phoneName then
				tell e to perform action "AXOpen"
				exit repeat
			end if
		end try
	end repeat
end tell

tell application "System Events" to tell application process "Finder"
	repeat until button "Sync" of splitter group 1 of splitter group 1 of window phoneName exists
	end repeat

	click button "Sync" of splitter group 1 of splitter group 1 of window phoneName
end tell
