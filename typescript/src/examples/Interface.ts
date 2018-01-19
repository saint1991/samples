
interface Introduction {
    readonly firstName: string;  // readonly fields can be substituted only when object construction
    readonly lastName: string;
    readonly age: number;
    readonly zipCode?: string;
    readonly [others: string]: any;
    greet(): void;               // method
}

interface ExtraIntroduction extends Introduction {
    readonly nationality: string;
}

// Interface for a function
interface Greeting {
    (name: string): void; // function that takes a string parameter and returns nothing
}

interface Indexable {
    readonly [key: string]: number; // string -> number map interface. string or number can be taken as index
}

const GreetingFunc: Greeting = (name: string) => {
    console.log("Hello ${name}");
};

const printIntroduction = (intro: Introduction): void => {
    console.log(`
        firstName: ${intro.firstName}
        lastName: ${intro.lastName}
        age: ${intro.age}
        zipCode: ${intro.zipCode}
    `);
};

const arr = (): void => {
    const immutableArr: ReadonlyArray<number> = [1, 2, 3, 4];
    console.log(immutableArr);
};

export default () => {
    const intro: Introduction = {
        firstName: "saint",
        lastName: "seiya",
        age: 26,
        gender: "male",
        greet(){
            console.log("Hello!!")
        }
    };
    printIntroduction(intro);
};