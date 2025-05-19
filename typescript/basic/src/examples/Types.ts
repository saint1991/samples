
interface Serializable {
    toString(): string;
}

interface Runnable {
    run();
}

class Task implements Serializable {
    constructor() {

    }
    toString(): string {
        return "Hello World";
    }
}

class RunnableTask extends Task implements Runnable {
    run() {
        console.log(this.toString());
    }
}

// type guard
function isRunnableTask(task: any): task is RunnableTask {
    return task instanceof RunnableTask
}

// type alias
type Tree<T> = {
    value: T;
    left: Tree<T>;
    right: Tree<T>;
}

type LinkedList<T> = T & { next: LinkedList<T> };

type Name = string;
class Account {
    constructor(name: Name) {
        this.name = name;
    }
    name: Name;
    age: number;
}
const accountProp: keyof Account = "name"; // keyof Account Type is equivalent to a union of "name" |  "age"

function assertNever(x: never): never {
    throw new Error("Unexpected object: " + x);
}

type Readonly<T> = {
    readonly [P in keyof T]: T[P];
};
type Partial<T> = {
    [P in keyof T]?: T[P];
};

export default () => {
    const intersect: Serializable & Runnable = new RunnableTask();
    let union: Serializable | Runnable = new Task();
    union = new RunnableTask();
    (union as Runnable).run();

    const nullableString: null | string = "foo";
    console.log(nullableString!.charAt(2));

    const enumLike: "fizz" | "bazz" = "fizz";
    const weekDay: 1 | 2 | 3 | 4 | 5 | 6 | 7 = 2;
};
