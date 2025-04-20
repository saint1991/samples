import time

from timeout_decorator import timeout, TimeoutError

@timeout(5)
def long_running_function():
    """A long running function that will be interrupted by the timeout decorator."""
    print("Starting long running function...")
    for i in range(100000000000):
        print(f"running.... {i}")

def main():
    for i in range(10):
        try:
            long_running_function()
        except TimeoutError:
            print("Timeout!")

    print("End")


if __name__ == "__main__":
    main()
