fn main() {

    let number: i32 = 12;
    let _fp: f64 = 0.82;
    let c: char = 'c';
    let arr: [i32; 4] = [1, 2, 3, 4];
    let tup: (i32, char) = (number, c);

    println!("{}", tup.0);
    println!("{:?}", arr);
}
