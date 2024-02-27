import sublime, sublime_plugin, subprocess, pathlib

class BuildifierHook(sublime_plugin.EventListener):
    def on_post_save(self, view):
        filename = pathlib.Path(view.file_name())
        if not (filename.name == "BUILD"
                or filename.name.startswith("BUILD.")
                or filename.suffix in [".BUILD", ".bzl"]):
            return
        try:
            subprocess.run(
                ["buildifier", view.file_name()],
                check=True,
                capture_output = True
            )
            view.run_command("revert")  # reload
            print("Reformatted", view.file_name())
        except subprocess.CalledProcessError as e:
            print(e.stderr.decode())