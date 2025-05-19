
export default () => {

    const sampleArr = ["aaa", "bbb"];

    for (const value of sampleArr) {
        console.log(value); // unlike for in clause the value takes aaa, bbb for each iteration
    }

    for (const value in sampleArr) {
        console.log(value); /// 0, 1
    }
};