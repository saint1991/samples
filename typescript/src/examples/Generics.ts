
function identity<T>(arg: T): T {
    return arg;
}

function identityArr<T>(args: T[]): T[] {
    return args;
}

const id = <T>(arg: T): T => {
    return arg;
};

class GenericRecord<T> {
    private elements: T[];
    add(element: T): void {
        this.elements.push(element);
    }
    show(): void {
        console.log(this.elements);
    }
}

export default function() {
    console.log(identity("hoge"));
    console.log(identity(10));
    console.log(identity<boolean>(true));
}