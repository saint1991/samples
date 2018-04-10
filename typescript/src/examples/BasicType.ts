
const error = (message: string): never => {
    throw new Error(message);
};

export const swap = (first: number, second: number): [number, number] =>  {
    [first, second] = [second, first];
    return [first, second];
};

type C = {a: string, b?: number};
const destructure = ({a, b}: C): void => {
    console.log(a, b);
};

const merge = (): void => {
    const a = {a: 4, b: 5, c: 6};
    const b = {a: 10, d: 4};
    const merged = {...a, ...b};
    console.log(merged);
};

const spread = (): void => {
    const a: number[] = [1, 2, 3, 4];
    const b: number[] = [5, 6];
    const c: number[] = [...a, ...b];
    console.log(c);
};

function basic(): void {

    // basic types
    const name: string = "saint1991";
    const flag: boolean = true;
    const age: number = 26;
    const footSize: number = 26.5;

    // array
    const favoriteComics: string[] = [
        "PHYCHO-PASS",
        "SLAM DUNK"
    ];

    // tuple
    const tuple: [string, number] = ["This is tuple", 3];

    // enum
    enum EngineerType {Frontend, Backend, Infrastructure}
    const myType: EngineerType = EngineerType.Backend;

    // optout type check
    // let declared variables have block scope unlike var declared variables
    let noTypeCheck: any = 1;
    noTypeCheck = favoriteComics;

    const nothing: void = undefined;

    // union type can use as either one type specified a list of types with delimiter |
    const union: string | number | null = 1;

    // type assertion
    const anyStr: any = "Any";
    const castedStr: string = anyStr as string;

    // object destructuring
    const obj = {
        a: "a",
        b: "b",
        c: "c"
    };
    const {a, b} = obj;

    // multiline string
    console.log(`Hello! I am ${name}! I am ${age} years old now.
I'm  working as a ${EngineerType[EngineerType.Backend]} familiar with Data Engineering.
I am also interested in Data science e.g. Machine Learning.
Here are my favorite comics ${favoriteComics}. Thank you!`);
};

export default basic;
