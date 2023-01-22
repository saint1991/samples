use std::fmt::Debug;

#[derive(Debug)]
struct A<'a> {
    message: &'a str,
    num: i32,
}

fn main() {
    let mut v1: Vec<i32> = Vec::new();
    v1.push(1);

    let v2 = vec![1, 2, 3, 4];
    let _el0: &i32 = &v2[0];

    let el3 = v2.get(3);
    print_result(el3);

    let el4 = v2.get(4);
    print_result(el4);

    print_all(&v2);

    let mut v3 = vec![10, 20, 30];
    plus10_all(&mut v3);
    print_all(&v3);


    let mut v4 = vec![
        A {
            message: "abc",
            num: 3,
        },
        A {
            message: "def",
            num: 4,
        }
    ];
    for i in &v4 {
        let i2 = i;
        println!("{:?}", i);
        println!("{:?}", i2);
    }
}

fn print_result(op: Option<&i32>) {
    match op {
        Some(v) => println!("{:?}", v),
        None => println!("none"),
    };
}

fn print_all<T: Debug>(v: &Vec<T>) {
    for element in v {
        print!("{:?}, ", element);
    }
    println!();
}

fn plus10_all(v: &mut Vec<i32>) {
    for element in v {
        *element += 10;
    }
}
