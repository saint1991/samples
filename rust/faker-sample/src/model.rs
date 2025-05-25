use fake::faker::address::en::CityName;
use fake::faker::chrono::ja_jp::DateTimeBetween;
use fake::faker::company::ja_jp::CompanyName;
use fake::faker::internet::en::SafeEmail;
use fake::faker::lorem::en::Sentence;
use fake::faker::name::ja_jp::Name;
use fake::faker::phone_number::ja_jp::{CellNumber, PhoneNumber};
use fake::rand::seq::IndexedRandom;
use fake::utils::{WrappedVal, either};
use fake::uuid::UUIDv4;

#[derive(Debug, fake::Dummy)]
pub struct Account {
    #[dummy(faker = "UUIDv4")]
    pub account_id: String,

    #[dummy(faker = "Name()")]
    pub name: String,

    #[dummy(faker = "10..100")]
    pub age: u8,

    #[dummy(faker = "either(PhoneNumber(), CellNumber())", wrapper = "WrappedVal")]
    pub phone_number: String,

    #[dummy(faker = "CompanyName()")]
    pub company: String,

    #[dummy(faker = "SafeEmail()")]
    pub email: String,

    #[dummy(faker = "CityName()")]
    pub address: String,

    #[dummy(faker = r#"DateTimeBetween(
            chrono::DateTime::<chrono::Utc>::from_naive_utc_and_offset(
                chrono::NaiveDate::from_ymd_opt(2024, 10, 1)
                    .unwrap()
                    .and_hms_opt(0, 0, 0)
                    .unwrap(),
                chrono::Utc,
            ),
            chrono::DateTime::<chrono::Utc>::from_naive_utc_and_offset(
                chrono::NaiveDate::from_ymd_opt(2025, 5, 12)
                    .unwrap()
                    .and_hms(23, 59, 59),
                chrono::Utc,
            ),
        )"#)]
    pub registered_at: chrono::DateTime<chrono::Utc>,

    #[dummy(faker = "Sentence(100..150)")]
    pub memo: String,
}

const ITEMS: &[&str] = &[
    "Apple",
    "Banana",
    "Orange",
    "Grapes",
    "Watermelon",
    "Pineapple",
    "Strawberry",
    "Blueberry",
    "Mango",
    "Peach",
    "Kiwi",
    "Papaya",
    "Coconut",
    "Lemon",
    "Lime",
    "Cherry",
    "Plum",
    "Apricot",
    "Raspberry",
    "Blackberry",
];

#[derive(Debug)]
pub struct Item {
    pub name: String
}

impl fake::Dummy<Item> for String {
    fn dummy_with_rng<R: fake::rand::Rng + ?Sized>(_: &Item, rng: &mut R) -> Self {
        ITEMS.choose(rng).unwrap().to_string()
    }
}

impl fake::Dummy<fake::Faker> for Item {
    fn dummy_with_rng<R: fake::Rng + ?Sized>(config: &fake::Faker, rng: &mut R) -> Self {
        let name = ITEMS.choose(rng).unwrap().to_string();
        Item { name }
    }
}

#[derive(Debug, fake::Dummy)]
pub struct Purchase {
    #[dummy(faker = "UUIDv4")]
    pub purchase_id: String,

    #[dummy(faker = "DateTimeBetween(
            chrono::DateTime::<chrono::Utc>::from_naive_utc_and_offset(
                chrono::NaiveDate::from_ymd_opt(2024, 10, 1)
                    .unwrap()
                    .and_hms_opt(0, 0, 0)
                    .unwrap(),
                chrono::Utc,
            ),
            chrono::DateTime::<chrono::Utc>::from_naive_utc_and_offset(
                chrono::NaiveDate::from_ymd_opt(2025, 5, 12)
                    .unwrap()
                    .and_hms(23, 59, 59),
                chrono::Utc,
            ),
        )")]
    pub purchased_at: chrono::DateTime<chrono::Utc>,

    pub item: Item,

    #[dummy(faker = "1..20")]
    pub amount: u8,

    #[dummy(faker = "Sentence(5..20)")]
    pub memo: String,
}
