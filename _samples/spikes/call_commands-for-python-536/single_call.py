# Generated/modified by AI RooCode 3.36.0, used model google/gemini-2.5-pro
import subprocess

def run_simple_command():
    """
    A simple example of calling subprocess.run with a static command.
    """
    print("Running a simple command...")
    result = subprocess.run(["ls", "-l"], capture_output=True, text=True)
    print("Command finished.")
    print("stdout:", result.stdout)
    print("stderr:", result.stderr)

if __name__ == "__main__":
    run_simple_command()