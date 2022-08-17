fn main() {
    another_fn();
    print_num(8);
    let v = squared_2d(3, 4);
    println!("v is {}", v);
}

fn another_fn() {
    println!("Another fn");
}

fn print_num(x: i32) {
    println!("The value is {}", x);
}

fn squared_2d(x: i32, y: i32) -> i32 {
    x * x + y * y
}