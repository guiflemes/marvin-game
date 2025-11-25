run_trace:
	zig build --release=fast -Dsingle-threaded -Dreference-trace

run_game:
	zig build run

run_sandbox:
	zig build run-sandbox
