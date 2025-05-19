
class Base:
    def __init__(self, name: str):
        self.name = name
        print(f"Base - {name} ")

class A(Base):
    def __init__(self):
        super().__init__("A")
        print("A - A")

class BaseB:
    def __init__(self, n: int):
        super().__init__()
        print(f"Base - {n}")

class Super(A):
    def __init__(self):
        Base.__init__(self, "SuperA")
        print("Super - SuperA")

class SuperB(BaseB):
    def __init__(self):
        Base.__init__(self, "A")
        print("Super - SuperB")

if __name__ == "__main__":
    s = SuperB()
    print(isinstance(s, Base))
    
    # super_b = SuperB()
