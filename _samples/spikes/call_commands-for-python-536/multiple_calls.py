# Generated/modified by AI RooCode 3.36.0, used model google/gemini-2.5-pro
import subprocess
import os

def run_multiple_commands():
    """
    Examples of calling subprocess.run with various syntax combinations.
    """
    print("Running multiple commands...")

    # Example 1: Command as a list of strings
    command1 = ["echo", "Hello from command 1"]
    subprocess.run(command1)

    # Example 2: Command as a single string with shell=True
    command2 = "echo 'Hello from command 2'"
    subprocess.run(command2, shell=True)

    # Example 3: Using a variable for the executable
    ls_executable = "ls"
    subprocess.run([ls_executable, "-a"])

    # Example 4: Checking for errors.
    # We try to list a non-existent file, which will cause 'ls' to fail.
    # With `check=True`, this will raise a CalledProcessError.
    non_existent_file = "this_file_does_not_exist.tmp"
    try:
        # Ensure the file doesn't exist before running the command
        if os.path.exists(non_existent_file):
            os.remove(non_existent_file)
            
        print(f"\nAttempting to run a command that will fail: ls {non_existent_file}")
        subprocess.run(["ls", non_existent_file], check=True, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError as e:
        print(f"Command failed as expected.")
        print(f"Return code: {e.returncode}")
        # stderr is in bytes, so we decode it
        print(f"Stderr: {e.stderr.decode().strip()}")

if __name__ == "__main__":
    run_multiple_commands()