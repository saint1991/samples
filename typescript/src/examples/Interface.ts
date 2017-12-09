
interface Introduction {
    readonly firstName: string;  // readonly fields can be substituted only when object construction
    readonly lastName: string;
    readonly age: number;
    readonly zipCode?: string;
}

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
    };
    printIntroduction(intro);
};