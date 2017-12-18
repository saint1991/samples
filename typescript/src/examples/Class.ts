
interface Person {
    firstName: string;
    lastName: string;
    age: number;
}


abstract class Mammal {
    abstract bow(): void;
}

class Programmer implements Person {

    static kind: string = "mammal";

    public firstName: string;
    public lastName: string;
    public age: number;
    public constructor(firstName: string, lastName: string, age: number) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.age = age;
    }
}

class Cat {

    // property: getter and setter are similar to C#
    private _owner: string;
    get owner() {
        return this._owner;
    }
    set owner(newOwner: string) {
        this._owner = newOwner;
    }

    // name and kind are considered as the property of this class
    public constructor(readonly name: string, public kind: string) {

    }
}



export default (): void => {
    const p = new Programmer("Saint", "Seiya", 26);
    console.log(p);

    const c: typeof Cat = Cat;
    const cat = new c("mike", "american");
    console.log(cat);
};