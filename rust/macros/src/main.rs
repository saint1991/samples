use std::collections::HashMap;

#[allow(unused)]
enum Json {
    String(String),
    Bool(bool),
    Number(f64),
    Null,
    Array(Vec<Json>),
    Object(std::boxed::Box<HashMap<String, Json>>)
}

macro_rules! impl_from_num_for_json {
    ( $( $t:ident ),*) => {
        $(
            impl From<$t> for Json {
                fn from(t: $t) -> Json {
                    Json::Number(t as f64)
                }
            }
        )*
    };
}

impl_from_num_for_json!(i32, u64, u32, i8);


fn main() {
    println!("Hello, world!");
    let i: i32 = 1;
    let _ = Json::from(i);
}
