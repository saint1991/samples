from dataclasses import dataclass, field, asdict, fields
import enum
from typing import Any, TypeAlias


class Color(enum.Enum):
    RED = "RED"
    GREEN = "GREEN"
    BLUE = "BLUE"


class Serializable:
    def to_serializable_dict(self) -> dict[str, Any]:
        result = {}
        for field in fields(self):
            value = getattr(self, field.name)
            # Check if the value is an instance of enum.Enum
            if isinstance(value, enum.Enum):
                result[field.name] = value.value
            else:
                result[field.name] = value
        return result


@dataclass(frozen=True)
class Base(Serializable):
    color: Color
    identity: str

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass(frozen=True)
class BlueCard(Base):
    color: Color = field(init=False, default=Color.BLUE)
    point: int


@dataclass(frozen=True)
class GreenCard(Base):
    color: Color = field(init=False, default=Color.GREEN)


@dataclass(frozen=True)
class RedCard(Base):
    color: Color = field(init=False, default=Color.RED)
    penalty: float


Card: TypeAlias = BlueCard | GreenCard | RedCard


if __name__ == "__main__":
    blue: Card = BlueCard(identity="blue", point=10)
    green = GreenCard(identity="green")
    red = RedCard(identity="red", penalty=0.5)
    print(blue.to_serializable_dict())
    print(green.to_serializable_dict())
    print(red.to_serializable_dict())
