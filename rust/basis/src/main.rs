use std::io::Write;
use std::str::FromStr;


fn main() {

    let args = std::env::args().skip(1);
    let numbers: Vec<u64> = args.map(| arg | {
        u64::from_str(&arg).expect("error occurred when parsing argument")
    }).collect();

    if numbers.len() == 0 {
        exit_with_usage();
    }

    let mut d = numbers[0];
    for m in &numbers[1..] {
        gcd(d, *m);
    }

    println!("The greatest divisor of {:?} is {}", numbers, d)
}

fn exit_with_usage() {
    writeln!(std::io::stderr(), "Usage gcd NUMBER...").unwrap();
    std::process::exit(1);
}
