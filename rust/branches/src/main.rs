fn main() {
    even_or_odd(7);
    let num = process_number(3);
    println!("{}", num);
    looping();
    for_loop();
}

fn even_or_odd(x: i32) {
    if x % 2 == 0 {
        println!("{} is even", x);
    } else {
        println!("{} is odd", x);
    }
}

fn process_number(x: i32) -> i32 {
    if x == 0 {
        -1
    } else if x == 1 {
        1
    } else {
        x * x
    }
}

fn looping() {
    let mut x = 1;
    'looop: loop {
        x = x + 1;
        if x > 10 {
            break 'looop
        }
    }
}

fn for_loop() {
    let arr = [1, 2, 3];
    for n in arr {
        println!("{}", n);
    }
}