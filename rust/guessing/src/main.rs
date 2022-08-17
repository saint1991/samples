use rand::Rng;

fn main() {
    let number = rand::thread_rng().gen_range(1..101);

    loop {
        println!("Guess the number: ");

        let mut guessed: String = String::new();
        let _bytes = match std::io::stdin().read_line(&mut guessed) {
            Err(e) => panic!("{:?}", e),
            Ok(bytes) => bytes,
        };

        let guessed: i64 = match guessed.trim().parse() {
            Err(_) => continue,
            Ok(num) => num,
        };

        match guessed.cmp(&number) {
            std::cmp::Ordering::Less => println!("Too small."),
            std::cmp::Ordering::Equal => {
                println!("Correct!");
                break;
            }
            std::cmp::Ordering::Greater => println!("Too big"),
        }
    }
}
