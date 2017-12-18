
function print(str: string): void {
    console.log(str);
}

const printAnonymous = (str: string): void => {
    console.log(str);
};

const printAnotherAnonymous = function(str: string) {
    console.log(str);
};

const useFuncType: (x: number, y: number) => number = (x: number, y: number): number => {
    return x + y;
};

// y is optional parameter
const hasOptional = (x: number, y?: number): void => {
    console.log(y);
};

const hasDefault = (x: number, y = 1): number => {
    return x + y;
};

// overloads
function concat(str1: string, str2: string);
function concat(...strs: string[]): void  {
    console.log(strs.join(","));
}



const useThis = function(this: void) {

};