
enum WeekDay {
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday
}

enum EngineerType {
    ServerSide = "Server",
    Frontend = "Frontend",
    DataEngineer = "Data"
}

const enum ShapeKind {
    Circle,
    Square,
}

// constant enum can become type as well
interface Circle {
    kind: ShapeKind.Circle;
    radius: number;
}

export default () => {
    console.log(WeekDay.Friday);
    console.log(WeekDay["Sunday"]);
    console.log(EngineerType.Frontend);
};

