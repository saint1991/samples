fn main() {
    let mut str = String::from("Hello");

    let s1 = &mut str;

    concat_aaa(s1);
    let length = str_len(&str);

    println!("The length of '{}' is {}.", str, length);
}

fn concat_aaa(s: &mut String) {
    s.push_str("aaa");
}

fn str_len(s: &String) -> usize {
    s.len()
}
