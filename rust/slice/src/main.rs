fn main() {
    println!("first word: {}", first_word(&String::from("Hello, world!")));
    println!(
        "second word: {}",
        second_word(&String::from("Hello, world!"))
    );
    println!("second word: {}", second_word("Hello"));
}

fn first_word(str: &String) -> &str {
    for (i, &item) in str.as_bytes().iter().enumerate() {
        if item == b' ' {
            return &str[0..i];
        }
    }
    &str[..]
}

fn second_word(str: &str) -> &str {
    let mut cnt_spaces = 0;
    let mut head = 0;
    for (i, &item) in str.as_bytes().iter().enumerate() {
        if item == b' ' {
            cnt_spaces += 1;
            if cnt_spaces == 1 {
                head = i + 1;
            } else if cnt_spaces >= 2 {
                return &str[head..i];
            }
        }
    }
    if cnt_spaces == 1 {
        return &str[head..];
    }
    return &str[str.len()..];
}
